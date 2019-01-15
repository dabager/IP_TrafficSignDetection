function [boundingBoxes_signs, labels_signs] = classifier(image, net, reducedBoundingBoxes)

global lowerBound upperBound IoU

classes = net.Layers(end).ClassNames;
labels = zeros(size(reducedBoundingBoxes,1), 1);

for i = 1:size(reducedBoundingBoxes,1)
    labels(i) = classify(net, imresize(imcrop(image, reducedBoundingBoxes(i,:)), net.Layers(1).InputSize(1:2)));
end

background_index = find(strcmp(classes, 'background'));
reducedBoundingBoxes = reducedBoundingBoxes(labels ~= background_index,:);
labels(labels == background_index) = [];

keep = removeOverlappedRegions(reducedBoundingBoxes, lowerBound, upperBound, IoU);
boundingBoxes_signs = reducedBoundingBoxes(keep,:);
labels_signs = labels(keep);
labels_signs = classes(labels_signs);

end