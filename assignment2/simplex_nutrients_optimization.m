%% load data and functions
addpath( genpath( [fileparts(pwd), filesep, 'assignment-1'] ) )
load('data.mat')

%% primal problem
% min c' x
% Ax >= b
% x >= 0
[m, n] = size(A);
% standard form problem
A_primal = [A -eye(m)];
c_primal = [c; zeros(m, 1)];

% find INITIAL basic feasible solution if such exists
A_init = [A_primal eye(m)];
c_init = [zeros(n+m,1); ones(m, 1)];
beta_init = n+m+1:n+2*m;
[x_opt, cost_init, ~] = simplex_method(A_init, b, c_init, beta_init);
assert(all(size(find(x_opt>0)) == size(b))) % check that the solution is non-degenerate (otherwise we would have to add some indices of value 0)
assert(all(x_opt(n+m+1:end) == 0*x_opt(n+m+1:end))) % check condition for x_opt being basic feasible solution
assert(cost_init == 0) % check condition for x_opt being basic feasible solution
beta0_primal = find(x_opt>0);

% solution to standard form problem using initial indexing
[x_opt_primal, cost_primal, ~] = simplex_method(A_primal, b, c_primal, beta0_primal);

% solution to primal problem
x_opt_primal = x_opt_primal(1:n);

% save in table
table2 = table(cellstr(names(x_opt_primal>0,:)), 100*x_opt_primal(x_opt_primal>0));
table2.Properties.VariableNames = ["Food_Product","Amount_in_g"];
writetable(table2, 'table_optimal_nutrients_simplex');

%% dual problem
% max b' y
% A' y <= c
% y >= 0

% standard form problem
% size(A') = (n, m)
A_dual = [A' eye(n)]; 
b_dual = [-b; zeros(n, 1)];

% find INITIAL basic feasible solution for standard dual problem if such exists
A_dual_init = [A_dual eye(n)];
b_dual_init = [zeros(m+n,1); ones(n, 1)];
beta_dual_init = m+n+1:m+2*n;
[x_dual_opt, cost_dual_init, ~] = simplex_method(A_dual_init, c, b_dual_init, beta_dual_init);
assert(all(x_dual_opt(n+m+1:end) == 0*x_dual_opt(n+m+1:end)))
assert(all(size(find(x_dual_opt>0)) == size(c)))
assert(cost_dual_init == 0)
beta0_dual = find(x_dual_opt>0);

% solution to standard form dual problem using initial indexing
[x_opt_dual, cost_dual, ~] = simplex_method(A_dual, c, b_dual, beta0_dual);

% check duality condition
assert(cost_primal +  cost_dual < 10^(-10));
