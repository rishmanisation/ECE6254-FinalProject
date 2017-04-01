%% Clear Matlab
clear all;
close all;
clc;

%% Load Image

% Manual Image Selection
path = strcat( fileparts(pwd), '\images');
[filename,filepath] = uigetfile(fullfile(path , '*'), 'Select an Image');

% Auto Image Selection
% filepath = 'C:\Users\Ben\Desktop\ECE6254\FinalProject\code\images\';
% filename = 'autumn.tif';

fprintf('Loading Input Image: %s \n', filename);
[ Image map ] = imread( strcat(filepath, filename) );

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
    Image = im2uint16(Image);
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

% Crop to a square image.
% Cropping the image to a square is done to improve the PSD estimation and
% generation. The PSD estimation uses the FFT for spatial frequency
% estimations and to reduce complexity, a square image is used.
[ Y, X ] = size( Image );
dimDiff  = abs(Y-X);
dimMax   = max(Y,X);

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

%% Analyze Scene
% This function analyzes an input image's spatial frequency characteristics
% and generates a vector of assosciated weights. These weights provide
% information regarding the input image makeup for future synthetic image
% generation. The PSD of the input image can be used to benchmark Easy,
% Medium, and Hard clutter environments. With the input image weights, a
% synthetic image can be created to replicate on of the benchmark
% scenarious.
fprintf('Analyzing Images Clutter Characteristics... \n');

[ SpatialFreqs, Weights, SDev ] = AnalyzeClutter( Image );

%% Generate Clutter Scenes
% The clutter generation uses the input spatial frequency weights to create
% a synthetic image with characteristics similiar to that of the original
% input image. The correlation coefficient is a way of toleratin
% relationship strengths between spatial frequencies. 80% correlation seems
% to add a more organic shape to the clutter patches.
fprintf('Generating Synthetic Clutter Scene... \n');

SFcorrelation = 0.8;
[Clutter] = MakeClutter(SDev, 0, size(Image), 1./SpatialFreqs, Weights, SFcorrelation);

% Rescale Clutter to Input Image Range
% The Clutter image has an inherent zero mean noise injection which makes
% the pixel values span across both positive and negative regions. The
% first step is to shift pixel components to the positive space. The second
% step involves rescaling the dynamic range to that of the original image.
% The last step involves another bias to the original image's dynamic range
% space.
% The importance of this step is to reconstitute the Clutter image to
% something similiar to the original Image. This breaks the "purist"
% approach to the PSD relation, but is necessary to generate similiar image
% characteristics as those seen in the real world.
Clutter = Clutter - min(min(Clutter));
Clutter = Clutter *  ( max(max(Image))   - min(min(Image))   ) / ...
                     ( max(max(Clutter)) - min(min(Clutter)) );
Clutter = Clutter + min(min(Image));

%% Power Spectrum Results
% The radially averaged PSD is depicted in the generated graphs from the
% function below. Although this does not give a "perfect" representation of
% the image's PSD, it doe's provide a quick and easy method of determining
% a synthetic image's relationship between benchmarks. The original and
% synthetic image PSDs should be relatively similiar to effectively be
% qualified as suitable.
fprintf('Generating Power Spectrum Graphs... \n');

res = 1;
[nuImage,  PfImage]   = raPsd2d(Image,   res);                % Compute the PSD
[nuClutter,PfClutter] = raPsd2d(Clutter, res);                % Compute the PSD
plot_radial_psd_test(nuImage, PfImage, nuClutter, PfClutter);   % Display the Results

%% Debugging Code
figure; imagesc(  cast( ImageOriginal, ImageClass )    ); colorbar;
figure; imagesc(  cast( ImageCropped, ImageClass )    );  colorbar;
figure; imagesc( Clutter    );                            colorbar;