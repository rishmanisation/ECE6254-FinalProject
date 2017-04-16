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
alpha = (Image == 255);
Image = cast(Image, 'double');
return