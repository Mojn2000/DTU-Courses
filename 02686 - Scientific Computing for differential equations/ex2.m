%% Controller comparisson
Mu3 = string(zeros(5,3));
h = 0.01;
t0 = 0;
mu = 3;
tend = 40;
x0 = [1.0; 1.0];
for i = 1:5
   options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',10^(-2-i),'Atol',10^(-2-i));
   [X2,T2,function_calls2,hs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options); 
   Mu3(i,1) =  strcat(string(sum(hs2(2,:)-1)),"(",string(sum(hs2(2,:))),")");

    options = struct('step_control',true, 'initialStepSize',true,'control_type', "PI",'Rtol',10^(-2-i),'Atol',10^(-2-i));
   [X2,T2,function_calls2,hs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options); 
   Mu3(i,2) =  strcat(string(sum(hs2(2,:)-1)),"(",string(sum(hs2(2,:))),")");
   
    options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',10^(-2-i),'Atol',10^(-2-i));
   [X2,T2,function_calls2,hs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options); 
   Mu3(i,3) =  strcat(string(sum(hs2(2,:)-1)),"(",string(sum(hs2(2,:))),")");
   disp(i)
end

Mu20 = string(zeros(5,3));
h = 0.01;
t0 = 0;
mu = 20;
tend = 40;
x0 = [1.0; 1.0];
for i = 1:5
   options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',10^(-2-i),'Atol',10^(-2-i));
   [X2,T2,function_calls2,hs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options); 
   Mu20(i,1) =  strcat(string(sum(hs2(2,:)-1)),"(",string(sum(hs2(2,:))),")");

    options = struct('step_control',true, 'initialStepSize',true,'control_type', "PI",'Rtol',10^(-2-i),'Atol',10^(-2-i));
   [X2,T2,function_calls2,hs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options); 
   Mu20(i,2) =  strcat(string(sum(hs2(2,:)-1)),"(",string(sum(hs2(2,:))),")");
   
    options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',10^(-2-i),'Atol',10^(-2-i));
   [X2,T2,function_calls2,hs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options); 
   Mu20(i,3) =  strcat(string(sum(hs2(2,:)-1)),"(",string(sum(hs2(2,:))),")");
   disp(i)
end

%% MU = 3, fixed step size
h = 0.1;
t0 = 0;
mu = 3;
tend = 4*mu;
x0 = [1.0; 1.0];

% using the explicit euler method
options = struct('step_control',false, 'initialStepSize', false);
[X1,T1,function_calls1,hs1, time1] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler",options);

