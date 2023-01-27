function y = NN3(inputs, outputs)

L = 15;

y = [
    featureInputLayer(inputs, 'Name', 'state')
    fullyConnectedLayer(L, 'Name','fc1')
    reluLayer('Name','RL1')
    fullyConnectedLayer(L, 'Name','fc2')
    reluLayer('Name','RL2')
    fullyConnectedLayer(L, 'Name','fc3')
    reluLayer('Name','RL3')
    fullyConnectedLayer(L, 'Name','fc4')
    reluLayer('Name','RL4')
    fullyConnectedLayer(L, 'Name','fc5')
    reluLayer('Name','RL5')
    fullyConnectedLayer(L, 'Name','fc6')
    reluLayer('Name','RL6')
    fullyConnectedLayer(L, 'Name','fc7')
    reluLayer('Name','RL7')
    fullyConnectedLayer(L, 'Name','fc8')
    reluLayer('Name','RL8')
    fullyConnectedLayer(L, 'Name','fc9')
    reluLayer('Name','RL9')
    fullyConnectedLayer(L, 'Name','fc10')
    reluLayer('Name','RL10')
    fullyConnectedLayer(L, 'Name','fc11')
    reluLayer('Name','RL11')
    dropoutLayer(0.7)
    fullyConnectedLayer(outputs, 'Name','output')];

end


