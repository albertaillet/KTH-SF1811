function [beta, nu, terminate] = simplex_iteration(beta, nu, A, b, c)
    terminate = 0;
    % Calculate the values and uptade beta
    A_beta = A(:, beta);
    c_beta = c(beta);

    A_nu = A(:, nu);
    c_nu = c(nu);

    b_bar = A_beta \ b;
    y = A_beta' \ c_beta;
    r_nu = c_nu - A_nu' * y;

    if all(r_nu >= 0)
        terminate = 1;
    else
        [~, q] = min(r_nu);
        a_nu_q = A(:, nu(q));
        a_bar_nu_q = A_beta \ a_nu_q;

        if all(a_bar_nu_q <= 0)
            terminate = -1;
        else
            t = (b_bar ./ a_bar_nu_q);
            t_max = min(t(a_bar_nu_q > 0));
            p = find(t == t_max, 1);
            temp = nu(q);
            nu(q) = beta(p);
            beta(p) = temp;
        end
    end
    % terminate = true or false based on conditions on a_bar_j and r_nu
end