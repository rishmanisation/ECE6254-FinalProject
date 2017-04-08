function [ targetImage ] = genTarget( frameInfo, targetInfo )
%genTarget - Generates the target. For now, simply
% generate a gaussian target with the given 
% characteristics. Future work would make targets that
% fixed difference distributions depending on the target
% selection (missile, drone, etc.)

% Initialize the Target Image
targetImage = zeros(frameInfo.vlin, frameInfo.vpix);

% Generate the distribution qualities
alphaX = targetInfo.sizeX / (2*targetInfo.stdX);
alphaY = targetInfo.sizeY / (2*targetInfo.stdY);

% Generate the Target
%target = gausswin(targetInfo.sizeY)* ...
%         gausswin(targetInfo.sizeX)';

% Generate the Target (Alpha characteristics included)
target = gausswin(targetInfo.sizeY, alphaY)* ...
         gausswin(targetInfo.sizeX, alphaX)';

% Embedd the target onto the target frame
targetImage( frameInfo.vlin/2 - targetInfo.sizeY/2 : frameInfo.vlin/2 + targetInfo.sizeY/2 - 1, ...
             frameInfo.vpix/2 - targetInfo.sizeX/2 : frameInfo.vpix/2 + targetInfo.sizeX/2 - 1) ...
             = target;

% Scale
targetImage = targetImage * targetInfo.mean;
targetImage = fix(targetImage);
         
end

