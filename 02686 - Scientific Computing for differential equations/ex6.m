%% Test problem, No step control
c =[0 1/5 3/10 4/5 8/9 1 1]';
A = [0 0 0 0 0 0 0 ;
 1/5 0 0 0 0 0 0
 3/40 9/40 0 0 0 0 0 ;
 44/45 -56/15 32/9 0 0 0 0 ;
 19372/6561 -25360/2187 64448/6561 -212/729 0 0 0;
 9017/3168 -355/33 46732/5247 49/176 -5103/18656 0 0;
 35/384 0 500/1113 125/192 -2187/6784 11/84 0];
b = [35/384 0 500/1113 125/192 -2187/6784 11/84 0]';

T = 10;
x0 = 1;
h = 1;
t0 = 0;
lambda = -1;
t_a = t0:0.01:T;
options = struct('step_control',false, 'initialStepSize', false, "control_type", "I");
[x,t,function_calls2,hs2] = ODEsolver(@testEq,[lambda],h,t0,T,x0, "DOPRI54", options);


x_true = exp(lambda*t);
x_true_a = exp(lambda*t_a);
local_error = exp(lambda*h)*x(1:end-1)-x(2:end) ;
global_error = x_true'-x;

% Top two plots
fig = figure('Position',[10 10 800 600]);

tiledlayout(2,2)
nexttile([1 2])
plot(t,x,t_a,x_true_a, 'LineWidth', 1.5)
legend("Dormand-Prince 5(4)", "Analytical Solution", 'FontSize', 12, 'interpreter','latex')
xlabel("t", 'FontSize', 12,'Interpreter','latex')
ylabel("x(t)", 'FontSize', 12,'Interpreter','latex')
title("Dormand-Prince 5(4)", 'FontSize', 16,'Interpreter','latex')
grid on 

nexttile
plot(t(1:end-1),local_error, 'o',"color",	'#EDB120')
hold on 
plot(t_a,x0*(R(lambda,h,b,A).^(t_a/h)*exp(h*lambda)-R(lambda,h,b,A).^((t_a+h)/h)))
legend("Emperical error", "Analytical error", 'FontSize', 12,'Interpreter','latex')
xlabel("t", 'FontSize', 12,'Interpreter','latex')
ylabel("e(h)", 'FontSize', 12,'Interpreter','latex')
title("Local truncation error", 'FontSize', 16,'Interpreter','latex')
grid on 

nexttile
plot(t,global_error, 'o',"color", '#77AC30')
hold on 
plot(t_a,x0*(exp(t_a*lambda)-R(lambda,h,b,A).^((t_a)/h)))
legend("Emperical error", "Analytical error", 'FontSize', 12,'Interpreter','latex')
xlabel("t", 'FontSize', 12,'Interpreter','latex')
ylabel("E(h)", 'FontSize', 12,'Interpreter','latex')
title("Global truncation error", 'FontSize', 16,'Interpreter','latex')
grid on 


%% Test problem, With step control
c =[0 1/5 3/10 4/5 8/9 1 1]';
A = [0 0 0 0 0 0 0 ;
 1/5 0 0 0 0 0 0
 3/40 9/40 0 0 0 0 0 ;
 44/45 -56/15 32/9 0 0 0 0 ;
 19372/6561 -25360/2187 64448/6561 -212/729 0 0 0;
 9017/3168 -355/33 46732/5247 49/176 -5103/18656 0 0;
 35/384 0 500/1113 125/192 -2187/6784 11/84 0];
b = [35/384 0 500/1113 125/192 -2187/6784 11/84 0]';

T = 10;
x0 = 1;
h = 1;
t0 = 0;
lambda = -1;
t_a = t0:0.01:T;
options = struct('step_control',false, 'initialStepSize', false, "control_type", "PID");
[x,t,function_calls2,hs2] = ODEsolver(@testEq,[lambda],h,t0,T,x0, "DOPRI54", options);

