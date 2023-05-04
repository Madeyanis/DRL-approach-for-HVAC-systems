clc
clear all;


% data = iris_dataset';
% 
% c = cvpartition(size(data, 1),'HoldOut',0.3);
% idxTrain = training(c);
% idxTest = test(c);
% dataTrain = data(idxTrain,:);
% dataTest = data(idxTest,:);


dataTrain = load('dataTrain2.mat');
dataTest = load('datatest2.mat');
xTrain = dataTrain.X;
yTrain = dataTrain.y;
xTest = dataTest.X;
yTest = dataTest.y;

clear dataTrain
clear dataTest

layers = [
    featureInputLayer(4,"Name","featureinput")
    fullyConnectedLayer(14,"Name","fc_1")
    reluLayer
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer
    ];


options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',10000, ...
    'GradientThreshold',2, ...
    'Shuffle','every-epoch', ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(xTrain, categorical(yTrain), layers,options);




