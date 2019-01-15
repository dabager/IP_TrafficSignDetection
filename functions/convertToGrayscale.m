function ret = convertToGrayscale(image)
%CONVERTTOGRAYSCALE Summary of this function goes here
%   Detailed explanation goes here
channelsize = size(image,3);
imageSizeX = size(image,1);
imageSizeY = size(image,2);
ret = zeros(imageSizeX, imageSizeY);
for i = 1:imageSizeX
    for j = 1:imageSizeY
        pixel = [0, 0, 0];
        for k = 1:channelsize
            pixel(k) = image(i,j,k);
        end
        if (channelsize == 1)
            pixel(2) = pixel(1);
            pixel(3) = pixel(1);
        end
        avg = luminosityGrayscale(pixel(1), pixel(2), pixel(3));
        gs = double(avg) / double(255);
        ret(i,j) = gs;
    end
end
end