options = struct('step_control',true, 'initialStepSize', true, "control_type", "PID");
[x2,t2,function_calls2,hs2] = ODEsolver(@testEq,[lambda],h,t0,T,x0, "DOPRI54", options);


x_true = exp(lambda*t);
x_true_a = exp(lambda*t_a);
local_error = exp(lambda*h)*x(1:end-1)-x(2:end) ;
global_error = x_true'-x;

x_true = exp(lambda*t2);
local_error2 = exp(lambda.*hs2(1,:)').*x2(1:end-1)-x2(2:end) ;
global_error2 = x_true'-x2;

% Top two plots
fig = figure('Position',[10 10 800 600]);

tiledlayout(2,2)
nexttile([1 2])
plot(t,x,t2,x2,t_a,x_true_a,'LineWidth',1.5)
legend("Dormand-Prince 5(4), Without control", "Dormand-Prince 5(4), With control", "Analytical Solution", 'FontSize', 12, 'Interpreter','latex')
xlabel("t", 'FontSize', 12, 'Interpreter','latex')
ylabel("x(t)", 'FontSize', 12, 'Interpreter','latex')
title("Dormand-Prince 5(4)", 'FontSize', 16, 'Interpreter','latex')
hold on

nexttile
semilogy(t(1:end-1),local_error, 'o',"color",	'#EDB120','MarkerFaceColor','#EDB120', 'LineWidth',1.5)
hold on 
semilogy(t2(1:end-1),local_error2, 'o',"color",	'#77AC30','MarkerFaceColor','#77AC30', 'LineWidth',1.5)
legend("Without control", "With control", 'FontSize', 12, 'Interpreter','latex')
xlabel("t", 'FontSize', 12, 'Interpreter','latex')
ylabel("e(h)", 'FontSize', 12, 'Interpreter','latex')
title("Local truncation error", 'FontSize', 16, 'Interpreter','latex')
hold on

nexttile
semilogy(t(2:end),global_error(2:end), 'o',"color", '#EDB120','MarkerFaceColor','#EDB120', 'LineWidth',1.5)
hold on 
semilogy(t2(2:end),global_error2(2:end), 'o',"color", '#77AC30','MarkerFaceColor','#77AC30', 'LineWidth',1.5)
legend("Without control", "With control", 'FontSize', 12, 'Interpreter','latex')
xlabel("t", 'FontSize', 12, 'Interpreter','latex')
ylabel("E(h)", 'FontSize', 12, 'Interpreter','latex')
title("Global truncation error", 'FontSize', 16, 'Interpreter','latex')
hold on

%% Test problem, No step control
c =[0 1/5 3/10 4/5 8/9 1 1]';
A = [0 0 0 0 0 0 0 ;
 1/5 0 0 0 0 0 0
 3/40 9/40 0 0 0 0 0 ;
 44/45 -56/15 32/9 0 0 0 0 ;
 19372/6561 -25360/2187 64448/6561 -212/729 0 0 0;
 9017/3168 -355/33 46732/5247 49/176 -5103/18656 0 0;
 35/384 0 500/1113 125/192 -2187/6784 11/84 0];
b = [35/384 0 500/1113 125/192 -2187/6784 11/84 0]';

T = 1000;
x0 = 1;
border = 3.30656789263;
h = border;
t0 = 0;
lambda = -1;
t_a = t0:0.01:T;
options = struct('step_control',false, 'initialStepSize', false, "control_type", "PID");
[x,t,function_calls2,hs2] = ODEsolver(@testEq,[lambda],h,t0,T,x0, "DOPRI54", options);

h = border-0.01;
[x2,t2,function_calls2,hs2] = ODEsolver(@testEq,[lambda],h,t0,T,x0, "DOPRI54", options);

h = border+0.001;
[x3,t3,function_calls2,hs2] = ODEsolver(@testEq,[lambda],h,t0,T,x0, "DOPRI54", options);

x_true = exp(lambda*t);
x_true_a = exp(lambda*t_a);
local_error = exp(lambda*h)*x(1:end-1)-x(2:end) ;
global_error = x_true'-x;

x_true = exp(lambda*t2);
x_true_a = exp(lambda*t_a);
local_error2 = exp(lambda*h)*x2(1:end-1)-x2(2:end) ;
global_error2 = x_true'-x2;

x_true = exp(lambda*t3);
x_true_a = exp(lambda*t_a);
local_error3 = exp(lambda*h)*x3(1:end-1)-x3(2:end) ;
global_error3 = x_true'-x3;

% Top two plots
fig1 = figure;
pos_fig1 = [500 300 800 600];
set(fig1,'Position',pos_fig1)

plot(t,x,t2,x2,t3,x3,t_a,x_true_a)
legend("h=hlim","h=hlim-0.01","h=hlim+0.001", "Analytical Solution")
xlabel("t")
ylabel("x(t)")
title("Dormand-Prince 5(4)")
ylim([-0.3,3])
xlim([-50,T])



%% MU = 3, adaptive step size
h = 0.1;
t0 = 0;
mu = 3;
tend = 4*mu;
x0 = [1.0; 1.0];
Atol = 10^(-2);
Rtol = Atol;

% using the DOPRI54 method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',Rtol,'Atol',Atol);
tic
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "DOPRI54", options);
time1 = toc;

