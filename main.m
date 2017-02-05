% ECE 6254: Statistical Machine Learning
% Benjamin Sullins
% GTID: 903232988
% Distance Learning Student
% School of Electrical and Computer Engineering 
% Georgia Instiute of Technology 
%
% Final Project
% Missile/Drone Tracking
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date Modified : 2/5/2017 - Ben Sullins
% - Initial design implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% References
% ----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Routine Maintenance
clear all;
close all;
clc;

%% Initialization
% Program init functions and corresponding variables.
frameInfo.vpix    = 512;
frameInfo.vlin    = 512;
frameInfo.numBits =   8;

% Clutter Characteristics
clutterInfo.mean     =  64;
clutterInfo.variance =  0.2;

% Target Characteristics
targetInfo.sizeX =  64;
targetInfo.sizeY =  64;
targetInfo.mean  = 128;
targetInfo.stdX  =   4;
targetInfo.stdY  =   4;

% Target Movement Characteristics
targetLocationInfo.x      = frameInfo.vpix / 2;
targetLocationInfo.y      = frameInfo.vlin / 2;
targetLocationInfo.speedX = 10;
targetLocationInfo.speedY = 10;

% Display Settings
displayInfo.numFrames   = 100;
plotlocation.x          = frameInfo.vpix / 2;
plotlocation.y          = frameInfo.vlin / 2;

figure('Name','Missile/Drone Tracking Example','NumberTitle','off');
colorbar;

%% Generate Clutter
% Begin by generating a background based on a weighted Power Spectrum
% Distribution (PSD) of a collection of reference frames. These reference
% frames provide the cornerstone of the underlying clutter.
% 
% Notes: As we progress through the project, we will develop a better model
% of what clutter really is. This would use the PSD of reference images
% found online. For now, just generate a gaussian noise image using the
% parameters in the init.
[ clutterImage ] = genClutter( frameInfo, clutterInfo );

%% Generate Target
% The target can be classified by generic distributions. These will also be
% developed as we  enhance our algorithms. For now, just generate a
% gaussian target with the parameters above.
[ targetImage ] = genTarget( frameInfo, targetInfo );

% This loop creates a "video" like representation with each frame being
% generated on the fly.
for frameNumber = 1 : displayInfo.numFrames
    
    %% Generate Clutter
    % Clutter can be generated on the fly as well if we wanted it to be. If
    % not, comment this section out.
    [ clutterImage ] = genClutter( frameInfo, clutterInfo );

    %% Add Target Movement
    % This function adds movement to the target within in the frame. We can
    % modify this function to add specific movement patterns which reflect
    % that of an actual target. For now, just generate some random
    % patterns.
    [ targetMovImage updatedLocations] = moveTarget( frameInfo, targetImage, targetLocationInfo );

    % Lowpass the location movements so it doesnt look so crazy
    % Lowpassing the target locations can be done to give the targets a
    % more "organic" movement quality to them.
    targetLocationInfo.x = updatedLocations.x;
    targetLocationInfo.y = updatedLocations.y;
    
    %% Frame Combining
    % Adding all the frames correctly is a little more complicated than
    % what's shown. Nothing too bad, but for now just add away.
    finalImage = clutterImage + targetMovImage;

    %% Target Analysis
    % This would be the meat and potatoes. We'd be taking a stab at
    % understanding the underlying distributions for the target.
    % Effectively, we'd be disseminating between what is or isn't a target
    % (binomial for now). We can enhance this as we progress.


    %% Target Tracking
    % Next, after finding the target, we'd like to understand what kind of
    % offset is attributed to the targets motion from the previous frame.
    % This offset tells the next frame where to place our location
    % estimates to perform "tracking".


    %% Future Target Location Estimation
    % Temporal estimation techniques (extended kalman filters) can be used
    % to improve the tracking performance.

    %% Display Image
    % Finally, just display the image so that the user has some
    % understanding of what is going on. Im invisioning having a "truth"
    % and an "actual" target location to help give some quality metrics on
    % how we are performing. We can also throw in some other goodness if we
    % want.
    
    % Update location for plotting
    plotlocation.x = [plotlocation.x, targetLocationInfo.x];
    plotlocation.y = [plotlocation.y, targetLocationInfo.y];
     
    subplot(2,2,[1,3]);
    imshow( finalImage, [] );
    title(sprintf('Frame: %d of %d', frameNumber, displayInfo.numFrames));
    
    subplot(2,2,2);
    plot( plotlocation.x );
    title(sprintf('X Location & Performance'));
    
    subplot(2,2,4);
    plot( plotlocation.y );
    title(sprintf('Y Location & Performance'));
    
    drawnow;

end


