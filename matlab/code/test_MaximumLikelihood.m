% This script is for testing the Maximum Likelihood function of the UAV
% Tracking Project.

%% Clear Matlab
clear all;
close all;
clc;

%% Load Image

% Manual Image Selection
% path = strcat( fileparts(pwd), '\images');
% [filename,filepath] = uigetfile(fullfile(path , '*'), 'Select an Image');

% Auto Image Selection
filepath = strcat( fileparts(pwd), '\images\');
filename = 'hill1.jpg';

fprintf('Loading Input Image: %s \n', filename);
benchmarkImage = loadImage( strcat(filepath, filename)  );