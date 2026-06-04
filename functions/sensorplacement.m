function [S_r,p] = sensorplacement(phi_m, r)
% sensorplacement compute the selection matrix S_r for sensor placements
%
% INPUTS:
% phi_m: matrix of basis vectors  (n_water x m)
% r:     number of sensors
%
% OUTPUTS:
% S_r : selection matrix that picks the r sensor locations
% p   : permutation vector of length r (sensor indices)
%
% Notes:
%   For r <= m the implementation is CPQR on phi_m(:, 1:r)' as
%   originally (rank-revealing pivots).
%
%   For r >  m we cannot condition on more modes than the basis has,
%   so CPQR runs on phi_m(:, 1:m)' for the first m sensors, and the
%   additional r - m sensors are picked greedily by descending row
%   norm of phi_m among the remaining grid points -- i.e. we add the
%   locations where the POD basis itself has the largest amplitude.
%   This produces over-determined S_r' * phi_m systems that genuinely
%   improve conditioning relative to r = m, rather than appending
%   rank-deficient continuation pivots from the same QR (which carry
%   near-zero information and leave Q-DEIM identical to the r = m
%   case).

m = size(phi_m, 2);
n_water = size(phi_m, 1);
r_cpqr = min(r, m);

[~, ~, p_cpqr] = qr(phi_m(:, 1:r_cpqr)', 'vector');

if r <= m
    p = p_cpqr(1:r);
else
    chosen = p_cpqr(1:m);
    remaining = setdiff(1:n_water, chosen);
    row_norms = vecnorm(phi_m(remaining, :), 2, 2);
    [~, order] = sort(row_norms, 'descend');
    extras = remaining(order(1:(r - m)));
    p = [chosen(:); extras(:)];
end

I = speye(n_water);
S_r = I(:, p);

end