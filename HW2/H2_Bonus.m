% Introduction to Wireless and Mobile Networking : Hw2-Uplink(Bonus)
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
side   = ISD/sqrt(3)
num_MS = 50;
Noise  = myThermalNoise(T, B);

%% 3-1 plot BS and MS scatter
Xmax = 4*side;
Ymax = 2.5*ISD;

BS_X = side*[-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
BS_Y = ISD*[-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];

x = zeros(19,50);
y = zeros(19,50);

hold on;
for i = 1:size(BS_X,2)
    [x(i,:), y(i,:)] = hexagon(side, BS_X(i), BS_Y(i), num_MS);
end
title('Figure 3-1');
xlabel('Distance(m)'), ylabel('Distance(m)');
axis([-1.1*Xmax, 1.1*Xmax,-1.1*Ymax, 1.1*Ymax])
hold off;

%% Plot Figure 3-2 P_R_BS-to-distance
for i = 1:size(BS_X,2)
    d_x(i,:) = x(i,:) - BS_X(i);
    d_y(i,:) = y(i,:) - BS_Y(i);
end
d_t = sqrt(d_x.^2 + d_y.^2);

G_C = G_two_ray_ground(H_T, H_R, d_t);
G_C_dB = todB(G_C);
P_R_BS_dB = P_MS + G_T_dB + G_R_dB + G_C_dB;
P_R_BS = fromdB(P_R_BS_dB);

figure;
scatter(d_t(:), P_R_BS_dB(:),10);    % (:) to become a vector
xlabel('Distance(m)'); 
ylabel('Received Power(dB)');
title('Figure 3-2');
%{
SNR = mySINR(P_R_BS,0,Noise);
figure;
hold on;
for i = 1:size(BS_X,2)
    labels(i) = {strcat('BS',int2str(i))};
    scatter(d_t(i,:), SNR(i,:), 5);
end
xlabel('Distance(m)'), ylabel( 'SNR(dB)');
title('Figure 3-4');  
legend(labels);
hold off;
%}
%% Plot Figure 3-3 SINR-to-distance
figure;
hold on;
for i = 1:size(BS_X,2)
    labels(i) = {strcat('BS',int2str(i))};
    d_x = x - BS_X(i);
    d_y = y - BS_Y(i);
    d_t = sqrt(d_x.^2 + d_y.^2);
    
    G_C = G_two_ray_ground(H_T, H_R, d_t);
    G_C_dB = todB(G_C);
    % power received from each MS to specific BS
    power_dB(:,:,i) = P_MS + G_T_dB + G_R_dB + G_C_dB;
    %power_dB = P_MS + G_T_dB + G_R_dB + G_C_dB; 
    power = fromdB(power_dB(:,:,i));
    
    temp = sum(power);
    all = sum(temp);
    
    d = d_t(i,:);
    observation = P_R_BS(i,:);
    I(i,:) = all - observation;
    SINR = mySINR(observation,I(i,:),Noise);
    scatter(d,SINR,10);
    
end

xlabel('Distance(m)'), ylabel( 'SINR(dB)');
title('Figure 3-3');  
legend(labels);
hold off;