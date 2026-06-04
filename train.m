% TRAIN

clear;
rng(2, "twister");

%% Reading in Data
disp('Load Data...')
addpath('functions');
addpath('data');

sst = ncread('sst.wkmean.1990-present.nc', 'sst');
land = ncread('lsmask.nc','mask');

%% Pre-processing Data
disp('Preprocess Data...')
[T_train, ~, ~, ~] = preprocess(sst, land); 

%% Number of modes and sensors

m = 300;
r = 100;

%% POD
disp('Compute POD Modes...')
phi_m = POD(T_train, m);

%% CPQR Sensor Placement
disp('Compute Sensor Locations...')
[S_r,p] = sensorplacement(phi_m, r);

%% Kernel Matrix

Z = null(S_r'*phi_m);

%% Prepare Data

Xin = S_r'*T_train;
Xout = Z'*phi_m'*T_train;

%% Reservoir Computing
disp('Train RC Network...')
% Hyperparameters

Wr_density = 0.4;
alph = 1;
Nr = 100;
lamd = 1e-8;

% Set-up

Wr = generate_Wr(Nr, Wr_density);
b = rand(Nr, 1) - 0.5;
Win = rand(Nr, r) - 0.5;

% Training

[Wout, R] = RC_train(Xin, Xout, Wr, Win, b, alph, lamd);

%% LSTM
disp('Train LSTM Network...')
% Hyperparamaters

hidden_unit = 300;
learn_rate = 0.01;
drop_period = 50;
drop_factor = 0.1;

% Training

lstm_net = train_lstm(Xin, Xout, m, r, hidden_unit, learn_rate, drop_period, drop_factor);

%% Outputs

save('test_inputs.mat', 'phi_m', 'T_train', 'S_r', 'p');
save("trained_RC.mat","Wr","Win", "b", "alph", "Wout", "R");
save("trained_LSTM.mat","lstm_net");

