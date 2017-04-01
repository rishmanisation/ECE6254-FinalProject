function [ Clutter ] = computeSyntheticImage( Image )
% function raPsd2d(img,res)
%

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

plot_radial_psd(nuImage, PfImage, nuClutter, PfClutter);   % Display the Results

return;