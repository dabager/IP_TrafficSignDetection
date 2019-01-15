function boundingBoxes = findRegions(image)
global xtimesbigger xtimeslonger red_thresholds blue_thresholds

boundingBoxes = [rgbDetector(image, 'red', 'RGB', red_thresholds, xtimesbigger, xtimeslonger);
    rgbDetector(image, 'blue', 'RGB', blue_thresholds, xtimesbigger, xtimeslonger);
    rgbDetector(image, 'red', 'HSV', [], xtimesbigger, xtimeslonger);
    rgbDetector(image, 'blue', 'HSV', [], xtimesbigger, xtimeslonger)]; 
end

function boundingBoxes = rgbDetector(image, color, colorspace, thresholds, xtimesbigger, xtimeslonger)
    
    % RGB split
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);

    % Color-based segmentation
    if colorspace == 'HSV'
        switch(color)
            case 'red'
                seg = redHSV(image);
            case 'blue'
                seg = blueHSV(image);
        end
    elseif colorspace == 'RGB'
        switch(color)
            case 'red'
                seg = r > thresholds(1) & ...
                r./(r+g+b) > thresholds(2) & ...
                g./(r+g+b) < thresholds(3) & ...
                b./(r+g+b) < thresholds(3);
            case 'blue'
                seg = b > thresholds(1) & ...
                b./(r+g+b) > thresholds(2) & ...
                g./(r+g+b) < thresholds(3) & ...
                r./(r+g+b) < thresholds(3);
        end
    end

    % Morphological erosion
    se = strel('square',3);
    morph = imclose(seg,se);

    % Boundary following
    B = bwboundaries(morph, 8, 'noholes'); % Extract boundaries of white blobs
    maximum = max(cellfun(@length,B)); % Find length of longest contour

    % Remove short contour objects
    removeThese = cellfun(@numel,B)/2 < maximum/xtimesbigger;

    % Compute surrounging bounding boxes
    CC = bwconncomp(morph);
    stats = regionprops(CC, 'BoundingBox');
    stats(removeThese) = [];

    boundingBoxes = [];
    % Ignore bbox if one side is 'x' times longer than another
    for i = 1:length(stats)
        if stats(i).BoundingBox(3) < xtimeslonger*stats(i).BoundingBox(4) && ...
            stats(i).BoundingBox(4) < xtimeslonger*stats(i).BoundingBox(3)
            boundingBoxes = [boundingBoxes; stats(i).BoundingBox];
        end
    end
    
end

function BW = redHSV(RGB)

I = rgb2hsv(RGB);

channel1Min = 0.921;
channel1Max = 0.027;

channel2Min = 0.239;
channel2Max = 1.000;

channel3Min = 0.359;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

end

function BW = blueHSV(RGB)

I = rgb2hsv(RGB);

channel1Min = 0.470;
channel1Max = 0.740;

channel2Min = 0.475;
channel2Max = 1.000;

channel3Min = 0.208;
channel3Max = 0.980;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

end
