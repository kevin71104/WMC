% Introduction to Wireless and Mobile Networking : Hw2-Uplink
% Radio Propagation model : P_R = P_T * G_T * G_C * G_R 
% Path-Loss model only :  G_C = two-ray-ground model
% Don't Consider Intersymbol Interference
clear;
clc;
% Parameter setting
T      = 27 + 273.15;
B      = 10e6;
P_BS   = 33 - 30;      % BS power = 33 dBm
P_MS   = 23 - 30;      % MS power = 23 dBm
G_T_dB = 14;
G_R_dB = 14;
H_BS   = 1.5;          % height of Base station
H_B    = 50;           % height of building
H_MS   = 1.5;          % height of mobile station
H_T    = H_BS + H_B;
H_R    = H_MS;
ISD    = 500;          % inter site distance
side   = ISD/sqrt(3);
num_MS = 50;

%% 2-1 BS & MS xy-scatter figure
Xmax = side;
Ymax = ISD/2;

hold on ;
[x,y]=hexagon(side,0,0,num_MS);
title('Figure 2-1');
xlabel('Distance(m)'), ylabel('Distance(m)');
axis([-1.1*Xmax, 1.1*Xmax,-1.1*Ymax, 1.1*Ymax])
hold off;

%% Plot Figure 2-2 P_R_BS-to-distance
% start modeling
d = sqrt(x.^2 + y.^2);
G_C = G_two_ray_ground(H_T, H_R, d);
G_C_dB = todB(G_C);
P_R_BS_dB = P_MS + G_T_dB + G_R_dB + G_C_dB;

figure;
scatter(d, P_R_BS_dB);
xlabel('Distance(m)'), ylabel( 'Received Power(dB)');
title('Figure 2-2');

%% Plot Figure 2-3 SINR-to-distance
Noise = myThermalNoise(T, B);
P_R_BS = fromdB(P_R_BS_dB);
all = sum(P_R_BS);
I = all-P_R_BS;
SINR = mySINR(P_R_BS,I,Noise);

figure;
scatter(d, SINR);
xlabel('Distance(m)'), ylabel( 'SINR(dB)');
title('Figure 2-3');