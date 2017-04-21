function [Image] = drawTarget(background, tgt, alpha, pos)

full_alpha = ones(size(background));
full_target = zeros(size(background));

% Obtain the size of the target
[tY, tX] = size(tgt);

% Compute the start and end positions of the target. We center the target
% upon the position so that the center of mass is coincident with the
% expected location.
remainder = mod(tX, 2);
x  = pos(1) - floor(tX/2);
x2 = pos(1) + floor(tX/2) - 1 + remainder;

remainder = mod(tY, 2);
y  = pos(2) - floor(tY/2);
y2 = pos(2) + floor(tY/2) - 1 + remainder;

% Find the backgound size so we can embedd the target into the correct
% position.
[bY, bX] = size(background);

if((x2 < 1) || (x > bX) || (y2 < 1) && (y2 > bY))
    % Bounds of the target are fully outside the background
    Image = background + 2*full_alpha;
else
    % At least some of the target is in the background space
    
    % These are the index values for the background matrix 
    bix1 = max(1, x);
    bix2 = min(bX, x2);
    biy1 = max(1, y);
    biy2 = min(bY, y2);
    % These are the index values for the target matrix
    tix1 = max(-x+2,1);
    if(x2 > bX)
        tix2 = tX-(x2-bX);
    else
        tix2 = tX;
    end    
    tiy1 = max(-y+2,1);
    if(y2 > bY)
        tiy2 = tY-(y2-bY);
    else
        tiy2 = tY;
    end
    
    % Calculate a full background size alpha channel, and a full 
    % size background with the image to be mixed with it
    % size(full_alpha(biy1:biy2,bix1:bix2))
    % size(alpha(tiy1:tiy2,tix1:tix2))
     
     full_alpha(biy1:biy2,bix1:bix2)  = alpha(tiy1:tiy2,tix1:tix2); 
     full_target(biy1:biy2,bix1:bix2) = tgt(tiy1:tiy2,tix1:tix2); 
    
    % Add the full size image to the original background with the
    % appropriate areas blocked off
    %Image = background.*full_alpha + full_target.*(1-full_alpha);
    
    % Eric: I did a simple addition of the target and the background just
    % to overcome some of the alpha stuff which was giving me problems. We
    % can change this to make it easier, but for now it gives them
    % something to go on. The multiplication is just a gain factor I was
    % using when playing around with the project.
    Image = background + 2*full_target;
    
end

return
