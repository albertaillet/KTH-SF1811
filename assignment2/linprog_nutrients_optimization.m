%% load data
load('data.mat')
%% primal problem
% min c' x
% Ax >= b
% x >= 0
[x,fval_primal] = linprog(c,-A,-b,[],[],zeros(size(c)),[]);

%%
table1 = table(cellstr(names(x>0,:)), 100*x(x>0));
table1.Properties.VariableNames = ["Food_Product","Amount_in_g"];
writetable(table1, 'table_optimal_nutrients');

%% dual problem
% max b' y
% A' y <= c
% y >= 0

[y,fval_dual] = linprog(-b,A',c,[],[],zeros(size(b)),[]);
assert(abs(fval_primal + fval_dual) < 10^-10);