function img = invertImage(image)
%ÝNVERTIMAGE Summary of this function goes here
%   Detailed explanation goes here
% Invert the pixels
imageSizeX = size(image,1);
imageSizeY = size(image,2);
img = zeros(imageSizeX, imageSizeY);
for i = 1:imageSizeX
    for j = 1:imageSizeY
        img(i,j) = 1 - image(i,j);
    end
end
return;
end