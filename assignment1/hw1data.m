%%% hw1data.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Problem data for homework assignment 1, SF1811, 2022/2023
%
%% Test problem 1
rng(610729)
%% Test problem 2
rng(001127)
%% Test problem 3
rng(980414)
%% Generate matrix
m=5;
n=12;
A=[randi([0 m],m,n-m) eye(m)];
b=randi([m 2*m],m,1);
c=[-randi([1 n-m],n-m,1) ; zeros(m,1) ];
%basis=[n-m+1:n]
%% To solve problem
[x_opt, cost_opt, iterations] = simplex_method(A, b, c)
[x_linprog, cost_linprog] = linprog(c,[],[],A,b,zeros(n, 1),[]);

%% Extra tests
for i = 1:100
    %display(i)
    % make random matrices
    m=randi([1 99]);
    n=randi([m+1 100]);
    A=[randi([0 m],m,n-m) eye(m)];
    b=randi([m 2*m],m,1);
    c=[-randi([1 n-m],n-m,1) ; zeros(m,1) ];
    
    [x_linprog, cost_linprog] = linprog(c,[],[],A,b,zeros(n, 1),[]);
    [x_opt, cost_opt, iterations] = simplex_method(A, b, c);
    if isempty(x_linprog)   % if a solution does not exist
        assert(isempty(x_opt))
    else                    % if a solution exists
        epsilon = 10^-10;
        assert(all(abs([x_opt' cost_opt] - [x_linprog' cost_linprog]) < epsilon))
    end
end