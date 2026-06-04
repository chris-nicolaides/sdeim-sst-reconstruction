function [T_train, T_test, center, ind_water] = preprocess(sst, land)
% prepro vectorizes, splits, and centers the data to prepare it for computations 
%
% INPUTS:
% sst: Sea Surface Temperature data
% land: Land mask
%
% OUTPUTS:
% T_train = Training data
% T_test = Testing data

land(land == 0) = NaN;

A = reshape(sst, [], size(sst, 3));

T_train = A(:, 1:1670);
T_test  = A(:,1671:end);

ind_water = ~isnan(land);
ind_water = ind_water(:);

train_wrap = T_train(ind_water, :); % Training data with land values removed
test_wrap = T_test(ind_water, :); % Testing data with land values removed

center = mean(train_wrap, 2, 'omitmissing');
T_train = train_wrap - center; % Centering about mean of training data
T_test = test_wrap - center;

end
