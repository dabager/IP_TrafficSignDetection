function returnImage = colorEnhancer(rgbImage, enhancerConstant)

hsv = rgb2hsv(rgbImage);
hChannel = hsv(:, :, 1);
sChannel = hsv(:, :, 2);
vChannel = hsv(:, :, 3);
sChannel = sChannel * enhancerConstant;
hsv = cat(3, hChannel, sChannel, vChannel);
returnImage = hsv2rgb(hsv);

end

