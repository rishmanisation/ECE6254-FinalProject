% % Create our Target and Noise
% DC_Noise_lvl = 30;
% Random_Noise_lvl = 25;
% Target_Signal_lvl = 100;
% img_size_x = 64;
% img_size_y = 64;
% target_size = 4;
% target_location = 32;
% gaussian_size = 9;

% img = (DC_Noise_lvl)*ones(img_size_x,img_size_y) + (Random_Noise_lvl)*randn(img_size_x,img_size_y);
% target = zeros(img_size_x,img_size_y);
% target(target_location-target_size:target_location+target_size,target_location-target_size:target_location+target_size) = Target_Signal_lvl*gausswin(gaussian_size)*gausswin(gaussian_size)';
% img = img + target;

% img = rgb2gray(imread('Test_Images/man.jpg'));
% img_size_y = 640;
% img_size_x = 512;

clear all;close all;

% video_location = 'H:\Classes\Jolly\Senior_Design\Senior_Design_Project\Test_Images\Aero_Drone.AVI';
% video_location = 'C:\Users\Ben\Documents\Class\Jolly\Senior_Design\Test_Images\Aero_Drone.AVI';

filepath = strcat( fileparts(pwd), '\exampleKalman\');
filename = 'Aero_Drone.AVI';
video_location = strcat( filepath, filename );


if(1)
    img = VideoReader(video_location);
    original_image = img.read();
     img = rgb2gray(original_image(:,:,:,1350));
     %img = rgb2gray(original_image(:,:,:,945));
end

[img_size_y, img_size_x] = size(img);

%% Contrast Stretching
close all;

sub_image = zeros(img_size_y,img_size_x);
sub_image(120:140,180:200) = img(120:140,180:200);
copy_image = sub_image(:,:);
sub_image = reshape(sub_image,img_size_y*img_size_x,1);
sub_image = sort(sub_image,1,'descend');
max = sub_image(1);
avg = (sum(sub_image(:)))/(21*21);
%figure,imshow(((reference_image)/255));
%figure,imshow(smf((reference_image)/255,[avg max]));
%figure,imshow(((copy_image)/255));
%figure;imshow(smf((copy_image)/255,[avg max]));

copy_image(copy_image < avg) = 0;

for y = 1:img_size_y
    for x = 1:img_size_x
        if((copy_image(y,x) > avg) && (copy_image(y,x) < (avg+max)/2))
            copy_image(y,x) = 2*((copy_image(y,x)-avg)/(max-avg)).^2;
        elseif((copy_image(y,x) > (avg+max)/2) && (copy_image(y,x) < max))
            copy_image(y,x) = 1-2*((copy_image(y,x)-avg)/(max-avg)).^2;
        end
    end
end
    
    copy_image(copy_image > max) = 1;
figure;imshow(copy_image/255);

x = 0:0.001:1;
figure;plot(x, smf(x, [avg/255 max/255]));

%% Kalman Filter
close all; clear X P Z

% Initial Centroids
centroid_x = 110;
centroid_y = 100;

Z = [centroid_x;centroid_y;0;0];    % Initial Location.
X = Z;                              % Set the Inital location to the current location.
location_estimate = [];

dt = 1;
process_noise = 0.2;               % How fast the object is speeding/slowing (acceleration)
                                   % Increasing this variable improves
                                   % reaction to the object, but you
                                   % become more susceptable to noise.

measurement_noise = [   1   0
                        0   1];     % Noise in the measurements
                                    % Increasing this variable reduces
                                    % your susceptability to noise in
                                    % the environment but increases lag
                                    % time.
                                    % TL = Noise in x, BR = noise in y

P = [   dt^4/4  0       dt^3/2  0;  % Initial positions variance.
        0       dt^4/4  0       dt^3/2;
        dt^3/2  0       dt^2    0;
        0       dt^3/2  0       dt^2].*process_noise^2;

process_noise = P;                  % Process noise matrix

% State Transition Matrix
% State prediciton of the position.
A = [   1   0   dt  0   
        0   1   0   dt  
        0   0   1   0   
        0   0   0   1];

% Predicted Motion
B = [   dt^2/2
        dt^2/2
        dt
        dt]; 
   
start = 700;
end_frame = 955;

for t = start:1:end_frame
    image = double(rgb2gray(original_image(:,:,:,t)));
    image_prev = double(rgb2gray(original_image(:,:,:,t-1)));
    
    image_change = image - image_prev;
    image_change(image_change < 0) = 0;
    
    [correlation_fact, correlation_mat] = correlation(image_prev,image);
    image = ROI(image, 40, 40);
    image(image < 140) = 0;
    [centroid_x, centroid_y] = centroid(image);
    Z = [centroid_x;centroid_y;0;0];    % Initial Location.

   [X,P] = kalman_filter(X, P, Z, measurement_noise, process_noise, A, B)
   location_estimate = [location_estimate; X(1:2)];
    
    imagesc(image);
    axis off
    colormap(gray);
    hold on
    plot(centroid_x,centroid_y,'-.*k');     % Actual Location
    plot(X(1),X(2), 'o');                   % 
    hold off
    pause(0.1);
end





