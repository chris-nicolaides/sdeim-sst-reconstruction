function net = train_lstm(train_X, train_Y, m, r, numHiddenUnits, learn_rate, drop_period, drop_factor, max_epochs, training_plots, verbose)

if nargin < 9 || isempty(max_epochs)
    max_epochs = 300;
end

if nargin < 10 || isempty(training_plots)
    training_plots = 'training-progress';
end

if nargin < 11 || isempty(verbose)
    verbose = 0;
end


% Normalize the data

mu_X = mean(train_X,2);
sig_X = std(train_X,0,2);
train_X = (train_X-mu_X)./sig_X;

mu_Y= mean(train_Y,2);
sig_Y = std(train_Y,0,2);
train_Y = (train_Y-mu_Y)./sig_Y; 

numFeatures = r;
numResponses = m-r;

layers = [sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',max_epochs, ...
    'InitialLearnRate',learn_rate, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',drop_period, ...
    'LearnRateDropFactor',drop_factor, ...
    'Verbose',verbose, ...
    'Plots',training_plots);

net = trainNetwork(train_X, train_Y, layers, options);

end
