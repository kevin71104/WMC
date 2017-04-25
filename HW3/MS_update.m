function [v, theta ,t] = MS_update(minSpeed, maxSpeed, minT, maxT)
    v = unifrnd(minSpeed, maxSpeed);
    theta = unifrnd(1 , 2*pi);
    interval = maxT - minT;
    t = minT + unidrnd(interval);
    