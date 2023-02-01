function [x_opt, cost, iter] = simplex_method(A, b, c)
    % Calculate the values and uptade beta
    iter = 0;
    [m, n] = size(A);
    % Due to the structure of A, we can get an analytic 
    % basic feasible solution given as:
    beta = n-m+1:n; 
    nu = 1:n-m;
    while true
        iter = iter + 1;
        % update beta, nu and bfs
        [beta, nu, terminate] = simplex_iteration(beta, nu, A, b, c);
        if terminate == 1
            A_beta = A(:, beta);
            b_bar = A_beta \ b;
            x_opt = zeros(n, 1);
            x_opt(beta) = b_bar;
            cost = c' * x_opt;
            break
        elseif terminate == -1
            x_opt = [];
            cost = [];
            break
        end
    end
end

