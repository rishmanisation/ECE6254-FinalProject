function [Image] = drawTarget(background, tgt, alpha, pos)

full_alpha = ones(size(background));
full_target = zeros(size(background));

x = pos(1);
y = pos(2);
[tY, tX] = size(tgt);
x2 = x + tX-1;
y2 = y + tY-1;
[bY, bX] = size(background);

if((x2 < 1) || (x > bX) || (y2 < 1) && (y2 > bY))
    % Bounds of the target are fully outside the background
    Image = background;
else
    % At least some of the target is in the background space
    
    % These are the index values for the background matrix 
    bix1 = max(1, x);
    bix2 = min(bX, x2);
    biy1 = max(1, y);
    biy2 = min(bY, y2);
    % These are the index values for the target matrix
    tix1 = max(-x+2,1)
    if(x2 > bX)
        tix2 = tX-(x2-bX)
    else
        tix2 = tX
    end    
    tiy1 = max(-y+2,1)
    if(y2 > bY)
        tiy2 = tY-(y2-bY)
    else
        tiy2 = tY
    end
    % Calculate a full background size alpha channel, and a full 
    % size background with the image to be mixed with it
    size(full_alpha(biy1:biy2,bix1:bix2))
    size(alpha(tiy1:tiy2,tix1:tix2))
    
    full_alpha(biy1:biy2,bix1:bix2) = alpha(tiy1:tiy2,tix1:tix2); 
    full_target(biy1:biy2,bix1:bix2) = tgt(tiy1:tiy2,tix1:tix2); 
    % Add the full size image to the original background with the
    % appropriate areas blocked off
    Image = background.*full_alpha + full_target.*(1-full_alpha);
end

return
