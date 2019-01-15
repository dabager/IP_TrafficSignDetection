function retImage = checkForColor(image, color, ang_thres, mag_thres)
%CHECKFORCOLOR Summary of this function goes here
%   Detailed explanation goes here
retImage = zeros(350,350);
pixel = [0 0 0];
for x = 1 : 350
    for y = 1:350 
        for i = 1 :3
            pixel(i) = image(x,y,i);
        end
        blVal = color/norm(color);
        pxVal = pixel / norm(pixel);
        ang = acosd(dot(blVal, pxVal));
        mag = norm(pixel);
        isGivenColor = ang <= ang_thres & mag >= mag_thres; % Apply both thresholds
        retImage(x,y) = isGivenColor;
    end
end
end