Atol = 10^(-4);
Rtol = Atol;
% using the DOPRI54 method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',Rtol,'Atol',Atol);
tic
[X2,T2,function_calls2,hs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "DOPRI54", options);
time2 = toc;

Atol = 10^(-6);
Rtol = Atol;
% using the DOPRI54 method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',Rtol,'Atol',Atol);
tic
[X3,T3,function_calls3,hs3] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "DOPRI54", options);
time3 = toc;

options = odeset('RelTol',0.000001,'AbsTol',0.000001);
[Tode45,Xode45] = ode45(@VanPol,[t0 tend],x0,options,mu);

[Tode15s,Xode15s]=ode15s(@VanPol,[t0 tend],x0,options,mu);

fig = figure('Position',[10 10 800 600]);

subplot(3, 3, 1)
plot(T1,X1(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('Atol = Rtol = $10^{-2}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 2)
plot(T2,X2(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('Atol = Rtol = $10^{-4}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 3)
plot(T3,X3(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('Atol = Rtol = $10^{-6}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 4)
plot(T1,X1(:,2),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,2), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 5)
plot(T2,X2(:,2),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,2), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 6)
plot(T3,X3(:,2),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,2), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 7)
plot(X1(:,1),X1(:,2),'LineWidth', 1.5)
hold on 
plot(Xode45(:,1),Xode45(:,2), '-.','LineWidth', 1.5)
plot(Xode15s(:,1),Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 8)
plot(X2(:,1),X2(:,2),'LineWidth', 1.5)
hold on 
plot(Xode45(:,1),Xode45(:,2), '-.','LineWidth', 1.5)
plot(Xode15s(:,1),Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 9)
plot(X3(:,1),X3(:,2),'LineWidth', 1.5)
hold on 
plot(Xode45(:,1),Xode45(:,2), '-.','LineWidth', 1.5)
plot(Xode15s(:,1),Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on

sgtitle('Dormand-Prince 5(4) with adaptive step size, $\mu = 3$','Interpreter','latex','FontSize',20) 
 

% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = -0.0;
legend("DoPri54","ode45","ode15s",'NumColumns',3,'FontSize',16,'Interpreter','latex');

fig = figure('Position',[10 10 800 600]);
T1 = T1(2:end-1);
T2 = T2(2:end-1);
T3 = T3(2:end-1);
hs1 = hs1(:,1:end-1);
hs2 = hs2(:,1:end-1);
hs3 = hs3(:,1:end-1);
subplot(1, 3, 1)
semilogy(T1,hs1(1,:),'LineWidth', 1.5)
hold on
semilogy(T1(hs1(2,:)>1),hs1(1,hs1(2,:)>1),'x', 'color', 'r','MarkerSize',12)
title('Atol = Rtol = $10^{-2}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("h",'FontSize',16,'Interpreter','latex')
ylim([10^(-5),10])
grid on

subplot(1, 3, 2)
semilogy(T2,hs2(1,:),'LineWidth', 1.5)
hold on
semilogy(T2(hs2(2,:)>1),hs2(1,hs2(2,:)>1),'x', 'color', 'r','MarkerSize',12)
title('Atol = Rtol = $10^{-4}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("h",'FontSize',16,'Interpreter','latex')
ylim([10^(-5),10])
grid on

subplot(1, 3, 3)
semilogy(T3,hs3(1,:),'LineWidth', 1.5)
hold on
semilogy(T3(hs3(2,:)>1),hs3(1,hs3(2,:)>1),'x', 'color', 'r','MarkerSize',12)
title('Atol = Rtol = $10^{-6}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("h",'FontSize',16,'Interpreter','latex')
ylim([10^(-5),10])
grid on

sgtitle('Dormand-Prince 5(4) with adaptive step size, $\mu = 3$','Interpreter','latex','FontSize',20) 
 

% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = 0;
legend("Step size","Rejections",'NumColumns',2,'FontSize',16,'Interpreter','latex');

%% MU = 20, adaptive step size
h = 0.1;
t0 = 0;
mu = 20;
tend = 4*mu;
x0 = [1.0; 1.0];
Atol = 10^(-2);
Rtol = Atol;

% using the DOPRI54 method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',Rtol,'Atol',Atol);
tic
[X1,T1,function_calls1,hs1,rs1] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "DOPRI54", options);
time1 = toc;

Atol = 10^(-4);
Rtol = Atol;
% using the DOPRI54 method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',Rtol,'Atol',Atol);
tic
[X2,T2,function_calls2,hs2,rs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "DOPRI54", options);
time2 = toc;

Atol = 10^(-6);
Rtol = Atol;
% using the DOPRI54 method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',Rtol,'Atol',Atol);
tic
[X3,T3,function_calls3,hs3,rs3] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "DOPRI54", options);
time3 = toc;

options = odeset('RelTol',0.000001,'AbsTol',0.000001);
[Tode45,Xode45] = ode45(@VanPol,[t0 tend],x0,options,mu);

[Tode15s,Xode15s]=ode15s(@VanPol,[t0 tend],x0,options,mu);

%
fig = figure('Position',[10 10 800 600]);

subplot(3, 3, 1)
plot(T1,X1(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('Atol = Rtol = $10^{-2}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on 

subplot(3, 3, 2)
plot(T2,X2(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('Atol = Rtol = $10^{-4}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on 

subplot(3, 3, 3)
plot(T3,X3(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('Atol = Rtol = $10^{-6}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on 

subplot(3, 3, 4)
plot(T1,X1(:,2),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,2), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on 

subplot(3, 3, 5)
plot(T2,X2(:,2),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,2), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on 

subplot(3, 3, 6)
plot(T3,X3(:,2),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,2), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on 

subplot(3, 3, 7)
plot(X1(:,1),X1(:,2),'LineWidth', 1.5)
hold on 
plot(Xode45(:,1),Xode45(:,2), '-.','LineWidth', 1.5)
plot(Xode15s(:,1),Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on 

subplot(3, 3, 8)
plot(X2(:,1),X2(:,2),'LineWidth', 1.5)
hold on 
plot(Xode45(:,1),Xode45(:,2), '-.','LineWidth', 1.5)
plot(Xode15s(:,1),Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on 

subplot(3, 3, 9)
plot(X3(:,1),X3(:,2),'LineWidth', 1.5)
hold on 
plot(Xode45(:,1),Xode45(:,2), '-.','LineWidth', 1.5)
plot(Xode15s(:,1),Xode15s(:,2), '--','LineWidth', 1.5)
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on 

sgtitle('Dormand-Prince 5(4) with adaptive step size, $\mu = 3$','Interpreter','latex','FontSize',20) 
 

% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = -0.0;
legend("DoPri54","ode45","ode15s",'NumColumns',3,'FontSize',16,'Interpreter','latex');


fig = figure('Position',[10 10 800 600]);
T1 = T1(2:end-1);
T2 = T2(2:end-1);
T3 = T3(2:end-1);
hs1 = hs1(:,1:end-1);
hs2 = hs2(:,1:end-1);
hs3 = hs3(:,1:end-1);
subplot(1, 3, 1)
semilogy(T1,hs1(1,:),'LineWidth', 1.5)
hold on
semilogy(T1(hs1(2,:)>1),hs1(1,hs1(2,:)>1),'x', 'color', 'r','MarkerSize',12)
title('Atol = Rtol = $10^{-2}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("h",'FontSize',16,'Interpreter','latex')
ylim([10^(-5),10])
grid on 

subplot(1, 3, 2)
semilogy(T2,hs2(1,:),'LineWidth', 1.5)
hold on
semilogy(T2(hs2(2,:)>1),hs2(1,hs2(2,:)>1),'x', 'color', 'r','MarkerSize',12)
title('Atol = Rtol = $10^{-4}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("h",'FontSize',16,'Interpreter','latex')
ylim([10^(-5),10])
grid on 

subplot(1, 3, 3)
semilogy(T3,hs3(1,:),'LineWidth', 1.5)
hold on
semilogy(T3(hs3(2,:)>1),hs3(1,hs3(2,:)>1),'x', 'color', 'r','MarkerSize',12)
title('Atol = Rtol = $10^{-6}$','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("h",'FontSize',16,'Interpreter','latex')
ylim([10^(-5),10])
grid on 

sgtitle('Dormand-Prince 5(4) with adaptive step size, $\mu = 20$','Interpreter','latex','FontSize',20) 
 

% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = 0;
legend("Step size","Rejections",'NumColumns',2,'FontSize',16,'Interpreter','latex');


%% Timing, mu = 20
h = 0.1;
t0 = 0;
mu = 20;
tend = 4*mu;
x0 = [1.0; 1.0];
Atol = 10^(-2);
Rtol = Atol;

% using the DOPRI54 method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',Rtol,'Atol',Atol);
[X1,T1,function_calls1,hs1,rs1] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "DOPRI54", options);

options = odeset('RelTol',Atol,'AbsTol',Rtol);
start = cputime;
[Tode45,Xode45] = ode15s(@VanPol,[t0 tend],x0,options,mu);
end45_1 = cputime-start;

start = cputime;
[Tode15s,Xode15s]=ode45(@VanPol,[t0 tend],x0,options,mu);
end15_1 = cputime-start;


Atol = 10^(-4);
Rtol = Atol;
% using the DOPRI54 method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',Rtol,'Atol',Atol);
[X2,T2,function_calls2,hs2,rs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "DOPRI54", options);

options = odeset('RelTol',Atol,'AbsTol',Rtol);
start = cputime;
[Tode45,Xode45] = ode15s(@VanPol,[t0 tend],x0,options,mu);
end45_2 = cputime-start;

start = cputime;
[Tode15s,Xode15s]=ode45(@VanPol,[t0 tend],x0,options,mu);
end15_2 = cputime-start;

Atol = 10^(-6);
Rtol = Atol;
% using the DOPRI54 method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',Rtol,'Atol',Atol);
[X3,T3,function_calls3,hs3,rs3] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "DOPRI54", options);

options = odeset('RelTol',Atol,'AbsTol',Rtol);
start = cputime;
[Tode45,Xode45] = ode15s(@VanPol,[t0 tend],x0,options,mu);
end45_3 = cputime-start;

start = cputime;
[Tode15s,Xode15s]=ode45(@VanPol,[t0 tend],x0,options,mu);
end15_3 = cputime-start;

times = zeros(3,3);
times(1,1) = rs1;
times(1,2) = end45_1;
times(1,3) = end15_1;
times(2,1) = rs2;
times(2,2) = end45_2;
times(2,3) = end15_2;
times(3,1) = rs3;
times(3,2) = end45_3;
times(3,3) = end15_3;

latex_table = latex(sym(times));


%% CSTR 1D
method = "DOPRI54";
options = struct('step_control', true, 'initialStepSize', true,'control_type', "PID");
optionsOde = odeset('RelTol',1e-6,'AbsTol',1e-6);

min = 60; %[s]
F = [0.7/min,0.6/min,0.5/min,0.4/min,0.3/min,0.2/min,0.3/min,0.4/min,0.5/min,0.6/min,0.7/min,0.7/min,0.2/min,0.2/min,0.7/min,0.7/min]; %[L/s]
Tin = 273.65; % [K]
V = .105; % [L]
beta = -(-560)/(1*4.186);%[mL/min]
Ca_in = 1.6/2; %[mol/L]
Cb_in = 2.4/2; %[mol/L]

t0 = 0; 
tend = 120; 
h = 1;

X = [];
Xode45 = [];
Xode15s = [];
T = [];
Fplot = [];
x0 = Tin;
x0ode45 = Tin;
x0ode15s = Tin;

for i=1:length(F)
    param = [F(i) Tin V beta Ca_in Cb_in];
    [X1,T1,function_calls1,hs1] = ODEsolver(@CSTR1D,param,h,t0,tend,x0, method,options);
   
    [~,X2]=ode45(@CSTR1D,T1,x0ode45,optionsOde, param);
    [~,X3]=ode15s(@CSTR1D,T1,x0ode15s,optionsOde,param);

    X = [X; X1];
    Xode45 = [Xode45; X2];
    Xode15s = [Xode15s; X3];

    T = [T T1];
    x0 = X1(end);
    x0ode45 = X2(end);
    x0ode15s = X3(end);

    t0 = T(end); 
    tend = T(end)+120; 
    Fplot = [Fplot, repelem(F(i), length(T1))];
end



fig = figure('Position', [10 10 1000 800]);
tend = 120;

subplot(2, 1, 1)
plot(T/60,X-273.15, 'LineWidth', 1.5)
hold on 
plot(T/60,Xode45(:,1)-273.15, '-.','LineWidth', 1.5)
plot(T/60,Xode15s(:,1)-273.15, '--','LineWidth', 1.5)
ylabel('T [$^\circ$C]', 'FontSize', 16, 'Interpreter','latex')
title('1D CSTR',  'FontSize', 20, 'Interpreter','latex')
grid on
legend(method,'ODE45','ODE15s','fontsize',12, 'Interpreter','latex')
hold off

subplot(2, 1, 2)
%plot([0 repelem((1:(length(F)-1))*tend,2) length(F)*tend]/60, repelem(F,2)*60*1000, 'LineWidth', 1.5)
plot(T/60, Fplot*60*1000, 'LineWidth', 1.5)
xlabel('t [min]', 'FontSize',16, 'Interpreter','latex')
ylabel('F [mL/min]', 'FontSize',16, 'Interpreter','latex')
ylim([0,1000])
grid on 

%% CSTR 3D
method = "DOPRI54";
Atol = 1e-10;
Rtol = 1e-10;
options = struct('step_control', true, 'initialStepSize', false, 'Rtol', Rtol, 'Atol', Atol,'control_type', "I", 'hmax', 6);
optionsOde = odeset('RelTol',Rtol,'AbsTol',Atol);

min = 60; %[s]
F = [0.7/min,0.6/min,0.5/min,0.4/min,0.3/min,0.2/min,0.3/min,0.4/min,0.5/min,0.6/min,0.7/min,0.7/min,0.2/min,0.2/min,0.7/min,0.7/min]; %[L/s]
Tin = 273.65; % [K]
V = .105; % [L]
beta = -(-560)/(1*4.186);%[mL/min]
Ca_in = 1.6/2; %[mol/L]
Cb_in = 2.4/2; %[mol/L]

t0 = 0; 
tend = 120; 
N = 30;
h = 1;

X = [];
Ca = [];
Cb = [];
Xode45 = [];
Caode45 = [];
Cbode45 = [];
Xode15s = [];
Caode15s = [];
Cbode15s = [];

Fplot = [];
T = [];
x0 = [Ca_in;Cb_in;Tin];
x0ode45 = x0;
x0ode15s = x0;

h_array = [];
for i=1:length(F)
    param = [F(i) Tin V beta Ca_in Cb_in];
    [X1,T1,function_calls1,hs1] = ODEsolver(@CSTR3D,param,h,t0,tend,x0, method,options);

    [~,X2]=ode45(@CSTR3D,T1,x0ode45,optionsOde, param);
    [~,X3]=ode15s(@CSTR3D,T1,x0ode15s,optionsOde,param);

    Ca = [Ca; X1(:,1)];
    Cb = [Cb; X1(:,2)];
    X = [X; X1(:,3)];
    
    Caode45 = [Caode45; X2(:,1)];
    Cbode45 = [Cbode45; X2(:,2)];
    Xode45 = [Xode45; X2(:,3)];

    Caode15s = [Caode15s; X3(:,1)];
    Cbode15s = [Cbode15s; X3(:,2)];
    Xode15s = [Xode15s; X3(:,3)];

    T = [T T1];
    h_array = [h_array hs1(:,1) hs1];
    x0 = X1(end,:);
    x0ode45 = X2(end,:);
    x0ode15s = X3(end,:);
    
    t0 = T(end); 
    tend = T(end)+120; 
    Fplot = [Fplot, repelem(F(i), length(T1))];
    h = hs1(1,end);
end


fig = figure('Position', [10 10 1000 800]);
subplot(2, 1, 1)
plot(T/60,X-273.15, 'LineWidth', 1.5)
hold on 
plot(T/60,Xode45(:,1)-273.15, '-.','LineWidth', 1.5)
plot(T/60,Xode15s(:,1)-273.15, '--','LineWidth', 1.5)
ylabel('T [$^\circ$C]', 'FontSize', 16, 'Interpreter','latex')
title('3D CSTR',  'FontSize', 20, 'Interpreter','latex')
grid on
legend(method,'ODE45','ODE15s','fontsize',12, 'Interpreter','latex')
hold off

subplot(2, 1, 2)
plot(T/60, Fplot*60*1000, 'LineWidth', 1.5)
xlabel('t [min]', 'FontSize',16, 'Interpreter','latex')
ylabel('F [mL/min]', 'FontSize',16, 'Interpreter','latex')
ylim([0,1000])
grid on 


fig = figure('Position', [10 10 1000 800]);
subplot(2, 1, 1)
plot(T/60,Ca, 'LineWidth', 1.5)
hold on
plot(T/60,Caode45, '-.','LineWidth', 1.5)
plot(T/60,Caode15s, '-.','LineWidth', 1.5)
ylabel('$C_A$ [$mol/L$]', 'FontSize', 16, 'Interpreter','latex')
title('3D CSTR',  'FontSize',16, 'Interpreter','latex')
legend(method,'ODE45','ODE15s','fontsize',12, 'Interpreter','latex')
grid on

subplot(2, 1, 2)
plot(T/60,Cb, 'LineWidth', 1.5)
hold on
plot(T/60,Cbode45, '-.','LineWidth', 1.5)
plot(T/60,Cbode15s, '-.','LineWidth', 1.5)
ylabel('$C_B$ [$mol/L$]', 'FontSize', 16, 'Interpreter','latex')
xlabel('t [min]', 'FontSize',16, 'Interpreter','latex')
legend(method,'ODE45','ODE15s','fontsize',12, 'Interpreter','latex')
grid on 


fig = figure;
T1 = T/60;
hs1 = h_array;
semilogy(T1,hs1(1,:),'LineWidth', 1.5)
hold on
semilogy(T1(hs1(2,:)>1),hs1(1,hs1(2,:)>1),'x', 'color', 'r','MarkerSize',12)
title('Used step sizes','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("h",'FontSize',16,'Interpreter','latex')


 

% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = 0;
legend("Step size","Rejections",'NumColumns',2,'FontSize',16,'Interpreter','latex');


