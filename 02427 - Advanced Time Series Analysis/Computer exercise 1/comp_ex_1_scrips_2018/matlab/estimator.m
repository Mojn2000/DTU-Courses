function fhat=estimator(data,interval,order,points, smooth);
% Sub function used by pldf, ldf and ldfone.
%
% By: Lasse Engbo Christiansen (lec@imm.dtu.dk) Sep 2001 
  
  
  n=length(data);
  delta=(interval(2)-interval(1))/(points-1);
  index = uint16(floor( (data-interval(1)) /delta )+1);
  coef=zeros(n,order+2);
  x_lower=zeros(n,1);
  
  for k=1:n
    x_lower(k)=smooth(index(k),2);
    coef(k,order+2)=smooth(index(k),3);
    coef(k,1)=smooth(index(k),1);
    for i=1:order
      coef(k,i+1)=smooth(index(k),4+i);
    end
  end %k
  
  dist=data-x_lower;
  fhat=coef(:,1);
  for i=1:(order+1)
    fhat=fhat+coef(:,i+1).*dist.^i; 
  end
  