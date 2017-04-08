function [ ImageCropped ] = loadImage( preSelectedImage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Load Image

% Only allow image selection if one is not provided
if nargin == 0
    % Manual Image Selection
    path = strcat( fileparts(pwd), '\images');
    [filename,filepath] = uigetfile(fullfile(path , '*'), 'Select an Image');

    % Auto Image Selection
    % filepath = 'C:\Users\Ben\Desktop\ECE6254\FinalProject\code\images\';
    % filename = 'autumn.tif';

    fprintf('Loading Input Image: %s \n', filename);
    [ Image map ] = imread( strcat(filepath, filename) );
else

    fprintf('Loading Input Image: %s \n', preSelectedImage);
    [ Image map ] = imread( preSelectedImage );
    
end

%% Pre-Processing
% Generic processing techniques for converting input images into an
% expected format. This is done to aid the algorithms at the beggining of
% development.
fprintf('Pre-Processing Image... \n');

% Handle Different Image Types
% Converts Tiff images which are uint8 inputs to Matlab into their RGB
% counterparts.
if ~isempty(map)
    Image = ind2rgb(Image, map);
    
    % Convert to 16 bits which helps reduce quantization errors when
    % compared to an 8 bit image.
    Image = im2uint8(Image);
end

% Convert to Gray Scale
% Some of the input images are not in monochrome gray scale. This function
% below converts the images to the expected format.
ImageClass    = class( Image );
[ Y, X, Z ]   = size( Image );

if strcmp(ImageClass, 'double') || Z ~= 1
    Image = rgb2gray( Image );
end

% Store Current Class Type and Convert to Double Precision. This is done to
% genericize processing against a single image format.
ImageClass    = class( Image );
ImageOriginal = Image;
Image         =  cast( Image, 'double' );

% Need to resize the image if it is too big. Large images increase the
% complexity of synthetic scenes. For now, just reduce the size and focus
% on the processing, we can remove this later.

Image = imresize(Image, [480,320]);

% Crop to a square image.
% Cropping the image to a square is done to improve the PSD estimation and
% generation. The PSD estimation uses the FFT for spatial frequency
% estimations and to reduce complexity, a square image is used.
[ Y, X ] = size( Image );
dimDiff  = abs(Y-X);

if Y > X                                                           	% More rows than columns
  if ~mod(dimDiff,2)                                               	% Even difference
    Image = Image(dimDiff/2+1:end-dimDiff/2, :);                  	% Pad columns to match dimensions
  else                                                             	% Odd difference
    Image = Image(floor(dimDiff/2)+1:floor(end-dimDiff/2), :); 
  end
elseif Y < X                                                       	% More columns than rows
  if ~mod(dimDiff,2)                                               	% Even difference
    Image = Image(:, dimDiff/2+1:end-dimDiff/2);                    % Pad rows to match dimensions
  else
    Image = Image(:, floor(dimDiff/2)+1:floor(end-dimDiff/2));      % Pad rows to match dimensions
  end
end

ImageCropped = Image;

end

