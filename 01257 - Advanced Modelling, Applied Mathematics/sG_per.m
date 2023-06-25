clear all

%%
N = 100;
dx = 0.1;

y0 = zeros(N*2,1);

beta0 = pi/4;
beta = beta0;
i = 1;
while sin(beta)>0
    y0(i) = beta;
    beta = beta0 - i*dx;
    i=i+1;
end

A = -eye(N)*2;
A = A + diag(ones(N-1,1),-1);
A = A + diag(ones(N-1,1),1);
A = A/dx.^2;

g1 = 0.0;
g2 = .01;
omega = 0.5;
alpha = .05;

auxFun = @(t,y) odefunPer(y,t,N,A,g1,g2,omega,alpha);
options = odeset('RelTol',1e-8,'AbsTol',ones(2*N,1)*1e-8);
[T,Y] = ode45(auxFun,[0,30],y0,options);


%%
x = (1:N)*dx;
surfc(x(1:1:N),T(1:50:21000),Y(1:50:21000,1:1:N))
% surfc(x,t,Y(Nf-Nm:dN:Nf,N+1:2*N))
% title(titlename,'FontSize',11)
%axis([-0.6 0.6 0 0.1 0 4])
xlabel('x','FontSize',15);
ylabel('t','FontSize',15);
zlabel('\phi(x,t)','FontSize',15);
set(gca,'FontSize',16,...
        'TickDir','in',...
        'TickLength',[.02,.02],...
        'LineWidth',1)
%saveas(gcf,'figur1.eps','epsc')

%% FUNCTIONS
function dy = odefunPer(y,t,N,A,g1,g2,omega,alpha)
    dy = zeros(N*2,1);
    dy(1:N) = y(N+1:end);
    dy(N+1:end) = A*y(1:N) - sin(y(1:N)) + g1 + g2*sin(omega*t) - alpha*y(N+1:end);
end