function layers = NN2(inputs, outputs)

% Define layers
f1 = featureInputLayer(inputs,"Name","state");
lstm1 = lstmLayer(64);
fc1 = fullyConnectedLayer(32,'Name','fc1');
drop1 = dropoutLayer(0.2);
fc2 = fullyConnectedLayer(64,'Name','fc2');
drop2 = dropoutLayer(0.2);
fc3 = fullyConnectedLayer(128,'Name','fc3');
drop3 = dropoutLayer(0.2);
fc4 = fullyConnectedLayer(outputs,'Name','output');
softmax = softmaxLayer('Name','output');

% Assemble layers
layers = [
    f1
    fc1
    drop1
    fc2
    drop2
    fc3
    drop3
    fc4
    ];

end

