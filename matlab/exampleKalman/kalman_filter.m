function [ X, P ] = kalman_filter( X, P, Z, measurement_noise, process_noise, A, B )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% Reference :   http://studentdavestutorials.weebly.com/object-tracking-2d-kalman-filter.html
%               http://www.youtube.com/watch?v=GBYW1j9lC1I
%Inputs Mean and covariance
%-------------------------------------------------------%
%Initialization

% % State Transition Matrix
% % State prediciton of the position.
% A = [   1   0   dt  0   
%         0   1   0   dt  
%         0   0   1   0   
%         0   0   0   1]  ;
%         
% % Predicted Motion
% B = [   dt^2/2
%         dt^2/2
%         dt
%         dt]; 
    
% Acceleration of target
u = 0.005;

% Measurement Update Matrix
% This will be the expected measurement given the predicted state.
C = [	1   0   0   0;
        0   1   0   0];

% Covariance Matrix for the measurment uncertainty
R = measurement_noise;

% Covariance Matrix for the observation uncertainty
Q = process_noise;

%-------------------------------------------------------%

%% Do kalman filtering
%initize estimation variables

    % Propogation Equations
    % Estimate the next position location
    X = A*X + B*u;
    
    % Estimate the next noise estimate
    P = A*P*A' + Q;
    
    % Update Equations
    % Kalman Gain Equation
    K = P*C'*(C*P*C' + R)^(-1);
    
    % Corrective Noise Estimate
    P = (eye(4) - K*C)*P;
     
    % Corrective position estimate
    % We check to see if the object has moved off screen through the check
    % on the position input Z. When this is invalid, the kalman filter will
    % 'glide'.
    if (~isnan(Z(1)))
        X = X + K*(Z(1:2) - C*X);
    end
end

