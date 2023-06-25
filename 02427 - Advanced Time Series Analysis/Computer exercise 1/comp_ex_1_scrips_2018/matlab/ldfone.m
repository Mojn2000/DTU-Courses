function [phi]=ldfone(data, order, points,h, lag);
% Lag dependence function
%
% Usage:
%   ldfone(data, order, points, h, lag)
%
% Use this to see the dependence for one lag.
% A plot is created showing the datapoints(green dots), 
% the fitted datapoints (red dots) and the estimated points (blue line).
%
% Parameters:
%   data       A coloum vector with the data to be analyzed.
%   order      The order of the local polynomials.
%   points     Number of equidistant points where the local
%   h          The bandwidth of the tricube kernel used by the smoother
%   lag        The desired lag.
%
% By: Lasse Engbo Christiansen (lec@imm.dtu.dk) Sep 2001         
    
interval=[min(data) max(data)];
lag_data(:,1)=data(lag+1:length(data));
lag_data(:,2)=data(1:length(data)-lag);

SS0=lag_data(:,1)-mean(lag_data(:,1));
SS0=SS0'*SS0; %'

smooth=smooth_localreg(lag_data,interval,order,points,h);
fit=estimator(lag_data(:,2),interval,order,points,smooth);
res=lag_data(:,1)-fit;
SS0k=res'*res; 

R20=(SS0-SS0k)/SS0;
phi=sign(smooth(points,1)-smooth(1,1))*sqrt((abs(R20)+R20)/2)

figure
hold on
plot(lag_data(:,2),lag_data(:,1),'.g')
plot(lag_data(:,2),fit,'.r')
plot(smooth(:,2),smooth(:,1))

