function y = NN(inputs, outputs)

L = 10;

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