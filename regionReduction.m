function reducedBoundingBoxes = regionReduction(boundingBoxes)

global lowerBound upperBound IoU

% Ban small regions
keep = removeSmallPerimeters(boundingBoxes);
reducedBoundingBoxes = boundingBoxes(keep,:);

% Ban overlapping regions
keep = removeOverlappedRegions(reducedBoundingBoxes, lowerBound, upperBound, IoU);
reducedBoundingBoxes = reducedBoundingBoxes(keep,:);

end

function keep = removeSmallPerimeters(boundingBoxes)

% Ban small perimeter regions

remove = [];

perimeters = 2*(boundingBoxes(:,3) + boundingBoxes(:,4));
max_perimeter = max(perimeters);

sizeX = size(boundingBoxes,1);

for i = 1:sizeX
    if perimeters(i) < max_perimeter/20
        remove = [remove i];
    end
end

keep = 1:sizeX;
keep(unique(remove)) = [];

end