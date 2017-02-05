function [ targetMovImage location ] = moveTarget( frameInfo, targetImage, targetLocationInfo )
%moveTarget - Adds movement to the target. For now, it's
% simply some random movement. This could be more complex
% if needed.

% Generate a random movement
movX = (-1)*targetLocationInfo.speedX + rand(1) * (targetLocationInfo.speedX * 2);
movY = (-1)*targetLocationInfo.speedY + rand(1) * (targetLocationInfo.speedY * 2);

movX = fix(movX);
movY = fix(movY);

% Prevent the target from walking off the screen
if (targetLocationInfo.x + movX) < 0 || ...
   (targetLocationInfo.x + movX) > frameInfo.vpix
        movX = 0;
end

if (targetLocationInfo.y + movY) < 0 || ...
   (targetLocationInfo.y + movY) > frameInfo.vlin
        movY = 0;
end

% Update location
location.x = targetLocationInfo.x + movX;
location.y = targetLocationInfo.y + movY;

% Translate Target
% Notice that the target is always generated in the center of the image.
% This requires the offsets to be applied.
translate.x = frameInfo.vpix/2 - location.x;
translate.y = frameInfo.vlin/2 - location.y;

targetMovImage = circshift(targetImage, [translate.x translate.y]);

end

