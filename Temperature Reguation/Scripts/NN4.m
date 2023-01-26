function y = NN4(inputs, outputs)

filter_size = 3;
num_filters = 32;

input_layer = sequenceInputLayer(inputs, 'Name','state');
conv_layer1 = convolution1dLayer(filter_size, num_filters);
batch_norm1 = batchNormalizationLayer();
relu_layer1 = reluLayer();
conv_layer2 = convolution1dLayer(filter_size, num_filters);
batch_norm2 = batchNormalizationLayer();
relu_layer2 = reluLayer();
fully_connected = fullyConnectedLayer(outputs);
output_layer = regressionLayer('Name', 'output');

y = [input_layer, conv_layer1, batch_norm1, relu_layer1, conv_layer2, batch_norm2, relu_layer2, fully_connected, output_layer];

end


