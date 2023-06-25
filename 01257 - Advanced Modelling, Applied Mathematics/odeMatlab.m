%  
% This Matlab script solves the forced van der Pol equation
% 
% u"+u = eps*(1-u^2)*u' + eps*k*cos(omega*t)
% 
% where u=u(t) is a function of t. eps, k and omega are parameters
% and prime denotes differentiation with respect to
% time t. We impose the initial conditions u(0)=a and u'(0)=0. 
% Note that Matlab script files name syntax is "filename.m". 
% From a Matlab window you can run the script by issuing the command
% 
% filename
% 
% The equations for the van der Pol oscillator is given in
% the file "pol.m". In this file the van der Pol equation
% is written as a system of two first order ordinary differential
% equations. Introducing y1=u we obtain
% 
% y1'=y2
% y2'=-y1+eps*(1-y1^2)*y2 + eps*k*cos(omega*t)
% 
% This transformation is necessary in order to use the Matlab Runge-Kutta
% solver ode45.
% 
% You may define global variables to be used in the main
% program and in the subroutines as follows:
% 

global eps omega

%
% Below we set a number of parameters to be used in 
% the ordinary differential equation (ode) solver ode45
% and in some analytical approximate solutions. If a
% sentence is ended by semicolon the value of the variable
% assigned is not printed on the screen.
%
 
eps=0.1;
sigma=1.0;
rho=1.2;
k1=rho*(1-rho)^2+4*sigma^2*rho;
k=sqrt(4*k1)
omega=1.0+sigma*eps
t0=100;

%
% Construction of an analytical approximation
% First we define a vector t holding the
% numbers 0, 0.1, 0.2, ... t0.

t=0:0.1:t0;
a=2*sqrt(rho)

%
% .* is a multiplication operator meaning component wise
% multiplication in case of two vectors.

u=a.*cos(omega*t);

%
% Numerical solution using ode45. The first line defines
% options. Here the relative tolerance is set to 1e-4
% and the same values for the absolute tolerance on both variables 
% y1 and y2. Then we call ode45. The first argument is a reference
% to the subroutine holding the right hand side of the van der Pol 
% equation. The second argument indicates that the ode is to be
% solved within the time interval [0,t0]. The third argument
% holds the initial conditions [u(0),y(0)]=[a 0]. Then the options
% are transfered to the subroutine ode45. The last argument is
% a variable k to be passed on to the subroutine 'pol.m'. [T,Y]
% holds the solution vector Y at times indicated in the time vector
% T.

options = odeset('RelTol',1e-8,'AbsTol',[1e-8 1e-8]);
[T,Y] = ode45(@pol,[0 t0],[a 0],options,k);

%
% The plot command below compares the analytical approximation
% with the numerical solution.

plot(T,Y(:,1),t,u)

%
% Saves the above plot in the postscript file plot1.eps. 

saveas(gcf,'plot1.eps','psc2')

% 
% Plot title is set

title('Ex. 3.4d.  eps=0.1  sigma=1  rho=1.2  k=4.4036  omega=1.1  a=2.1909. Phaselocking')

%
% x and y labels are put on the graph.

xlabel('t');
ylabel('x');

