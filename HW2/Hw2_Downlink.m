% Introduction to Wireless and Mobile Networking : Hw2-Downlink
% Radio Propagation model : P_R = P_T * G_T * G_C * G_R 
% Path-Loss model only :  G_C = two-ray-ground model
% Don't Consider Intersymbol Interference
clear;
clc;
% Parameter setting
T      = 27 + 273.15;
B      = 10e6;
P_BS   = 33 - 30;     % BS power = 33 dBm
P_MS   = 23 - 30;     % MS power = 23 dBm
G_T_dB = 14;
G_R_dB = 14;
H_BS   = 1.5;          % height of Base station
H_B    = 50;           % height of building
H_MS   = 1.5;          % height of mobile station
H_T    = H_BS + H_B;
H_R    = H_MS;
ISD    = 500.0;        % inter site distance
side   = ISD/sqrt(3);
num_MS = 50;

%% 1-1 BS & MS xy-scatter figure
Xmax = side;
Ymax = ISD/2;
%{
ai = [side,0.0];
aj = [-halfside, ISD/2];
ak = [-halfside, -ISD/2];
temp  = randi(3,1,num_MS);
tempx = rand(1,num_MS);
tempy = rand(1,num_MS);
for a =1:num_MS
    if temp(a) == 1
        x(a) = tempx(a)*ai(1) + tempy(a)*aj(1);
        y(a) = tempy(a)*aj(2);
    elseif temp(a) == 2
        x(a) = tempx(a)*ai(1) + tempy(a)*ak(1);
        y(a) = tempy(a)*ak(2) ;
    else temp(a) == 3
        x(a) = tempx(a)*aj(1) + tempy(a)*ak(1);
        y(a) = tempx(a)*aj(2) + tempy(a)*ak(2);
    end
end;
scatter(x,y,25,'b','filled');
hold on ;
%}
hold on;
[x,y]=hexagon(side,0,0,num_MS);
title('Figure 1-1');
xlabel('Distance(m)'), ylabel('Distance(m)');
axis([-1.1*Xmax, 1.1*Xmax,-1.1*Ymax, 1.1*Ymax])
hold off;

%% Plot Figure 1-2 P_R-to-distance
% start modeling
d = sqrt(x.^2 + y.^2);
G_C = G_two_ray_ground(H_T, H_R, d);
G_C_dB = todB(G_C);
P_R_MS_dB = P_BS + G_T_dB + G_R_dB + G_C_dB;

figure;
scatter(d, P_R_MS_dB);
xlabel('Distance(m)'), ylabel( 'Received Power(dB)');
title('Figure 1-2');

%% Plot Figure 1-3 SINR to d
Noise = myThermalNoise(T, B);
BS_X = side*[-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
BS_Y = ISD*[-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];

% get distance b/w each MS & BS
for i = 1:18
    d_x = x-BS_X(i);
    d_y = y-BS_Y(i);
    d_I(i,:) =  sqrt(d_x.^2 + d_y.^2);
end

G_C_I = G_two_ray_ground(H_T, H_R, d_I);
G_C_I_dB = todB(G_C_I);
Interference = P_BS + G_T_dB + G_R_dB + G_C_I_dB;
I = fromdB(Interference);
I_t = sum(I);
P_R_MS = fromdB(P_R_MS_dB);
SINR = mySINR( P_R_MS, I_t, Noise);

figure;
scatter(d, SINR);
xlabel('Distance(m)'), ylabel( 'SINR(dB)');
title('Figure 1-3');