h = 0.01;
% using the explicit euler method
options = struct('step_control',false, 'initialStepSize', false);
[X2,T2,function_calls2,hs2, time2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler",options);

h = 0.001;
% using the explicit euler method
options = struct('step_control',false, 'initialStepSize', false);
[X3,T3,function_calls3,hs3, time3] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler",options);

options = odeset('RelTol',0.000001,'AbsTol',0.000001);
tic
[Tode45,Xode45] = ode45(@VanPol,[t0 tend],x0,options,mu);
time45 = toc

tic
[Tode15s,Xode15s]=ode15s(@VanPol,[t0 tend],x0,options,mu);
time15s = toc

%
fig = figure('Position',[10 10 800 600]);

subplot(3, 3, 1)
plot(T1,X1(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('h = 0.1','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 2)
plot(T2,X2(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('h = 0.01','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 3)
plot(T3,X3(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('h = 0.001','FontSize',16,'Interpreter','latex')
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


sgtitle('Explicit Euler with fixed step size, $\mu = 3$','Interpreter','latex','FontSize',20) 
 

% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = 0;
legend("Explicit Euler","ode45","ode15s",'NumColumns',3,'FontSize',16,'Interpreter','latex');
%% MU = 20, fixed step size
h = 0.1;
t0 = 0;
mu = 20;
tend = 4*mu;
x0 = [1.0; 1.0];

% using the explicit euler method
options = struct('step_control',false, 'initialStepSize', false);
[X1,T1,function_calls1,hs1, time1] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler",options);

h = 0.01;
% using the explicit euler method
options = struct('step_control',false, 'initialStepSize', false);
[X2,T2,function_calls2,hs2, time2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler",options);

h = 0.001;
% using the explicit euler method
options = struct('step_control',false, 'initialStepSize', false);
[X3,T3,function_calls3,hs3, time3] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler",options);

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
title('h = 0.1','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 2)
plot(T2,X2(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('h = 0.01','FontSize',16,'Interpreter','latex')
xlabel("t",'FontSize',16,'Interpreter','latex')
ylabel("$x_1$",'FontSize',16,'Interpreter','latex')
grid on

subplot(3, 3, 3)
plot(T3,X3(:,1),'LineWidth', 1.5)
hold on 
plot(Tode45,Xode45(:,1), '-.','LineWidth', 1.5)
plot(Tode15s,Xode15s(:,1), '--','LineWidth', 1.5)
title('h = 0.001','FontSize',16,'Interpreter','latex')
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

sgtitle('Explicit Euler with fixed step size, $\mu = 20$','Interpreter','latex','FontSize',20) 
 

% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = 0;
legend("Explicit Euler","ode45","ode15s",'NumColumns',3,'FontSize',16,'Interpreter','latex');

%% MU = 3, adaptive step size
h = 0.1;
t0 = 0;
mu = 3;
tend = 4*mu;
x0 = [1.0; 1.0];
Atol = 10^(-2);
Rtol = Atol;

% using the explicit euler method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',Rtol,'Atol',Atol);
[X1,T1,function_calls1,hs1,time1] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options);

Atol = 10^(-4);
Rtol = Atol;
% using the explicit euler method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',Rtol,'Atol',Atol);
[X2,T2,function_calls2,hs2,time2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options);

Atol = 10^(-6);
Rtol = Atol;
% using the explicit euler method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',Rtol,'Atol',Atol);
[X3,T3,function_calls3,hs3,time3] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options);

options = odeset('RelTol',0.000001,'AbsTol',0.000001);
[Tode45,Xode45] = ode15s(@VanPol,[t0 tend],x0,options,mu);

[Tode15s,Xode15s]=ode45(@VanPol,[t0 tend],x0,options,mu);

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

sgtitle('Explicit Euler with adaptive step size, $\mu = 3$','Interpreter','latex','FontSize',20) 
 

% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = 0;
legend("Explicit Euler","ode45","ode15s",'NumColumns',3,'FontSize',16,'Interpreter','latex');


% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = 0;
legend("Explicit Euler","ode45","ode15s",'NumColumns',3,'FontSize',16,'Interpreter','latex');


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

sgtitle('Explicit Euler with adaptive step size, $\mu = 3$','Interpreter','latex','FontSize',20) 
 

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

% using the explicit euler method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',Rtol,'Atol',Atol);
[X1,T1,function_calls1,hs1,rs1] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options);

Atol = 10^(-4);
Rtol = Atol;
% using the explicit euler method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',Rtol,'Atol',Atol);
[X2,T2,function_calls2,hs2,rs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options);

Atol = 10^(-6);
Rtol = Atol;
% using the explicit euler method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "I",'Rtol',Rtol,'Atol',Atol);
[X3,T3,function_calls3,hs3,rs3] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options);

options = odeset('RelTol',0.000001,'AbsTol',0.000001);
[Tode45,Xode45] = ode45(@VanPol,[t0 tend],x0,options,mu);

[Tode15s,Xode15s]=ode15s(@VanPol,[t0 tend],x0,options,mu);

%%
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

sgtitle('Explicit Euler with adaptive step size, $\mu = 20$','Interpreter','latex','FontSize',20) 
 

% add a bit space to the figure
fig = gcf;
%fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend('show');
Lgnd.Position(1) = 0.449;
Lgnd.Position(2) = 0.0;
legend("Explicit Euler","ode45","ode15s",'NumColumns',3,'FontSize',16,'Interpreter','latex');


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

sgtitle('Explicit Euler with adaptive step size, $\mu = 20$','Interpreter','latex','FontSize',20) 
 

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

% using the explicit euler method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',Rtol,'Atol',Atol);
[X1,T1,function_calls1,hs1,rs1] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options);

options = odeset('RelTol',Atol,'AbsTol',Rtol);
start = cputime;
[Tode45,Xode45] = ode15s(@VanPol,[t0 tend],x0,options,mu);
end45_1 = cputime-start;

start = cputime;
[Tode15s,Xode15s]=ode45(@VanPol,[t0 tend],x0,options,mu);
end15_1 = cputime-start;


Atol = 10^(-4);
Rtol = Atol;
% using the explicit euler method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',Rtol,'Atol',Atol);
[X2,T2,function_calls2,hs2,rs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options);

options = odeset('RelTol',Atol,'AbsTol',Rtol);
start = cputime;
[Tode45,Xode45] = ode15s(@VanPol,[t0 tend],x0,options,mu);
end45_2 = cputime-start;

start = cputime;
[Tode15s,Xode15s]=ode45(@VanPol,[t0 tend],x0,options,mu);
end15_2 = cputime-start;

Atol = 10^(-6);
Rtol = Atol;
% using the explicit euler method
options = struct('step_control',true, 'initialStepSize',true,'control_type', "PID",'Rtol',Rtol,'Atol',Atol);
[X3,T3,function_calls3,hs3,rs3] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler", options);

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





