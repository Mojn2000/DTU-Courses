%% Multivariat brownian motion
h = 0.002;
N = 400;
dim = 2;
seed = 42;
[W1,Tw,h] = brownian_motion(h,N,dim, 10);
[W2,Tw,h] = brownian_motion(h,N,dim, 3);
[W3,Tw,h] = brownian_motion(h,N,dim, 6);

fig = figure('Position',[10 10 800 600]);
plot(W1(1,:),W1(2,:),W2(1,:),W2(2,:),W3(1,:),W3(2,:))
xlim([-2,2])
ylim([-2,2])
legend("Path 1", "Path 2", "Path 3",'FontSize',12)
title("2D Brownian motion with start [0,0]",'fontsize',20, 'Interpreter','latex')
grid on


%% Explicit-Explicit, State independent

h = 0.001;
t0 = 0;
mu = 3;
tend = 3*mu;
x0 = [0.5; 0.5];
sigma = 1;
paths = 8;

% using the explicit euler method
fig = figure('Position',[10 10 800 600]);
sgtitle('Explicit-Explicit, State Independent Diffusion','Interpreter','latex','FontSize',20) 
subplot(2, 2, 1)
hold on
title("$\sigma = 1$, $\mu = 3$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusion,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

sigma = 2;
subplot(2, 2, 2)
hold on
title("$\sigma = 2$, $\mu = 3$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusion,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

mu = 20;
sigma = 1;
tend = 3*mu;
subplot(2, 2, 3)
hold on
title("$\sigma = 1$, $\mu =20$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusion,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

sigma = 2;
subplot(2, 2, 4)
hold on
title("$\sigma = 2$, $\mu = 20$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusion,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off


%% Explicit-Explicit, State dependent

h = 0.001;
t0 = 0;
mu = 3;
tend = 3*mu;
x0 = [0.5; 0.5];
sigma = 1;
paths = 8;

% using the explicit euler method
fig = figure('Position',[10 10 800 600]);
sgtitle('Explicit-Explicit, State Dependent Diffusion','Interpreter','latex','FontSize',20) 
subplot(2, 2, 1)
hold on
title("$\sigma = 1$, $\mu = 3$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

sigma = 2;
subplot(2, 2, 2)
hold on
title("$\sigma = 2$, $\mu = 3$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

mu = 20;
sigma = 1;
tend = 3*mu;
subplot(2, 2, 3)
hold on
title("$\sigma = 1$, $\mu =20$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

sigma = 2;
subplot(2, 2, 4)
hold on
title("$\sigma = 2$, $\mu = 20$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

%% Implicit-Explicit, State independent

h = 0.001;
t0 = 0;
mu = 3;
tend = 3*mu;
x0 = [0.5; 0.5];
sigma = 1;
paths = 8;

% using the explicit euler method
fig = figure('Position',[10 10 800 600]);
sgtitle('Implicit-Explicit, State Independent Diffusion','Interpreter','latex','FontSize',20) 
subplot(2, 2, 1)
hold on
title("$\sigma = 1$, $\mu = 3$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusion, 'Jac', @VanPolJac, 'seed', i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

sigma = 2;
subplot(2, 2, 2)
hold on
title("$\sigma = 2$, $\mu = 3$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusion, 'Jac', @VanPolJac, 'seed', i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

mu = 20;
sigma = 1;
tend = 3*mu;
subplot(2, 2, 3)
hold on
title("$\sigma = 1$, $\mu =20$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusion, 'Jac', @VanPolJac, 'seed', i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

sigma = 2;
subplot(2, 2, 4)
hold on
title("$\sigma = 2$, $\mu = 20$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusion, 'Jac', @VanPolJac, 'seed', i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off


%% Implicit-Explicit, State dependent

h = 0.001;
t0 = 0;
mu = 3;
tend = 3*mu;
x0 = [0.5; 0.5];
sigma = 1;
paths = 8;

% using the explicit euler method
fig = figure('Position',[10 10 800 600]);
sgtitle('Implicit-Explicit, State Dependent Diffusion','Interpreter','latex','FontSize',20) 
subplot(2, 2, 1)
hold on
title("$\sigma = 1$, $\mu = 3$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent, 'Jac', @VanPolJac, 'seed', i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

sigma = 2;
subplot(2, 2, 2)
hold on
title("$\sigma = 2$, $\mu = 3$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent, 'Jac', @VanPolJac, 'seed', i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

mu = 20;
sigma = 1;
tend = 3*mu;
subplot(2, 2, 3)
hold on
title("$\sigma = 1$, $\mu =20$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent, 'Jac', @VanPolJac, 'seed', i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off

sigma = 2;
subplot(2, 2, 4)
hold on
title("$\sigma = 2$, $\mu = 20$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=1:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent, 'Jac', @VanPolJac, 'seed', i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',0.1)
end
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,0],h,t0,tend,x0, "Implicit-Explicit", options);
plot(X1(:,1),X1(:,2), 'LineWidth',2,'Color','black')
grid on
hold off


%% Weak and strong convergence
paths = 10;
sigma = 2;
mu = 20;
h = 0.1;
fig = figure('Position',[10 10 800 600]);
subplot(2, 3, 1)
grid on
hold on
title("SDE, $h = 0.1$",'FontSize',16,'Interpreter','latex')
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',1);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2))
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=2:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2))
end

h = 0.01;
subplot(2, 3, 2)
grid on
hold on
title("SDE, $h = 0.01$",'FontSize',16,'Interpreter','latex')
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',1);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2))
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=2:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2))
end

h = 0.001;
subplot(2, 3, 3)
grid on
hold on
title("SDE, $h = 0.001$",'FontSize',16,'Interpreter','latex')
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',1);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2))
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
for i=2:paths
options = struct( 'paths' , 1, 'g', @VanPolDiffusionStateDependent,'seed',i);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu,sigma],h,t0,tend,x0, "Explicit-Explicit", options);
plot(X1(:,1),X1(:,2))
end



h = 0.1;
subplot(2, 3, 4)
% using the explicit euler method
options = struct('step_control',false, 'initialStepSize', false);
[X1,T1,function_calls1,hs1] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler",options);
plot(X1(:,1),X1(:,2))
title("ODE, $h = 0.1$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on

h = 0.01;
subplot(2, 3, 5)
% using the explicit euler method
options = struct('step_control',false, 'initialStepSize', false);
[X2,T2,function_calls2,hs2] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler",options);
plot(X2(:,1),X2(:,2))
title("ODE, $h = 0.01$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on

h = 0.001;
subplot(2, 3, 6)
% using the explicit euler method
options = struct('step_control',false, 'initialStepSize', false);
[X3,T3,function_calls3,hs3] = ODEsolver(@VanPol,[mu],h,t0,tend,x0, "Explicit Euler",options);
plot(X3(:,1),X3(:,2))
title("ODE, $h = 0.001$",'FontSize',16,'Interpreter','latex')
xlabel("$x_1$",'FontSize',16,'Interpreter','latex')
ylabel("$x_2$",'FontSize',16,'Interpreter','latex')
grid on

sgtitle('Weak vs strong convergence, $\mu = 20$','Interpreter','latex','FontSize',20) 






