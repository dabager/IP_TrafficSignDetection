function img = binarize(image, threshold)
%BÝNARÝZE Summary of this function goes here
%   Detailed explanation goes here
% Binarize the image for given threshold.
imageSizeX = size(image,1);
imageSizeY = size(image,2);
img = zeros(imageSizeX, imageSizeY);
for i = 1:imageSizeX
    for j = 1:imageSizeY
        if (image(i,j) < threshold)
            img(i,j) = 0;
        else
            img(i,j) = 1;
        end
    end
end
return;
end