function ret = convolute(image, kernel)
%CONVOLUTE Summary of this function goes here
%   Detailed explanation goes here
kernelSizeX = size(kernel, 1);
kernelSizeY = size(kernel, 2);

imageSizeX = size(image,1);
imageSizeY = size(image,2);

flippedKernel = zeros(kernelSizeX, kernelSizeY);

for i = 1:kernelSizeX
    for j = 1:kernelSizeY
        flippedKernel(i, j) = kernel(kernelSizeX - i + 1, kernelSizeY - j + 1);
    end
end

imageX = 1;
imageY = 1;

ret = zeros(imageSizeX - (kernelSizeX - 1), imageSizeY - (kernelSizeX - 1));
for i = (1 + ((kernelSizeX - 1) / 2)):(imageSizeX - ((kernelSizeX - 1) / 2))
    for j = (1 + ((kernelSizeY - 1) / 2)):(imageSizeY - ((kernelSizeY - 1) / 2))
        for a = 1:kernelSizeX
            imageIndexerX = -((kernelSizeX - 1) / 2) + a - 1;
            for b = 1:kernelSizeY
                imageIndexerY = -((kernelSizeY - 1) / 2) + b - 1;
                ret(imageX,imageY) = ret(imageX,imageY) + image(i + imageIndexerX, j + imageIndexerY) * flippedKernel(a,b);
            end
        end
        imageY = imageY + 1;
    end
    imageX = imageX + 1;
    imageY = 1;
end
end