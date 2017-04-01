function [Clutter] = MakeClutter(Sdev, Cmean, ArraySize, SFvec, SFweight, SFcorrelation)
%MakeClutter - Generates A Synthetic Clutter Scene
%   This function uses a vector of spatial frequencies and their
%   corresponding weight parameters to generate a similiar synthetic image
%   with induced normal/zero mean gaussian noise elements.

% Initialize the clutter scene. This array will continue to to updated with
% the spatial frequency components of the input vector.
Clutter = zeros(ArraySize);

% Detect the number of spatial frequencies upon which to iteratively add to
% the clutter scene
NumSF = length(SFvec);

% Initialize a Normal distributed/zero mean random variable array. This
% serves as the random component upon which the spatial frequencies are
% correlation which each other.
RandArray = randn(ArraySize);

for i=1:NumSF
    % Spatial frequency component correlation.
    RandArray = SFcorrelation.*RandArray + (1-SFcorrelation).*randn(ArraySize);
    
    % Kernel Size for the spatial frequency component. This provides the
    % incoherenct distribution of the frequency upon the image and is seen
    % through the variable pixel range distribution of the clutter image.
    KernelSize = floor( SFvec(i) );
    
    % Apply the spatial frequency's weight component. The weight is a
    % reflection of the significance of the frequency from the original
    % image. Increased weight enhances the importance and impact of the
    % frequency upon the clutter image.
    Kernel = SFweight(i).*ones(KernelSize);
    
    % Update the clutter image with the spatial frequency component.
    Clutter = Clutter + conv2(RandArray, Kernel, 'same');
end

% Normalize the final clutter image.
Clutter = (Sdev./std(Clutter(:))).*Clutter + Cmean;

return
