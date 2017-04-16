function [phat,image_thresh]=MLE_image( top, left, right, bottom, target)
% Originally from https://www.mathworks.com/matlabcentral/answers/45017-this-is-an-implementation-for-how-to-use-maximum-likelihood-in-segmentation-in-image-processing

% close all;

%------------------------------------------------------------------------%
% Generate the test targets
%------------------------------------------------------------------------%
% image=zeros(256,256);
% image(256/4:3*(256/4),256/4:3*(256/4))=200;
% %object1=image(256/4:3*(256/4),256/4:3*(256/4));
% image(10:60,10:60)=150;
%object2=image(10:60,10:60);

%------------------------------------------------------------------------%
% Normalize the image
%------------------------------------------------------------------------%
target=target/255;
% figure('Name','Original Image','NumberTitle','off'); imshow(image);

%------------------------------------------------------------------------%
% Add some noise
%------------------------------------------------------------------------%
[r, c]   = size(target);
s_avg   = sum(sum(target))/(r*c);
SNR     = 10;
n_sigma = s_avg/(10^(SNR/20));
n       = n_sigma*randn(size(target));
target   = target+n;

%------------------------------------------------------------------------%
% Display the results
% The first is displaying the entire image's histogram. In our application,
% we will not be able to do so. Instead, we will be looking at only our
% target region and the accompanying background regions.
%------------------------------------------------------------------------%
% figure('Name','Target Histogram','NumberTitle','off'); 
% imhist(target);
% figure('Name','Target','NumberTitle','off');           
% imshow(target);

% Find the parameters for MLE
target_mean = mean( target(:) );
target_std  = std(  target(:) );
target_var  = var(  target(:) );

%------------------------------------------------------------------------%
% PDF of the intensity of a background pixel.
% This portion is acquiring the background pixels by dissecting a portion
% of the image. In our application, we have the background regions (top,
% bottom, lft, right) which will be used.
%------------------------------------------------------------------------%
% normalize the background image
top = top/255; bottom = bottom/255; left = left/255; right = right/255;
% figure('Name','Histogram for Background','NumberTitle','off'); 
% subplot(2,2,1);imhist(top);    title('Background Top');
% subplot(2,2,2);imhist(bottom); title('Background Bottom');
% subplot(2,2,3);imhist(left);   title('Background Left');
% subplot(2,2,4);imhist(right);  title('Background Right');

% Find the parameters for MLE
top_mean    = mean(top(:));    top_std    = std(top(:));    top_var    = var(top(:));
bottom_mean = mean(bottom(:)); bottom_std = std(bottom(:)); bottom_var = var(bottom(:));
left_mean   = mean(left(:));   left_std   = std(left(:));   left_var   = var(left(:));
right_mean  = mean(right(:));  right_std  = std(right(:));  right_var  = var(right(:));

% backgound_pdf   = normpdf(backgound,0,1);
% figure,plot(backgound,backgound_pdf);

%------------------------------------------------------------------------%
% PDF of the intensity of an object pixel.
% This portion is acquiring the target pixels by dissecting a portion
% of the image. In our application, we have the target region.
%------------------------------------------------------------------------%
% target  = image(256/4:3*(256/4),256/4:3*(256/4));
% figure('Name','Target Histogram','NumberTitle','off'); 
% imhist(target);


% object_pdf = normpdf(object,200,1);
% figure,plot(object,object_pdf);

%------------------------------------------------------------------------%
% PDF of the object and background.
% This will be more of a resemblance of what our pdfs will looks like.
%------------------------------------------------------------------------%
target_data = [target(:)];
[pixelCounts_target, grayLevels_target] = imhist(target_data);
target_pdf = pixelCounts_target / numel(target_data);

top_data  = [ target(:); top(:) ];
[pixelCounts_top, grayLevels_top] = imhist(top_data);
top_pdf = pixelCounts_top / numel(top_data);
% figure('Name','Target + Top Background','NumberTitle','off'); imhist(top_data);
bottom_data  = [ target(:); bottom(:) ];
[pixelCounts_bottom, grayLevels_bottom] = imhist(bottom_data);
bottom_pdf = pixelCounts_bottom / numel(bottom_data);
% figure('Name','Target + bottom Background','NumberTitle','off'); imhist(bottom_data);
right_data  = [ target(:); right(:) ];
[pixelCounts_right, grayLevels_right] = imhist(right_data);
right_pdf = pixelCounts_right / numel(right_data);
% figure('Name','Target + right Background','NumberTitle','off'); imhist(right_data);
left_data  = [ target(:); left(:) ];
[pixelCounts_left, grayLevels_left] = imhist(left_data);
left_pdf = pixelCounts_left / numel(left_data);

