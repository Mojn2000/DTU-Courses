clear all

%% Define A
N = 400;
dx = 0.1;

A = -eye(N)*2;
A = A + diag(ones(N-1,1),-1);
A = A + diag(ones(N-1,1),1);
A(1,2) = 2;
A(end,end-1) = 2;

A = A/dx.^2;

%% Define l
gaus = @(x,mu,sig) exp(-(((x-mu).^2)/(2*sig.^2)));
l = ones(N,1) - 0.5*gaus(0.1:0.1:40, 20, 2)';

hold on
figure(1)
set(gcf,'Position',[100 100 1000 800])
ylim([0,1.5])
l = ones(N,1) + 0.0*gaus(0.1:0.1:40, 20, 2)';
plot(0.1:0.1:40, l, 'LineWidth', 3)

l = ones(N,1) + 0.5*gaus(0.1:0.1:40, 20, 2)';
plot(0.1:0.1:40, l, 'LineWidth', 3)

l = ones(N,1) - 0.5*gaus(0.1:0.1:40, 20, 2)';
plot(0.1:0.1:40, l, 'LineWidth', 3)

legend('Standard', 'Long', 'Short', 'FontSize',20)
xlabel('x','FontSize',20);
ylabel('l_x','FontSize',20);
grid on
grid minor
hold off

%%
gaus = @(x,mu,sig) exp(-(((x-mu).^2)/(2*sig.^2)));
l = ones(N,1) - 0.0*gaus(0.1:0.1:40, 20, 2)';

%% Soliton solution
y0 = zeros(N*2,1);
x0 = N*dx/2;
c = 0.2;
[y0(1:N), y0(N+1:end)] = soliton(1,x0,c,0.1:0.1:40,0);
g = 9.82;
rho = 1;
kappa = 10;
eta = 0;
gamma1 = 2; 
gamma2 = 0;
omega = 0;
alpha = 0.1;

auxFun = @(t,y) pendfun(y,t,N,A,l,g,rho,kappa,eta,-gamma1,gamma2,omega,alpha);
options = odeset('RelTol',1e-8,'AbsTol',ones(2*N,1)*1e-8);
[T,Y] = ode45(auxFun,[0,80],y0);

%% Multiple gamma
gammaN = 40;
period = zeros(2,gammaN);
gamma = linspace(0,8,gammaN);

for i=1:gammaN
    auxFun = @(t,y) pendfun(y,t,N,A,l,g,rho,kappa,eta,-gamma(i),gamma2,omega,alpha);
    [T,Y] = ode45(auxFun,[0,600],y0);
    
    maxn = 20;
    j = 1;
    epsilon = 1;
    period0 = Inf;
    period1 = 0;

    while(j < maxn)
        % negative rotation
        [~, tmin1] = min(abs(Y(:,N/2)+pi*j));
        [~, tmin2] = min(abs(Y(:,N/2)+pi*(j+2)));
        period1 = T(tmin2) - T(tmin1);
        
        if (norm(period0-period1,'inf')<(period0+period1)/20)
           period0 = period1;
           if (norm(Y(tmin2,:),'inf')>1)
            y0 = Y(tmin2,:)';
            y0(1:N) = y0(1:N) - round(y0(N/2)/pi)*pi;
           end
           break
        else
            period0 = period1;
        end
        j = j+1;
    end
    period(1,i) = gamma(i);
    period(2,i) = period0;
end

%% Angular velocity plot
hold on
figure(1)
set(gcf,'Position',[100 100 1000 800])
plot(2*pi./period_standard(2,:),period_standard(1,:), 'LineWidth', 3)
plot(2*pi./period_large(2,:),period_large(1,:), 'LineWidth', 3)
plot(2*pi./period_small(2,:),period_small(1,:), 'LineWidth', 3)
legend('Standard', 'Long','Short', 'FontSize',20)
ylabel('\gamma', 'FontSize',26);
xlabel('-d\phi/dt', 'FontSize',20);
xlim([0,1.5])
grid on
grid minor
hold off


%% 3D plot
x = (1:N)*dx;
surfc(x(1:1:N),T(1:floor(size(T,1)/1e3):size(T,1)),Y(1:floor(size(T,1)/1e3):size(T,1),1:1:N), 'EdgeColor', 'none')
xlabel('x','FontSize',15);
ylabel('t','FontSize',15);
zlabel('\phi(x,t)','FontSize',15);
set(gca,'FontSize',16,...
        'TickDir','in',...
        'TickLength',[.02,.02],...
        'LineWidth',1)
colorbar('Ticks', [-6*pi,-4*pi,-2*pi, 0, 2*pi, 4*pi,6*pi], ....
    'Ticklabels',{'-6\pi','-4\pi','-2\pi', '0', '2\pi','4\pi','6\pi'})
%saveas(gcf,'figur1.eps','epsc')


%% FUNCTIONS
function dy = pendfun(y,t,N,A,l,g,rho,kappa,eta,gamma1,gamma2,omega,alpha)
    dy = zeros(N*2,1);
    dy(1:N) = y(N+1:end);
    dy(N+1:end) = (kappa./(rho*l.^2)).*A*y(1:N) - (g./l).*sin(y(1:N)) + gamma1 + gamma2*sin(omega*t) - alpha*y(N+1:end);
    dy(N+1) = dy(N+1) - (kappa/(rho*l(1)^2))*eta;
    dy(end) = dy(end) + (kappa/(rho*l(end)^2))*eta;
end

function [solx, soldx] = soliton(A,x0,c,x,t)
    solx = 4*atan(A*exp((x-x0-c*t)/sqrt(1-c^2)));
    soldx = -4*A*c*exp((-c*t + x - x0)./sqrt(-c^2 + 1))./(sqrt(-c^2 + 1)*(A^2*exp((-c*t + x - x0)./sqrt(-c^2 + 1)).^2 + 1));
end
