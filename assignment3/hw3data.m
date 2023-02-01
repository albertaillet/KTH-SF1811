%% Create the data here
% Problem data for homework assignment 3, SF1811, 2022/2023
% Creates C and mu
rng(001127)
n=8;
Corr=zeros(n,n);
for i=1:n
    for j=1:n
        Corr(i,j)=(-1)^abs(i-j)/(abs(i-j)+1);
    end 
end
sigma=zeros(n,1);
mu=zeros(n,1);
sigma(1)=2;
mu(1)=3;
for i=1:n-1
    sigma(i+1)=sigma(i)+2*rand;
    mu(i+1)=mu(i)+1;
end
D=diag(sigma);
C2=D*Corr*D;
C=0.5*(C2+C2');
r = 3:0.25:9;

%% Exercise 1
ex1_sigmas = zeros(25, 1);
ex1_means = zeros(25, 1);
ex1_Xs = zeros(n, 25);

for i=1:25
    [x, fval] = quadprog( ...
        2*C, [], [], [], ...
        [mu'; ones(1, n)], [r(i); 1], zeros(n, 1) ...
    );
    ex1_sigmas(i) = sqrt(fval);
    ex1_means(i) = mu'*x;
    ex1_Xs(:, i) = x;
end

%% Figure for Exercise 1 Portfolio
fig = figure;
idx = 1:4:25;
plot(1:n, ex1_Xs(:, idx), '-x');
grid on
ylabel('x_i')
xlabel('asset number i')
ylim([-0.3 1])
legend('r = ' + string(r(idx)))
title('Portfolio for different r')
saveas(fig, 'images/ex1_portfolio.png')

%% Exercise 2
ex2_sigmas = zeros(25, 1);
ex2_means = zeros(25, 1);
ex2_Xs = zeros(n, 25);

for i=1:25
    [x, fval] = quadprog( ...
        2*C, [], ones(1, n), 1, ...
        mu', r(i), zeros(n, 1) ...
    );
    ex2_sigmas(i) = sqrt(fval);
    ex2_means(i) = mu'*x;
    ex2_Xs(:, i) = x;
end

%%  Figure 1
fig1 = figure(1);
plot(ex1_sigmas, ex1_means, '-o')
hold on
plot(ex2_sigmas, ex2_means, '-x')
legend('Exercise 1', 'Exercise 2')
grid on
xlabel('\sigma(x)')
ylabel('\mu(x)')
xlim([0 2.5])
ylim([2 10])
title('\mu(x) for different values of \sigma(x)')
saveas(fig1, 'images/fig1.png')

%% Figure for Exercise 2 Portfolio
fig = figure;
idx = 1:4:25;
plot(1:n, ex2_Xs(:, idx), '-x');
grid on
ylabel('x_i')
xlabel('asset number i')
ylim([-0.3 1])
legend('r = ' + string(r(idx)))
title('Portfolio for different r')
saveas(fig, 'images/ex2_portfolio.png')

%% Exercise 3
ex3_sigmas = zeros(25, 1);
ex3_means = zeros(25, 1);
ex3_Xs = zeros(n, 25);

for i=1:25
    [x, fval] = quadprog( ...
        2*C, [], -mu', -r(i), ...
        ones(1, n), 1, zeros(n, 1) ...
    );
    ex3_sigmas(i) = sqrt(fval);
    ex3_means(i) = mu'*x;
    ex3_Xs(:, i) = x;
end

%%  Figure 2
fig2 = figure(2);
plot(ex1_sigmas, ex1_means, '-o')
hold on
plot(ex3_sigmas, ex3_means, '-x')
legend('Exercise 1', 'Exercise 3')
grid on
xlabel('\sigma(x)')
ylabel('\mu(x)')
xlim([0 2.5])
ylim([2 10])
title('\mu(x) for different values of \sigma(x)')
saveas(fig2, 'images/fig2.png')

%% Figure for Exercise 3 Portfolio
fig = figure;
idx = 1:4:25;
plot(1:n, ex3_Xs(:, idx), '-x');
grid on
ylabel('x_i')
xlabel('asset number i')
ylim([-0.3 1])
legend('r = ' + string(r(idx)))
title('Portfolio for different r')
saveas(fig, 'images/ex3_portfolio.png')

%% Exercise 4
ex4_sigmas = zeros(25, 1);
ex4_means = zeros(25, 1);
ex4_Xs = zeros(n, 25);

for i=1:25
    [x, fval] = quadprog( ...
        2*C, [], [], [], ...
        [mu'; ones(1, n)], [r(i); 1] ...
    );
    ex4_sigmas(i) = sqrt(fval);
    ex4_means(i) = mu'*x;
    ex4_Xs(:, i) = x;
end

%% Figure 3
fig3 = figure(3);
plot(ex1_sigmas, ex1_means, '-o')
hold on
plot(ex4_sigmas, ex4_means, '-x')
legend('Exercise 1', 'Exercise 4')
grid on
xlabel('\sigma(x)')
ylabel('\mu(x)')
xlim([0 2.5])
ylim([2 10])
title('\mu(x) for different values of \sigma(x)')
saveas(fig3, 'images/fig3.png')

%% Figure for Exercise 4 Portfolio
fig = figure;
idx = 1:4:25;
plot(1:n, ex4_Xs(:, idx), '-x');
grid on
ylabel('x_i')
xlabel('asset number i')
ylim([-0.3 1])
legend('r = ' + string(r(idx)))
title('Portfolio for different r')
saveas(fig, 'images/ex4_portfolio.png')