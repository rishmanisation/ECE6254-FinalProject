function [Image, alpha] = loadTargetImage(filename, D)
%function loadTargetImage(filename, D)
%   Returns the image and an alpha channel to aid in overlay
%   filename = the path and file to load
%   D = diameter (in pixels) to scale the image to

[Image, map] = imread(filename);

ImageClass    = class( Image );
[ Y, X, Z ]   = size( Image );

if strcmp(ImageClass, 'double') || Z ~= 1
    Image = rgb2gray( Image );
end

scale_factor = D/max(Y,X);

Image = imresize(Image, scale_factor);

% Eric, I  had to reduce the threshold for the alpha channel because the
% background wasnt being removed.
alpha = (Image >= 250);

% I'm gonna change the polarity of the image to make things white-hot as
% you would see from an infrared image.
Image = max(max(Image)) - Image;

Image = cast(Image, 'double');
return