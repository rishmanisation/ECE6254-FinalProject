function [ imageOutput ] = addCrosshairs( image, actualX, actualY, estimateX, estimateY )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Choose the max value 
overlayValue = max(max(image));

% Round the values
estimateX = round(estimateX);
estimateY = round(estimateY);

% Add a box around the target
targetX = 32;
targetY = 32;

targetXStart = estimateX - floor(targetX/2);
targetXEnd   = estimateX + floor(targetX/2);
targetYStart = estimateY - floor(targetY/2);
targetYEnd   = estimateY + floor(targetY/2);

image( targetYStart,            targetXStart:targetXEnd) = overlayValue;
image( targetYEnd,              targetXStart:targetXEnd) = overlayValue;
image( targetYStart:targetYEnd, targetXStart)            = overlayValue;
image( targetYStart:targetYEnd, targetXEnd )             = overlayValue;

% Now add lines on each side of the box
image( estimateY,                 floor(estimateX+targetX/4): floor(estimateX+targetX  )) = overlayValue;
image( estimateY,                 floor(estimateX-targetX  ): floor(estimateX-targetX/4)) = overlayValue;
image( floor(estimateY+targetY/4):floor(estimateY+targetY  ), estimateX)                  = overlayValue;
image( floor(estimateY-targetY  ):floor(estimateY-targetY/4), estimateX)                  = overlayValue;

imageOutput = image;

end

