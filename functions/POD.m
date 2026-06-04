function phi_m = POD(T_train, m)
% POD Calculates the POD modes used for 
%
% INPUTS:
% train: training data
% m: number of modes
%
% OUTPUTS:
% phi_m = matrix of basis vectors

[U,~,~] = svd(T_train, "econ");
phi_m = U(:, 1:m);

end