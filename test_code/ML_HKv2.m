function ML_HKv2(top, left, right, bottom, target)
% Originally from https://www.mathworks.com/matlabcentral/answers/45017-this-is-an-implementation-for-how-to-use-maximum-likelihood-in-segmentation-in-image-processing

close all;

%------------------------------------------------------------------------%
% Generate the test targets
%------------------------------------------------------------------------%
image=zeros(256,256);
image(256/4:3*(256/4),256/4:3*(256/4))=200;
%object1=image(256/4:3*(256/4),256/4:3*(256/4));
image(10:60,10:60)=150;
%object2=image(10:60,10:60);

%------------------------------------------------------------------------%
% Normalize the image
%------------------------------------------------------------------------%
image=image/255;
% figure('Name','Original Image','NumberTitle','off'); imshow(image);

%------------------------------------------------------------------------%
% Add some noise
%------------------------------------------------------------------------%
[r c]   = size(image);
s_avg   = sum(sum(image))/(r*c);
SNR     = 10;
n_sigma = s_avg/(10^(SNR/20));
n       = n_sigma*randn(size(image));
image   = image+n;

%------------------------------------------------------------------------%
% Display the results
% The first is displaying the entire image's histogram. In our application,
% we will not be able to do so. Instead, we will be looking at only our
% target region and the accompanying background regions.
%------------------------------------------------------------------------%
figure('Name','Image+Noise Histogram','NumberTitle','off'); 
imhist(image);
figure('Name','Image+Noise','NumberTitle','off');           
imshow(image);

%------------------------------------------------------------------------%
% PDF of the intensity of a background pixel.
% This portion is acquiring the background pixels by dissecting a portion
% of the image. In our application, we have the background regions (top,
% bottom, lft, right) which will be used.
%------------------------------------------------------------------------%
backgound_data = image(1:50,70:150);
figure('Name','Background Histogram','NumberTitle','off'); 
imhist(backgound_data);

% Find the parameters for MLE
backgound_mean = mean( backgound_data(:) );
backgound_std  = std(  backgound_data(:) );
backgound_var  = var(  backgound_data(:) );

% backgound_pdf   = normpdf(backgound,0,1);
% figure,plot(backgound,backgound_pdf);

%------------------------------------------------------------------------%
% PDF of the intensity of an object pixel.
% This portion is acquiring the target pixels by dissecting a portion
% of the image. In our application, we have the target region.
%------------------------------------------------------------------------%
target  = image(256/4:3*(256/4),256/4:3*(256/4));
figure('Name','Target Histogram','NumberTitle','off'); 
imhist(target);

% Find the parameters for MLE
target_mean = mean( target(:) );
target_std  = std(  target(:) );
target_var  = var(  target(:) );
% object_pdf = normpdf(object,200,1);
% figure,plot(object,object_pdf);

%------------------------------------------------------------------------%
% PDF of the object and background.
% This will be more of a resemblance of what our pdfs will looks like.
%------------------------------------------------------------------------%
data  = [ target(:); backgound_data(:) ];
figure('Name','Target + Background','NumberTitle','off'); 
imhist(data);

%------------------------------------------------------------------------%
% Segmentation
% This is where all the magic happens. Since we have the statistics on our
% data from the regions, we can estimate what the background and target
% should be looking like. We take these stats, and compute the probability
% of the pixel being either the target or background based on our
% assumptions. We then decide a hard grouping (1 or 0) if it passed the
% threshold. 
% In our case, we'd only apply this to the target region and not the entire
% image.
%------------------------------------------------------------------------%

% This is probably the fastest way I know how to compute the threshold.
% Here, we are just doing matrix computations all at one.
prob_target     = 1/(sqrt(2*pi) * target_var)    * exp( -1*(( image - target_mean    ).^2 /( 2*target_var^2    ) ));
prob_background = 1/(sqrt(2*pi) * backgound_var) * exp( -1*(( image - backgound_mean ).^2 /( 2*backgound_var^2 ) ));
image_thresh    = (prob_background < prob_target); 

figure('Name','Segmentation1','NumberTitle','off'); 
imshow(image_thresh);

% This is the other method where you can do each individual pixel at a
% time. There is also a fancy overlay method that was thrown in here from
% the link at the top.
array=[0 0];
k=1;
   for i=1:size(image,1)
       for j=1:size(image,2)
           
           % Find probabilities
           prob_target     = 1/(sqrt(2*pi) * target_var)    * exp( -1*(( image(i,j) - target_mean    )^2/( 2*target_var^2    ) ));
           prob_background = 1/(sqrt(2*pi) * backgound_var) * exp( -1*(( image(i,j) - backgound_mean )^2/( 2*backgound_var^2 ) ));
           
           % Decision
           if prob_background < prob_target
               array(k,:)=[i j];
               k=k+1;
           end      
       end
   end
   map=[];
   
   figure('Name','Segmentation2','NumberTitle','off'); 
   plotting(array,image,map);
end

% Just does some fancy overlaying to show you what is and isnt a target
function plotting(FParray,fseg,map)
colormap(map)
imshow(fseg);
axis off
hold on
FPSize= size(FParray,1);
for i=1:FPSize
        rectangle('Position',[FParray(i,1), FParray(i,2), 1, 1],'Curvature', [1,1],'FaceColor','r','EdgeColor','r');
end
f=getframe(gca);
[X, map] = frame2im(f);
%imwrite(X,'FeaturePoints.png','png')
end