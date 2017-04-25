% Introduction to Wireless and Mobile Networking 
% Hw3: uplink communication with random walk 
% Radio Propagation model : P_R = P_T * G_T * G_C * G_R 
% path-Loss only radio propagation  
% G_C = two-ray-ground model

clear;
clc;

% Parameter setting
ISD    = 500;          % inter site distance
side   = ISD/sqrt(3);
num_MS = 100;
sim_time = 900;
T      = 27 + 273.15;
B      = 10e6;
H_BS   = 1.5;          % height of Base station
H_B    = 50;           % height of building
H_R    = H_BS + H_B; 
P_BS   = 33 - 30;      % BS power = 33 dBm
G_R_dB = 14;
G_R = fromdB(G_R_dB);

BS_X = side*[-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
BS_Y = ISD*[-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];

%% 3-1
figure;
[borderX, borderY] = cellmap(side,BS_X,BS_Y,0,0,1,1);
Xmax = max(borderX);
Ymax = max(borderY);
title('Figure B-1');
xlabel('Distance(m)'), ylabel('Distance(m)');
axis([-1.1*Xmax, 1.1*Xmax,-1.1*Ymax, 1.1*Ymax])
hold off;
offsetX = side*[4.5, 7.5, 3, -4.5, -7.5, -3];
offsetY = ISD*[3.5, -0.5, -4, -3.5, 0.5, 4];
for i = 1:6
   [outX{i} , outY{i}] = cellmap(side, BS_X, BS_Y, offsetX(i), offsetY(i), 0, 0);
end

%{
figure;
hold on;
plot(borderX, borderY,'r', 'LineWidth', 2);
for i = 1:6
   plot(outX{i},outY{i},'b');
end
hold off;
clear i;
%}

%% 3-2 The initial locations of all the 100 mobile devices are decided uniformly in the 19-cell map.
MS_label  = randi(size(BS_X,2), 1, num_MS);
for i = 1:size(BS_X,2)
    num = sum(MS_label == i);
    if num > 0
        [x, y] = hexagon(side, BS_X(i), BS_Y(i), num, 0);
        X{i} = x;
        Y{i} = y;
    end
end
clear i;
clear x;
clear y;
clear num;

%% 3-3
% initialize MS_randwalk objects
k = 1;
for i = 1:size(X,2)
    for j = 1:size(X{i},2)
        MS{k} = MS_randwalk(X{i}(j),Y{i}(j),0,0,0,i);
        [testX,testY,MS{k}] = MS{k}.update();
        k = k + 1;
    end
end   
clear k;
clear i;
clear j;

figure;
hold on;
cellmap(side,BS_X,BS_Y,0,0,1,1);
for i = 1 : num_MS
    [MS_X, MS_Y]= MS{i}.getloc();
    text(MS_X, MS_Y, int2str(i), 'Color','b'); 
end
title('Figure B-2');
xlabel('Distance(m)'), ylabel('Distance(m)');
axis([-1.1*Xmax, 1.1*Xmax,-1.1*Ymax, 1.1*Ymax])
hold off;

% run sim_time
handover_msg = cell(0,4);
tf = 1;
while tf <= sim_time
    power = zeros(19,num_MS);  % power(i,j) : BS(i) received power from MS(j)
    for k = 1:num_MS
        % go to next location
        [testX, testY, MS{k}] = MS{k}.update();
        if ~inpolygon(testX, testY, borderX, borderY)
            for i = 1:6
               if inpolygon(testX, testY, outX{i}, outY{i})
                   cell_label = i;
                   break
               end
            end
            movetoX = testX - offsetX(cell_label);
            movetoY = testY - offsetY(cell_label); 
            MS{k} = MS{k}.locate(movetoX,movetoY);
            %{
            fprintf('go beyond border\n');
            fprintf('MS(%d) goes to (%4.1f,%4.1f)\n',k,testX,testY);
            fprintf('MS(%d) goes to cell(%d)\n',k,cell_label);
            %}
        end        
        % get transmitted power
        power(:,k) = MS{k}.power(BS_X, BS_Y, H_R, G_R);   
    end
    % check handover
    total = sum(power,2);
    I = zeros(19,num_MS);
    N = myThermalNoise(T,B);
    for i = 1 : 19
        I(i,:) = total(i) - power(i,:);
    end
    BS_SINR = mySINR(power,I,N);
    [M, maxlabel] = max(BS_SINR);
    for i = 1 : num_MS
        [handover, oldlabel, MS{i} ] = MS{i}.handover(maxlabel(i));
        if handover == 1
            length = size(handover_msg,1);
            handover_msg(length+1, :) = {strcat(int2str(tf),'s'), oldlabel, maxlabel(i), i};
        end
    end
    tf = tf + 1 ;
end
Table = cell2table(handover_msg,'VariableNames',{'Time' 'Source_cell_ID' 'Destination_cell_ID' 'MS_ID'} );
writetable(Table,'data.csv');

fprintf('The amount of total handover times is: %d\n', size(handover_msg,1));

%{
figure;
hold on;
cellmap(side,BS_X,BS_Y,0,0,1,1)
for i = 1 : num_MS
    [MS_X, MS_Y]= MS{i}.getloc();
   text(MS_X, MS_Y, int2str(i), 'Color','b'); 
end
hold off;
%}
