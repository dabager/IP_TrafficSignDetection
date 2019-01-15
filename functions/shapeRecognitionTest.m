clc;
close all;
imtool close all;
clear;
workspace;
fontSize= 20;

im = 'mixtest.jpg';

rgbImage = imread(im);
rgbImage = imresize(rgbImage, [350 350]);
[rows, columns, numberOfColorBands] = size(rgbImage);
subplot(2,2,1);
imshow(rgbImage, []);
title('Input Image', 'FontSize', fontSize);
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
set(gcf, 'name', 'srdemo', 'numbertitle', 'off');
grayImage = convertToGrayscale(rgbImage);
grayImage = invertImage(grayImage);

subplot(2,2,2);
imshow(grayImage, []);
title('Grey Image', 'FontSize', fontSize);

binaryImage = binarize(adjustContrast(grayImage, 0.4), 0.5);

subplot(2,2,3);
imshow(binaryImage, []);
title('binaryImage', 'FontSize', fontSize);

binaryImage = bwareaopen(binaryImage, 300);

subplot(2,2,4);
imshow(binaryImage, []);
title('clean binaryImage', 'FontSize', fontSize);
[labeledImage, numberOfObjects] = bwlabel(binaryImage);
blobMeasurements = regionprops (labeledImage,...
    'Perimeter', 'Area', 'FilledArea', 'Solidity', 'Centroid');

filledImage = imfill(binaryImage, 'holes');
imshow(filledImage);
boundaries = bwboundaries(filledImage);

perimeters = [blobMeasurements.Perimeter];
areas = [blobMeasurements.Area];
filledAreas = [blobMeasurements.FilledArea];
solidities = [blobMeasurements.Solidity];

circularities = perimeters .^2 ./ (4 * pi * filledAreas);

fprintf('#, pre, are, fill, sold, circ \n');
for blobNumber = 1 : numberOfObjects
    fprintf('%d, %9.3f, %11.3f, %11.3f, %8.3f, %11.3f \n', ...
        blobNumber, perimeters(blobNumber), areas(blobNumber), ...
        filledAreas(blobNumber), solidities(blobNumber), circularities(blobNumber));
end

for blobNumber = 1 : numberOfObjects
    thisBoundary = boundaries(blobNumber);
    subplot(2,2,2);
    hold on;
    for k=1 : blobNumber -1
        thisBoundary = boundaries(k);
        [~, y] = size(thisBoundary);
        if(y > 1)
            plot(thisBoundary(:,2), thisBoundary(:,1), 'b', 'LineWidth', 3);
        end
    end
    thisBoundary = boundaries(blobNumber);
    [x, y] = size(thisBoundary);
    if(y > 1)
        
        plot(thisBoundary(:,2), thisBoundary(:,1), 'b', 'LineWidth', 3);
    end
    subplot(2,2,4);
    if circularities(blobNumber) < 1.10
        shape = 'circle';
    elseif circularities(blobNumber) < 2.0
        shape = 'rectangle';
    else
        shape = 'something else';
    end
    
    button = questdlg(shape, 'Continue', 'Continue', 'Cancel', 'Continue');
    if(strcmp(button, 'Cancel'))
        break;
    end
end