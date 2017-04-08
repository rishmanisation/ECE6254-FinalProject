%Inputs Mean and covariance
%-------------------------------------------------------%
%Initialization

dt = 0.2;
duration = 10;

for i = 1:duration
    X_loc(i) = 5;
end

X_loc_estimate = X_loc(1);
P_mag_estimate = zeros(50,50);
Q = 10;
R = 0.05;

for i = 1:dt:duration
    
    [X,P] = kalman_filter(X_loc(i),P_mag_estimate(i),Q,R,dt);
    X_loc_estimate = [X_loc_estimate; X];
    P_mag_estimate = [P_mag_estimate; P];
end

x = 0 : dt : duration;
plot(x,X_loc,'-r.',x,X_loc_estimate,'-k.');
%, x,P_mag_estimate,'-g.'


