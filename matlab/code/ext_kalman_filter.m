function [X,P] = ext_kalman_filter(X,P,Z,measurement_noise,process_noise,f,h)

Q = process_noise;
R = measurement_noise;

%Predicted state estimate and jacobian of f
[X,F] = jaccsd(f,X);

%Predicted covariance estimate
P = F*P*F' + Q;

%Measurement residual and jacobian of h
[hx,H] = jaccsd(h,X);
y = Z - hx;

%Residual covariance
S = H*P*H' + R;

%Near-optimal Kalman gain
K = P*H'\S;

%Updated (a posteriori) state estimate
X = X + K*y;

%Updated (a posteriori) covariance estimate
I = eye(4);
P = (I - K*H)*P;

end


