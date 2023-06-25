function coef=smooth_localreg(data, interval, order, points, h);
% Smoother using local polynomial regression.
%
% Usage:  coef=smooth_localreg(data, interval, order, points, h)
%
% Where: 
%   data      A two coloum vector, to be fitted with
%             data(i,1)=f(data(i,2)), where f() is
%             the local polynomiums to be fitted.  
%   order     The order of the local polynomiums. 
%   interval  The interval where the dependence is estimated.
%             Should be the maximum and minimum of the observations.
%   points    Number of equidistant points where the local
%             polynomium is estimated.
%   h         The bandwidth of the kernel. The 
%             present implementation uses a tri-cube 
%             kernel.
n=length(data);
coef=zeros(points,4+order);  % To be [tildey, x,c, coefs]
x=linspace(interval(1),interval(2),points)';
coef(:,2)=x;

U=ones(n,order+1);
Up=ones(points,order+1);
for j=1:order
%  U(:,j+1)=data(:,2).^j;
  Up(:,j+1)=x.^j;
end %for

for i=1:points
  w=abs(data(:,2)-x(i))/h;  % tri-cube weight function (w)
  w=(1-w.^3).^3;
  w=(w+abs(w))/2;
  W=spdiags(w,0,n,n);       % a sparse matrix with the weights in the diagonal.
  for j=1:order
    U(:,j+1)=(data(:,2)-x(i)).^j;
  end %for j=...

  coef(i,4:4+order)=((U'*W*U)^(-1)*U'*W*data(:,1))'; %'
  coef(i,1)=coef(i,4);  %%%Up(i,:)*coef(i,4:4+order)'; 
end %for i=...

deltax=x(2)-x(1);
nom=coef(2:points,1)-coef(1:(points-1),1);
for i=1:order
  nom=nom-coef(1:points-1,4+i).*deltax^i;
end
coef(1:(points-1),3)=(nom)/(deltax^(order+1));

%%%%%%%%%%%%%%%%%%%%%-end-%%%%%%%%%%%%%%%%%%%%%%%%%%%%

