clc;
close all;
imtool close all;
clear;
workspace;

% Global variables
global xtimesbigger xtimeslonger red_thresholds blue_thresholds lowerBound upperBound IoU

xtimesbigger = 10; % Threshold for small contours removal
xtimeslonger = 2; % Threshold for aspect ratio of bounding box
red_thresholds = [90 0.50 0.25]; % Thresholds to isolate red color objects
blue_thresholds = [150 0.50 0.25]; % Thresholds to isolate blue color objects

% boundingBox simplification thresholds:
lowerBound = 0.75;  
IoU = 0.5;
upperBound = 1;

if ~exist('net', 'var')
    load('trainedCNN');
end

image = 'images/scenes/Scene (65).jpg';

rgbImage = imread(image);

enhancedRGB = colorEnhancer(rgbImage,1.4);

boundingBoxes = findRegions(enhancedRGB);
reducedBoundingBoxes = regionReduction(boundingBoxes);

[boundingBoxes_signs, labels_signs] = classifier(enhancedRGB, net, reducedBoundingBoxes);

if (size(boundingBoxes_signs, 1) > 0 && size(labels_signs, 1) > 0)
    enhancedRGB = insertObjectAnnotation(enhancedRGB, 'rectangle', boundingBoxes_signs, cellstr(labels_signs), 'LineWidth', 3, 'FontSize', 18);
end

imshow(enhancedRGB);
