% TEST
clear;

%% Load
disp('Loading data...')
addpath("data/");
addpath("functions/");

sst = ncread('sst.wkmean.1990-present.nc', 'sst');
land = ncread('lsmask.nc','mask');

load test_inputs.mat
load trained_RC.mat
load trained_LSTM.mat

[T_train, T_test, center, ind_water] = preprocess(sst, land); 

%% Reconstuctions

%Best Fit
disp('Computing best fit...')
T_ortho = phi_m*(phi_m'*T_test);

%Q-DEIM
disp('Computing Q-DEIM...')
y = S_r'*T_test; % Observations
T_qdeim = phi_m*pinv(S_r'*phi_m)*y;

%S-DEIM Optimal
disp('Computing Optimal S-DEIM...')
Z = null(S_r'*phi_m); % Kernel Matrix
xi_opt = Z'*phi_m'*T_test;

T_sdeim_opt = T_qdeim + phi_m*Z*xi_opt;

%S-DEIM w/ RC
disp('Computing S-DEIM w/ RC...')
xi_RC = RC_pred(y,Wr,Win,b,alph,Wout,R); %Xi estimated through reservoir computing
T_sdeim_RC =  T_qdeim + phi_m*Z*xi_RC;

%S-DEIM w/ LSTM
disp('Computing S-DEIM w/ LSTM...')
burn_in = 50; 
sample = S_r'*T_train(:,end-burn_in+1:end);
y_test = cat(2, sample, y); % Add in burn-in period

xi_train = Z'*phi_m'*T_train;
xi_LSTM = LSTM_pred(S_r, T_train, xi_train, y_test, lstm_net);
xi_LSTM = xi_LSTM(:,burn_in+1:end);
T_sdeim_LSTM =  T_qdeim + phi_m*Z*xi_LSTM;

%% Output folder for figures

out_dir = fullfile('results', 'Test');
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

%% Error plot
errorPlot = error_plot(T_ortho,T_qdeim,T_sdeim_opt,T_sdeim_RC,T_sdeim_LSTM,T_test);

