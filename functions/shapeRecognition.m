function binaryImage = shapeRecognition(rgbImage,inputArg2)
%SHAPERECOGNÝTÝON Summary of this function goes here
%   Detailed explanation goes here
rgbImage = imresize(rgbImage, [350 350]);

grayImage = convertToGrayscale(rgbImage);
grayImage = invertImage(grayImage);

binaryImage = binarize(adjustContrast(grayImage, 0.4), 0.5);

binaryImage = bwareaopen(binaryImage, 300);

end

