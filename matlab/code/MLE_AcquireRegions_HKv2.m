function [ top, left, right, bottom, target,flag ] = MLE_AcquireRegions_HKv2( image, frameInfo, targetInfo, targetLocationInfo)
%MLE_AcquireRegions Acquire MLE region statistics
%   Detailed explanation goes here

% There are 3 regions to consider in the image.
% 1) Target
% 2) Boundary
% 3) Buffer
flag = 0;
% We begin by acquiring the target info from the given target stats from
% the input image.

% Use the assumption of the target size and increase it by a percentage to
% ensure encapsulating the target.
alpha = 1.50; % 150 Percent
[row,col]=size(targetInfo);
targetX = floor(col * alpha);
targetY = floor(row * alpha);



% The buffer region is pre-set to an initial size (number of pixels between
% target and border regions.
bufferSize = 5;


% The border regions are size based on the target. There are the same
% dimensions as their neighbording target border, yet only extend a set
% number of pixels in the outer region as to not encorporate too much
% background info which isnt spatial relevant to that next to the target.
% borderX = targetX;
% borderXextension = floor(targetX);
% targetY = targetY;
% if frameNumber == 1
%     topBorderX = targetX;
%     topBorderY = 20;
%     
%     bottomBorderX = targetX;
%     bottomBorderY = 20;
%     
%     leftBorderX = 20;
%     leftBorderY = targetY;
%     
%     rightBorderX = 20;
%     rightBorderY = targetY;
% else
topBorderX = targetX;
topBorderY = 20;

bottomBorderX = targetX;
bottomBorderY = 20;

leftBorderX = 20;
leftBorderY = targetY;

rightBorderX = 20;
rightBorderY = targetY;

% end
leftBorderFlag = 0;
topBorderFlag = 0;
rightBorderFlag = 0;
bottomBorderFlag = 0;
% Find the start/end positions within the image

targetXStart = targetLocationInfo.x - floor(targetX/2);
targetXEnd   = targetLocationInfo.x + floor(targetX/2);
targetYStart = targetLocationInfo.y - floor(targetY/2);
targetYEnd   = targetLocationInfo.y + floor(targetY/2);


% Hyeons attempting to identify invalid regions and what to do when they've
% been encountered.
if targetXStart > frameInfo.vlin - (targetX/2) || targetXEnd < 1 + (targetX/2) ...
        || targetYStart > frameInfo.vlin - (targetY/2) || targetYEnd < 1 + (targetY/2)
    % target out of bound
    flag = 1;
    return;
end
% case 1 
if targetXStart < 1 
    targetXStart = 1;
    leftBorderFlag = 1;
    bufferSize = 0;
end
if targetYStart < 1
    targetYStart = 1;
    topBorderFlag = 1;
    bufferSize = 0;
end
if targetXEnd > frameInfo.vlin
    targetXEnd = frameInfo.vlin;
    rightBorderFlag = 1;
    bufferSize = 0;
end
if targetYEnd > frameInfo.vlin
    targetYEnd = frameInfo.vlin;
    bottomBorderFlag = 1;
    bufferSize = 0;
end


% initialize to zero

top     = zeros(topBorderY,col+2*bufferSize);
bottom  = zeros(bottomBorderY,col+2*bufferSize);
left    = zeros(row+2*bufferSize,leftBorderX);
right   = zeros(row+2*bufferSize,rightBorderX);


% Return the statistics for each region
target  = image( targetYStart      : targetYEnd,       targetXStart      : targetXEnd       );


if topBorderFlag == 0
    topBorderXStart = targetXStart - bufferSize ;
    topBorderXEnd   = targetXEnd   + bufferSize ;
    topBorderYStart = targetYStart - bufferSize - topBorderY ;
    topBorderYEnd   = targetYStart - bufferSize ;
    top     = image( topBorderYStart   : topBorderYEnd,    topBorderXStart   : topBorderXEnd    );
end 
if bottomBorderFlag == 0
    bottomBorderXStart = topBorderXStart ;
    bottomBorderXEnd   = topBorderXEnd ;
    bottomBorderYStart = targetYEnd + bufferSize ;
    bottomBorderYEnd   = targetYEnd + bufferSize + bottomBorderY ;
    bottom  = image( bottomBorderYStart: bottomBorderYEnd, bottomBorderXStart: bottomBorderXEnd );

end
if leftBorderFlag == 0
    leftBorderXStart = targetXStart - bufferSize - leftBorderX ;
    leftBorderXEnd   = targetXStart - bufferSize ;
    leftBorderYStart = targetYStart - bufferSize ;
    leftBorderYEnd   = targetYEnd   + bufferSize ;
    left    = image( leftBorderYStart  : leftBorderYEnd,   leftBorderXStart  : leftBorderXEnd   );

end 
if rightBorderFlag == 0
    rightBorderXStart = targetXEnd + bufferSize ;
    rightBorderXEnd   = targetXEnd + bufferSize + rightBorderX ;
    rightBorderYStart = targetYStart - bufferSize ;
    rightBorderYEnd   = targetYEnd   + bufferSize ;
    right   = image( rightBorderYStart : rightBorderYEnd,  rightBorderXStart : rightBorderXEnd  );
end





% Plot these on the image for debugging
debug = 0;
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
    
    imageOverlay( targetYStart, targetXStart:targetXEnd) = tgt;
    imageOverlay( targetYEnd,   targetXStart:targetXEnd) = tgt;
    imageOverlay( targetYStart:targetYEnd, targetXStart) = tgt;
    imageOverlay( targetYStart:targetYEnd, targetXEnd )  = tgt;

    % Top Border
     imageOverlay( topBorderYStart, topBorderXStart:topBorderXEnd ) = top;
     imageOverlay( topBorderYEnd,   topBorderXStart:topBorderXEnd) = top;
     imageOverlay( topBorderYStart:topBorderYEnd, topBorderXStart ) = top;
     imageOverlay( topBorderYStart:topBorderYEnd, topBorderXEnd ) = top;
 
     % Bottom Border
     imageOverlay( bottomBorderYStart, bottomBorderXStart:bottomBorderXEnd) = bottom;
     imageOverlay( bottomBorderYEnd,   bottomBorderXStart:bottomBorderXEnd) = bottom;
     imageOverlay( bottomBorderYStart:bottomBorderYEnd, bottomBorderXStart) = bottom;
     imageOverlay( bottomBorderYStart:bottomBorderYEnd, bottomBorderXEnd) = bottom;
 
     % Left Border
     imageOverlay( leftBorderYStart, leftBorderXStart:leftBorderXEnd) = left;
     imageOverlay( leftBorderYEnd,   leftBorderXStart:leftBorderXEnd) = left;
     imageOverlay( leftBorderYStart:leftBorderYEnd, leftBorderXStart) = left;
     imageOverlay( leftBorderYStart:leftBorderYEnd, leftBorderXEnd ) = left;
 
     % Right Border
     imageOverlay( rightBorderYStart, rightBorderXStart:rightBorderXEnd ) = right;
     imageOverlay( rightBorderYEnd,   rightBorderXStart:rightBorderXEnd ) = right;
     imageOverlay( rightBorderYStart:rightBorderYEnd, rightBorderXStart ) = right;
     imageOverlay( rightBorderYStart:rightBorderYEnd, rightBorderXEnd   ) = right;

     figure;   
     imagesc(imageOverlay); colorbar;
end




end

