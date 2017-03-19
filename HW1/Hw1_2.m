% Introduction to Wireless and Mobile Networking : Hw1-2
% Radio Propagation model : P_R = P_T * G_T * G_C * G_R
% Path-Loss: two-ray-ground model
% Shadowing: log-normal model
clear;
clc;
% Parameter setting
T      = 27 + 273.15;
B      = 10e6;
P_T    = 33 - 30; % input power = 33 dBm
G_T_dB = 14;
G_R_dB = 14;
H_BS   = 1.5;     % height of Base station
H_B    = 50;      % height of building
H_MS   = 1.5;     % height of mobile station
H_T    = H_BS + H_B;
H_R    = H_MS;

% start modeling
d_max = 2000;
d = 0:1:d_max;
G_C = G_two_ray_ground(H_T, H_R, d);
G_C_dB = todB(G_C);
S = normrnd(0,6,1,(d_max + 1)); % R = normrnd(mu,sigma,m,n) m-by-n matrix
P_R_dB = P_T + G_T_dB + G_R_dB + G_C_dB + S;

%% Plot Figure 2-1 P_R to d
figure
plot(d, P_R_dB,'linewidth',1),
xlabel('distance(m)'), ylabel( 'Received Power(dB)'),
title('Figure 2-1')

%% Plot Figure 2-2 SINR to d
Noise = myThermalNoise(T, B);
Interference = 0;
P_R = fromdB(P_R_dB);
SINR = mySINR_dB(P_R, Interference, Noise);
figure
plot(d, SINR,'linewidth',1),
xlabel('distance(m)'), ylabel( 'SINR(dB)'),
title('Figure 2-2')
