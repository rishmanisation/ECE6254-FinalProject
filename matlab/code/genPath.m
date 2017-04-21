function [P] = genPath(pos, vel, spd, Ts, Fmax, pType, mass)
%function genPath(pos, vel, spd, Ts, Fmax, pType, mass)
%   Returns a vector of length Fmax-1 of (x,y) coordinates of positions 
%   generated at time intervals of Ts. Inputs are:
%       pos     = starting [x y]' position
%       vel     = normalized velocity
%       spd     = speed in pixels/Ts
%       Ts      = time between each frame (sec/frame)
%       Fmax    = maximum number of frames to generate
%       mass    = mass in arbitrary units, or radius for c and f types
%       type    = type of motion to generate:
%                 b = balistic arc
%                 h = hovering craft, random movement like a 2d helicopter
%                 c = circular motion, vel used for radius of circle
%                 s = straight line
%                 f = figure 8 motion, vel for size of figure 8
% 
%       Note that the Isize is only used to determine valid starting 
%       positions, it is up to higher levels to stop the program when the 
%       target has moved off the screen if desired

t = [0:(Fmax-1)]';

switch pType
    case 'b'
        fx = @(t,p0,v) p0 + t*v*(spd*Ts);
        fy = @(t,p0,v) p0 + t*v*(spd*Ts) - mass*t.^2;
        P = [fx(t, pos(1), vel(1)), -fy(t, -pos(2), vel(2))];
    case 'c' 
        P = [pos(1) + mass*cos(2*pi*(spd*Ts)*t), pos(2) + mass*sin(2*pi*(spd*Ts)*t)];
    case 's'
        %Straight line path
        fV = @(t,p0,v) p0 + t*v*(spd*Ts) + mass*cosd(t*360*rand());
        P = [fV(t, pos(1), vel(1)), -fV(t, -pos(2), vel(2))];
    case 'f' 
        P = [pos(1) + mass*cos(2*pi*(spd*Ts)*t), pos(2) + mass*sin(4*pi*(spd*Ts)*t)];
    case 'h' 
        P = zeros(Fmax,2);
        p_last = [pos(1), pos(2)];
        xbias = 0.5;
        ybias = 0.5;
        
        for i = 1:Fmax
            if (rand() > 0.85)
                angle = 360*rand();
                xbias = 0.1*mass*cosd(angle);
                ybias = 0.1*mass*sind(angle);
                
            end

            P(i,:) = [(p_last(1) + spd*(rand()-0.5 + xbias)),...
                      (p_last(2) - spd*(rand()-0.5) + ybias)]; 

            p_last = P(i,:);
        end
    otherwise
        P = zeros(Fmax,2);
        fprintf('Invalid type used! \n');
end

% We are operating on an image which only has discrete points. Convert the
% decimal valued positions to integers. This will remove some granularity
% but it is necessary.

P = round( P );

return