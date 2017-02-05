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
[ clutterImage ] = genClutter( frameInfo, clutterInfo );

%% Generate Target
[ targetImage ] = genTarget( frameInfo, targetInfo );

for frameNumber = 1 : displayInfo.numFrames
    
    %% Generate Clutter
    % Could also generate the clutter on the fly
    [ clutterImage ] = genClutter( frameInfo, clutterInfo );

    %% Add Target Movement
    [ targetMovImage updatedLocations] = moveTarget( frameInfo, targetImage, targetLocationInfo );

    % Lowpass the location movements so it doesnt look so crazy
    targetLocationInfo.x = updatedLocations.x;
    targetLocationInfo.y = updatedLocations.y;
    
    %% Frame Combining
    finalImage = clutterImage + targetMovImage;

    %% Target Analysis


    %% Target Tracking


    %% Future Target Location Estimation

    %% Display Image
    
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


