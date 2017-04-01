function [ SpatialFreqs, Weights, SDev ] = AnalyzeClutter( Image )
%AnalyzeClutter Computes Spatial Frequency Components and Weights
%   This function generates weights for specific spatial frequency
%   components based on the input image. These parameters are used for
%   synthetic image generation.

% Input Image Characteristics. Future support will utilize the image
% dimensions to compute the spatial frequencies/weights for non-square
% image inputs.
[ Y, X ] = size( Image );
dimMax   = max(Y,X);

% Initialize PSD Vectors
SpatialWeights = linspace(0, 0, dimMax/2);
SpatialFreqs = 1./(dimMax/2:-1:1);
SDevSum = 0;

% Modifying this parameter would allow for more than one input image. This
% is beneficial for scenarios where videos are analyzed and similiar
% synthetic image videos are produces. This is left as a future enhancement
% if needed.
NumFrames = 1;

for i = 1:NumFrames
    % Remove any singleton dimensions from the input image.
    Image = squeeze( Image );
    
    % Normalize the image.
    ImageNorm = Image - nanmean(nanmean(Image));
    
    % Compute the PSD of the input image using the FFT.
    fftImageNorm = fft2(ImageNorm);
    PSDimage = fftImageNorm.*conj(fftImageNorm);

    % The PSD of the image is symmetric. This code partitions the PSD into
    % four quadrants and overlays them amongst each other so that each is
    % summed with it's counterpart. The summation of the PSDs is normalized
    % as well.
    SumPSDimage = PSDimage(1:dimMax/2,1:dimMax/2) +...
                  fliplr(PSDimage(1:dimMax/2, dimMax/2 + 1:dimMax)) +...
                  flipud(PSDimage(dimMax/2 + 1:dimMax,1:dimMax/2)) +...
                  fliplr(flipud(PSDimage(dimMax/2 + 1:dimMax,dimMax/2 + 1:dimMax)))./4;

    % Compute the spatial content from the normalized PSD. This is weights
    % for the specific frequency component.
    SpatialContent = sum(SumPSDimage);
    
    % Normalize the spatial content (weights).
    NormSpatialContent = SpatialContent/SpatialContent(1);
    
    % This code supports the inclusion of multi-image inputs (videos). For
    % now, it only translates the data into the output parameter.
    SpatialWeights = SpatialWeights + NormSpatialContent;
    
    % This code supports the inclusion of multi-image inputs (videos). For
    % now, it only is the standard deviation of the normalized input image.
    SDevSum = SDevSum + std(ImageNorm(:));
end
    
% This code supports the inclusion of multi-image inputs (videos). For
% now, it only translates the data into the output parameters.
Weights = SpatialWeights/NumFrames;
SDev = SDevSum/NumFrames;

% The spatial frequencys and their corresponding weights can be seen
% through the following code. Simply uncomment if desired.
% figure
% plot(SpatialFreqs, Weights, 'c');
% xlabel('Spatial Frequencies (1/pixels)');
% ylabel('Spatial Weights');
% title('Average Spatial Frequency Weighting for Clutter');

end

