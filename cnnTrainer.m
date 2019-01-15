clc;
close all;
imtool close all;
clear;
workspace;

% Configure image dataset
imageDataset = imageDatastore('images/training', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[dsTrain,dsValidation] = splitEachLabel(imageDataset,0.25,'randomized');

% CNN parameter
net = resnet101;

inputSize = net.Layers(1).InputSize;

lgraph = layerGraph(net);

% Remove last layers
lgraph = removeLayers(lgraph, {'fc1000','prob','ClassificationLayer_predictions'});

numClasses = numel(categories(dsTrain.Labels));

% Create new layers and connect to rest
newLayers = [
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'pool5','fc');

% Freeze initial 320 layers (All except last block and classification layers)
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:320) = freezeWeights(layers(1:320));
lgraph = createLgraphUsingConnections(layers,connections);

% Configuring image augmenter
imageAugmenter = imageDataAugmenter( ...
    'RandXTranslation', [-30 30], ...
    'RandYTranslation', [-30 30], ...
    'RandRotation', [-15 15], ...
    'RandXScale', [0.5 1.5], ...
    'RandYScale', [0.5 1.5], ...
    'RandXShear', [-30 30], ...
    'RandYShear', [-30 30]);

augimdsTrain = augmentedImageDatastore(inputSize, dsTrain, ...
    'DataAugmentation',imageAugmenter, 'DispatchInBackground', true);

augimdsValidation = augmentedImageDatastore(inputSize, dsValidation);

% Training phase
options = trainingOptions('adam', ...
    'MiniBatchSize', 16, ...
    'MaxEpochs', 15, ...
    'InitialLearnRate', 1e-4, ...
    'ValidationData', augimdsValidation, ...
    'ValidationFrequency', 3, ...
    'ValidationPatience', Inf, ...
    'Verbose', true , ...
    'Plots', 'training-progress');

[net, traininfo] = trainNetwork(augimdsTrain,lgraph,options);

% Save the model and training information
% save('resnet101', 'net', 'options', 'traininfo');

% Test the behaviour
[YPred, probs] = classify(net,augimdsValidation);
accuracy = mean(YPred == dsValidation.Labels);

idx = randperm(numel(dsValidation.Files),4);
for i = 1:4
    subplot(2,2,i)
    I = readimage(dsValidation,idx(i));
    imshow(I)
    label = YPred(idx(i));
    title(string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
end


function layers = freezeWeights(layers)

    for i = 1:numel(layers)
        if isprop(layers(i),'WeightLearnRateFactor')
            layers(i).WeightLearnRateFactor = 0;
        end
        if isprop(layers(i),'WeightL2Factor')
            layers(i).WeightL2Factor = 0;
        end
        if isprop(layers(i),'BiasLearnRateFactor')
            layers(i).BiasLearnRateFactor = 0;
        end
        if isprop(layers(i),'BiasL2Factor')
            layers(i).BiasL2Factor = 0;
        end
    end

end

function lgraph = createLgraphUsingConnections(layers,connections)

lgraph = layerGraph();
for i = 1:numel(layers)
    lgraph = addLayers(lgraph,layers(i));
end

for c = 1:size(connections,1)
    lgraph = connectLayers(lgraph,connections.Source{c},connections.Destination{c});
end

end