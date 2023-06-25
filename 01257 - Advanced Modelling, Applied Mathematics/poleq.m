% The van der Pol oscillator

function dy = poleq(t,y)

global eps

dy = zeros(2,1);

dy(1)=y(2);
dy(2)=-y(1)+eps*(1.0-y(1).^2)*y(2);
