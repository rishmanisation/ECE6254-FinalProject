clear;clc;close all;

load('mle_good_bad_data.mat')

sz=40;
figure;hold on;
scatter((good_data(:,1)+good_data(:,2))/2,...
    (good_data(:,3)+good_data(:,4))/2,sz,'b','filled')
scatter((somewhat_data(:,1)+somewhat_data(:,2))/2,...
    (somewhat_data(:,3)+somewhat_data(:,4))/2,sz,'b','filled')
scatter((bad_data(:,1)+bad_data(:,2))/2,...
    (bad_data(:,3)+bad_data(:,4))/2,sz,'g','filled')
%%
good_top = mean(good_data(:,1));
good_bottom = mean(good_data(:,2));
good_right = mean(good_data(:,3));
good_left = mean(good_data(:,4));
% 
% top_bad = mean(bad_data(:,1));
% bottom_bad = mean(bad_data(:,2));
% right_bad = mean(bad_data(:,3));
% left_bad = mean(bad_data(:,4));