function [ top, left, right, bottom, target,imageOverlay ] = MLE_AcquireRegions( image, frameInfo, targetInfo, targetLocationInfo )
%MLE_AcquireRegions Acquire MLE region statistics
%   Detailed explanation goes here

% There are 3 regions to consider in the image.
% 1) Target
% 2) Boundary
% 3) Buffer

% We begin by acquiring the target info from the given target stats from
% the input image.

% Use the assumption of the target size and increase it by a percentage to
% ensure encapsulating the target.
alpha = 1.00; % 20%

targetX = floor(targetInfo.sizeX * alpha);
targetY = floor(targetInfo.sizeY * alpha);

% The buffer region is pre-set to an initial size (number of pixels between
% target and border regions.
bufferSize = 10;

% The border regions are size based on the target. There are the same
% dimensions as their neighbording target border, yet only extend a set
% number of pixels in the outer region as to not encorporate too much
% background info which isnt spatial relevant to that next to the target.
% borderX = targetX;
% borderXextension = floor(targetX);
% targetY = targetY;

topBorderX = targetX;
topBorderY = 20;

bottomBorderX = targetX;
bottomBorderY = 20;

leftBorderX = 20;
leftBorderY = targetY;

rightBorderX = 20;
rightBorderY = targetY;

% Find the start/end positions within the image

targetXStart = targetLocationInfo.y - floor(targetX/2);
targetXEnd   = targetLocationInfo.y + floor(targetX/2);
targetYStart = targetLocationInfo.x - floor(targetY/2);
targetYEnd   = targetLocationInfo.x + floor(targetY/2);

topBorderXStart = targetXStart - bufferSize;
topBorderXEnd   = targetXEnd   + bufferSize;
topBorderYStart = targetYStart - bufferSize - topBorderY;
topBorderYEnd   = targetYStart - bufferSize;

bottomBorderXStart = topBorderXStart;
bottomBorderXEnd   = topBorderXEnd;
bottomBorderYStart = targetYEnd + bufferSize;
bottomBorderYEnd   = targetYEnd + bufferSize + bottomBorderY;

leftBorderXStart = targetXStart - bufferSize - leftBorderX;
leftBorderXEnd   = targetXStart - bufferSize;
leftBorderYStart = targetYStart - bufferSize;
leftBorderYEnd   = targetYEnd   + bufferSize;

rightBorderXStart = targetXEnd + bufferSize;
rightBorderXEnd   = targetXEnd + bufferSize + rightBorderX;
rightBorderYStart = targetYStart - bufferSize;
rightBorderYEnd   = targetYEnd   + bufferSize;

% Plot these on the image for debugging
debug = 1;
if debug == 1

    % Overlay the input image or just look at the boxes with the other code
    % statement thats been commented out.
    imageOverlay = image; % zeros(size(image)); 
    tgt    = 300;
    top    = 301;
    bottom = 302;
    left   = 303;
    right  = 304;

    % Target Overlay
    imageOverlay( targetYStart, targetXStart:targetXEnd ) = tgt;
    imageOverlay( targetYEnd,   targetXStart:targetXEnd ) = tgt;
    imageOverlay( targetYStart:targetYEnd, targetXStart ) = tgt;
    imageOverlay( targetYStart:targetYEnd, targetXEnd   ) = tgt;

%     % Top Border
    imageOverlay( topBorderYStart, topBorderXStart:topBorderXEnd ) = top;
    imageOverlay( topBorderYEnd,   topBorderXStart:topBorderXEnd ) = top;
    imageOverlay( topBorderYStart:topBorderYEnd, topBorderXStart ) = top;
    imageOverlay( topBorderYStart:topBorderYEnd, topBorderXEnd   ) = top;
% 
    % Bottom Border
    imageOverlay( bottomBorderYStart, bottomBorderXStart:bottomBorderXEnd ) = bottom;
    imageOverlay( bottomBorderYEnd,   bottomBorderXStart:bottomBorderXEnd ) = bottom;
    imageOverlay( bottomBorderYStart:bottomBorderYEnd, bottomBorderXStart ) = bottom;
    imageOverlay( bottomBorderYStart:bottomBorderYEnd, bottomBorderXEnd   ) = bottom;

    % Left Border
    imageOverlay( leftBorderYStart, leftBorderXStart:leftBorderXEnd ) = left;
    imageOverlay( leftBorderYEnd,   leftBorderXStart:leftBorderXEnd ) = left;
    imageOverlay( leftBorderYStart:leftBorderYEnd, leftBorderXStart ) = left;
    imageOverlay( leftBorderYStart:leftBorderYEnd, leftBorderXEnd   ) = left;

    % Right Border
    imageOverlay( rightBorderYStart, rightBorderXStart:rightBorderXEnd ) = right;
    imageOverlay( rightBorderYEnd,   rightBorderXStart:rightBorderXEnd ) = right;
    imageOverlay( rightBorderYStart:rightBorderYEnd, rightBorderXStart ) = right;
    imageOverlay( rightBorderYStart:rightBorderYEnd, rightBorderXEnd   ) = right;

%     figure;
%     imshow(imageOverlay/255);% colorbar;
end

% Return the statistics for each region
target  = image( targetYStart      : targetYEnd,       targetXStart      : targetXEnd       );
top     = image( topBorderYStart   : topBorderYEnd,    topBorderXStart   : topBorderXEnd    );
bottom  = image( bottomBorderYStart: bottomBorderYEnd, bottomBorderXStart: bottomBorderXEnd );
left    = image( leftBorderYStart  : leftBorderYEnd,   leftBorderXStart  : leftBorderXEnd   );
right   = image( rightBorderYStart : rightBorderYEnd,  rightBorderXStart : rightBorderXEnd  );

end
