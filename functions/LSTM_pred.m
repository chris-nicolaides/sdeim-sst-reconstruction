function xi_LSTM = LSTM_pred(S_r, T_train, train_Y, test_X, lstm_net)
% LSTM_pred computes the predicted xi value using LSTM
%
% INPUTS:
%   S_r: Selection matrix of sensor placements
%   T_train: Training data
%   train_Y: Optimal xi used for training
%   test_X: Observations
%   lstm_net: Pretrained LSTM network
%
% OUTPUTS:
%   xi_LSTM = predicted xi value

train_X = S_r' * T_train; 

sig_X = std(train_X,0,2);
mu_X = mean(train_X,2);

mu_Y = mean(train_Y,2);
sig_Y = std(train_Y,0,2);

test_X = (test_X-mu_X)./sig_X;

for i = 1:size(test_X,2)    
    [lstm_net, xi_LSTM(:,i)] = predictAndUpdateState(lstm_net, test_X(:,i)); 
    xi_LSTM(:,i) = xi_LSTM(:,i).* sig_Y + mu_Y; 
    test_X(:,i) = test_X(:,i).* sig_X + mu_X; 
end


end