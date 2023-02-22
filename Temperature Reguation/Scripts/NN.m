function y = NN(inputs, outputs)

L = 5;

y = [
    featureInputLayer(inputs, 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(L, 'Name', 'fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(L, 'Name', 'fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(L, 'Name', 'fc3')
    reluLayer('Name','relu3')
    fullyConnectedLayer(L, 'Name', 'fc4')
    reluLayer('Name','relu4')
    fullyConnectedLayer(L, 'Name', 'fc5')
    reluLayer('Name','relu5')
    fullyConnectedLayer(L, 'Name', 'fc6')
    reluLayer('Name','relu6')
    fullyConnectedLayer(L, 'Name', 'fc7')
    reluLayer('Name','relu7')
    fullyConnectedLayer(L+1,'Name','fc8')
    reluLayer('Name','relu8')
    fullyConnectedLayer(L+1,'Name','fc9')
    reluLayer('Name','relu9')
    fullyConnectedLayer(L+1,'Name','fc10')
    reluLayer('Name','relu10')
    fullyConnectedLayer(L+1,'Name','fc11')
    reluLayer('Name','relu11')
    fullyConnectedLayer(L+1,'Name','fc12')
    reluLayer('Name','relu12')
    fullyConnectedLayer(L+1,'Name','fc13')
    reluLayer('Name','relu13')
    fullyConnectedLayer(L+1,'Name','fc14')
    reluLayer('Name','relu14')
    fullyConnectedLayer(L+1,'Name','fc15')
    reluLayer('Name','relu15')
    fullyConnectedLayer(L+1,'Name','fc16')
    reluLayer('Name','relu16')
    fullyConnectedLayer(L+1,'Name','fc17')
    reluLayer('Name','relu17')
    fullyConnectedLayer(L+1,'Name','fc18')
    reluLayer('Name','relu18')
    fullyConnectedLayer(L+1,'Name','fc19')
    reluLayer('Name','relu19')
    fullyConnectedLayer(L+1,'Name','fc20')
    reluLayer('Name','relu20')
    fullyConnectedLayer(L+1,'Name','fc21')
    reluLayer('Name','relu21')
    dropoutLayer(0.7)
    fullyConnectedLayer(outputs, 'Name', 'output')];

end


% %% Agent creation
% L = 8;
% dnn = [
%     featureInputLayer(obsInfo.Dimension(1), 'Normalization', 'none', 'Name', 'state')
%     fullyConnectedLayer(L, 'Name', 'fc1')
%     reluLayer('Name','relu1')
%     fullyConnectedLayer(L, 'Name', 'fc2')
%     reluLayer('Name','relu2')
%     fullyConnectedLayer(L, 'Name', 'fc3')
%     reluLayer('Name','relu3')
%     fullyConnectedLayer(L, 'Name', 'fc4')
%     reluLayer('Name','relu4')
%     fullyConnectedLayer(L, 'Name', 'fc5')
%     reluLayer('Name','relu5')
%     fullyConnectedLayer(L, 'Name', 'fc6')
%     reluLayer('Name','relu6')
%     fullyConnectedLayer(L, 'Name', 'fc7')
%     reluLayer('Name','relu7')
%     fullyConnectedLayer(L+1,'Name','fc8')
%     reluLayer('Name','relu8')
%     fullyConnectedLayer(L+1,'Name','fc9')
%     reluLayer('Name','relu9')
%     fullyConnectedLayer(L+1,'Name','fc10')
%     reluLayer('Name','relu10')
%     dropoutLayer(0.7)
%     fullyConnectedLayer(outputs, 'Name', 'output')];