background_data = [top(:);bottom(:);right(:);left(:)];
[pixelCounts_back, grayLevels_back] = imhist(background_data);
background_pdf = pixelCounts_back / numel(background_data);

% figure('Name','Target + left Background','NumberTitle','off'); imhist(left_data);
custpdf = @(data,lambda) lambda*exp(-lambda*data);
phat_top = mle(top_data,'pdf',custpdf,'start',0.05);
phat_bottom = mle(bottom_data,'pdf',custpdf,'start',0.05);
phat_right = mle(right_data,'pdf',custpdf,'start',0.05);
phat_left = mle(left_data,'pdf',custpdf,'start',0.05);
phat_background = mle(background_data,'pdf',custpdf,'start',0.05);
phat_target = mle(target_data,'pdf',custpdf,'start',0.05);
phat = [phat_top,phat_bottom,phat_right,phat_left,phat_background,phat_target];
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
prob_target     = 1/(sqrt(2*pi) * target_var)    * exp( -1*(( target - target_mean    ).^2 /( 2*target_var^2    ) ));
prob_top        = 1/(sqrt(2*pi) * top_var)       * exp( -1*(( target - top_mean ).^2       /( 2*top_var^2 ) ));
prob_bottom     = 1/(sqrt(2*pi) * bottom_var)    * exp( -1*(( target - bottom_mean ).^2    /( 2*bottom_var^2 ) ));
prob_right      = 1/(sqrt(2*pi) * right_var)     * exp( -1*(( target - right_mean ).^2     /( 2*right_var^2 ) ));
prob_left       = 1/(sqrt(2*pi) * left_var)      * exp( -1*(( target - left_mean ).^2      /( 2*left_var^2 ) ));
image_thresh_top     = (prob_top < prob_target); %if the number is higher, it means not a background
image_thresh_bottom  = (prob_bottom < prob_target); 
image_thresh_right   = (prob_right < prob_target); 
image_thresh_left    = (prob_left < prob_target); 

image_thresh(:,:,1) = image_thresh_top;
image_thresh(:,:,2) = image_thresh_bottom;
image_thresh(:,:,3) = image_thresh_right;
image_thresh(:,:,4) = image_thresh_left;
% 
% figure('Name','Segmentation Top','NumberTitle','off'); 
% imshow(image_thresh_top);
% figure('Name','Segmentation Bottom','NumberTitle','off'); 
% imshow(image_thresh_bottom);
% figure('Name','Segmentation Right','NumberTitle','off'); 
% imshow(image_thresh_right);
% figure('Name','Segmentation Left','NumberTitle','off'); 
% imshow(image_thresh_left);

% % This is the other method where you can do each individual pixel at a
% time. There is also a fancy overlay method that was thrown in here from
% the link at the top.
% array=[0 0];
% k=1;
%    for i=1:size(image,1)
%        for j=1:size(image,2)
%            
%            Find probabilities
%            prob_target     = 1/(sqrt(2*pi) * target_var)    * exp( -1*(( image(i,j) - target_mean    )^2/( 2*target_var^2    ) ));
%            prob_background = 1/(sqrt(2*pi) * backgound_var) * exp( -1*(( image(i,j) - backgound_mean )^2/( 2*backgound_var^2 ) ));
%            
%            Decision
%            if prob_background < prob_target
%                array(k,:)=[i j];
%                k=k+1;
%            end      
%        end
%    end
%    map=[];
%    
%    figure('Name','Segmentation2','NumberTitle','off'); 
%    plotting(array,image,map);
% end
% 
% % Just does some fancy overlaying to show you what is and isnt a target
% function plotting(FParray,fseg,map)
% colormap(map)
% imshow(fseg);
% axis off
% hold on
% FPSize= size(FParray,1);
% for i=1:FPSize
%         rectangle('Position',[FParray(i,1), FParray(i,2), 1, 1],'Curvature', [1,1],'FaceColor','r','EdgeColor','r');
% end
% f=getframe(gca);
% [X, map] = frame2im(f);
% %imwrite(X,'FeaturePoints.png','png')
% end