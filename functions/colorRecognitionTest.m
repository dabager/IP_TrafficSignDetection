clc;
close all;
imtool close all;
clear;
workspace;
fontSize= 14;

im = 'color space low contrast.jpg';

rgbImage = imread(im);
rgbImage = imresize(rgbImage, [350 350]);

subplot(2,4,1);
imshow(rgbImage, []);
title('Input Image', 'FontSize', fontSize);

color = [255 0 0];
colorName = 'Red';
ang_thres = 25; % degrees. You should change this to suit your needs
mag_thres = 64; % You should change this to suit your needs

for i = 1:7
    switch (i)
        case 1
            color = [255 0 0];
            colorName = 'Red';
        case 2
            color = [0 255 0];
            colorName = 'Green';
        case 3
            color = [0 0 255];
            colorName = 'Blue';
        case 4
            color = [255 255 0];
            colorName = 'Yellow';
        case 5
            color = [255 106 0];
            colorName = 'Orange';
        case 6
            color = [165 42 42];
            colorName = 'Brown';
        case 7
            color = [255 255 255];
            colorName = 'White';
    end
    
    
    retImage = checkForColor(rgbImage, color, ang_thres, mag_thres);   
    
    subplot(2,4,i + 1);
    imshow(retImage, []);
    title(colorName, 'FontSize', fontSize);
end