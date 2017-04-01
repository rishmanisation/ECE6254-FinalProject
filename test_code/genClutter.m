function [ clutterImage ] = genClutter( frameInfo, clutterInfo )
%genClutter Generates the background clutter. TO begin
% with, we simply generate white noise. Future development
% would incorporate Power Spectrum Distribution qualities
% of real images to generate "synthetic" backgrounds. These
% would exhibit similiar characteristics as real backgrounds.

% Initialize the output image
clutterImage = zeros(frameInfo.vlin, frameInfo.vpix);

% Add the noise
clutterImage = imnoise(clutterImage, 'gaussian', ...
                       0, clutterInfo.variance);
                   
% Scale Image
clutterImage = clutterImage * clutterInfo.mean;
clutterImage = fix(clutterImage);

end

