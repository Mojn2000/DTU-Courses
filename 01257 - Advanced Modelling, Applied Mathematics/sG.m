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

%% Soliton solution
y0 = zeros(N*2,1);
x0 = N*dx/2;
c = 0.2;

[y0(1:N), y0(N+1:end)] = soliton(1,x0,c,0.1:0.1:40,0);

eta = 0;
g1 = -0.01;
g2 = 0;
omega = 0.5;
alpha = 0.001;

auxFun = @(t,y) odefun(y,t,N,A,2*eta/dx,g1,g2,omega,alpha);
options = odeset('RelTol',1e-8,'AbsTol',ones(2*N,1)*1e-8);
[T,Y] = ode45(auxFun,[0,600],y0);


%% Multiple gamma
gammaN = 50;
period = zeros(2,gammaN);
gamma = linspace(0,0.7, gammaN);

eta = 0;
g2 = 0;
omega = 0.5;
alpha = 0.1;

for i=1:gammaN
    y0 = zeros(N*2,1);
    x0 = N*dx/2;
    c = 0.2;
    [y0(1:N), y0(N+1:end)] = soliton(1,x0,c,0.1:0.1:40,0);
    auxFun = @(t,y) odefun(y,t,N,A,2*eta/dx,-gamma(i),g2,omega,alpha);
    [T,Y] = ode45(auxFun,[0,600],y0);
    
    maxn = 100;
    j = 1;
    n = 1;
    epsilon = 1;
    period0 = Inf;
    period1 = 0;

    while(n < maxn)
        % positive rotation
        %[~, tmin1] = min(abs(Y(:,N/2)-pi*j));
        %[~, tmin2] = min(abs(Y(:,N/2)-pi*(j+2)));
        %period1 = T(tmin2) - T(tmin1);
        
        % negative rotation
        [~, tmin1] = min(abs(Y(:,N/2)+pi*j));
        [~, tmin2] = min(abs(Y(:,N/2)+pi*(j+2)));
        period1 = T(tmin2) - T(tmin1);
        
        
        if (norm(period0-period1,'inf')<abs(period0-period1)/10)
           period0 = period1;
           break
        else
            period0 = period1;
        end
        n = n+1;
    end
    period(1,i) = gamma(i);
    period(2,i) = period0;
end

%% Angular velocity plot
v_inf = @(gamma,alpha) 1./sqrt(1+(4*alpha./(pi*gamma)).^2);

hold on
figure(1)
set(gcf,'Position',[100 100 1000 800])
plot(40./period(2,:),period(1,:), 'LineWidth', 3)
plot(v_inf(gamma,alpha),gamma, 'LineWidth', 3)
ylabel('\gamma', 'FontSize',24);
xlabel('v_\infty', 'FontSize',20);
xlim([0.4,1.4])
legend('Numeric', 'Analytic', 'FontSize',20)
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
function dy = odefun(y,t,N,A,eta,g1,g2,omega,alpha)
    dy = zeros(N*2,1);
    dy(1:N) = y(N+1:end);
    dy(N+1:end) = A*y(1:N) - sin(y(1:N)) + g1 + g2*sin(omega*t) - alpha*y(N+1:end);
    dy(N+1) = dy(N+1) - eta;
    dy(end) = dy(end) + eta;
end

function [solx, soldx] = soliton(A,x0,c,x,t)
    solx = 4*atan(A*exp((x-x0-c*t)/sqrt(1-c^2)));
    soldx = -4*A*c*exp((-c*t + x - x0)./sqrt(-c^2 + 1))./(sqrt(-c^2 + 1)*(A^2*exp((-c*t + x - x0)./sqrt(-c^2 + 1)).^2 + 1));
end
