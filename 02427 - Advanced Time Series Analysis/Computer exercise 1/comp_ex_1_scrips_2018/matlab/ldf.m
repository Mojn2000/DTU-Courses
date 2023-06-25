function [phi]=ldf(data, order, points,h, maxlag);
% Lag dependence function
%
% Usage:
%   ldf(data, order, points, h, maxlag)
%
% Parameters:
%   data       A coloum vector with the data to be analyzed.
%   order      The order of the local polynomials.
%   points     Number of equidistant points where the local
%   h          The bandwidth of the tricube kernel used by the smoother
%   maxlag     LDF is calculated for lags 1,...,maxlag
%  
%  By: Lasse Engbo Christiansen (lec@imm.dtu.dk) Sep 2001         
  n=length(data);
  interval=[min(data) max(data)]; 
  
  SS0=data(maxlag+1:n)-mean(data(maxlag+1:n));
  SS0=SS0'*SS0;
  
  for i=1:maxlag
    smooth=smooth_localreg([data(maxlag+1:n) data(maxlag+1-i:n-i)],interval,order,points,h);
    fit=estimator(data(maxlag+1-i:n-i),interval,order,points,smooth);
    res=data(maxlag+1:n)-fit;
    SS0k=res'*res; 
    
    R20=(SS0-SS0k)/SS0;
    phi(i)=sign(smooth(points,1)-smooth(1,1))*sqrt((abs(R20)+R20)/2);
  end
 
  phi=[1 phi];
  
