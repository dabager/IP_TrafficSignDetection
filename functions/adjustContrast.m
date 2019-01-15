function img = adjustContrast(image, contrastAdjuster)
%CONTRASTADJUSTER Summary of this function goes here
% Detailed explanation goes here
% For given contrastAdjuster value, if pixel value is smaller set 0, if
% pixel value is greater than 1 - contrastAdjuster value set 1, else set
% normal pixel value.
imageSizeX = size(image,1);
imageSizeY = size(image,2);
img = zeros(imageSizeX, imageSizeY);
for i = 1:imageSizeX
    for j = 1:imageSizeY
        if (image(i,j) < contrastAdjuster)
            img(i,j) = 0;
        elseif (image(i,j) > (1 - contrastAdjuster))
            img(i,j) = 1;
        else
            img(i,j) = image(i,j);
        end
    end
end
return;
end