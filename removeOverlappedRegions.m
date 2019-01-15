function keep = removeOverlappedRegions(boundingBoxes, lowerBound, upperBound, IoU)

% Overlapping regions simplification algorithm

remove = [];

sizeX = size(boundingBoxes,1);

for i = 1:sizeX
    area_i = boundingBoxes(i,3)*boundingBoxes(i,4);
    for j = i+1:sizeX
        
        area_j = boundingBoxes(j,3)*boundingBoxes(j,4);
        
        min_area = min(area_i, area_j);
        max_area = max(area_i, area_j);
        
        if min_area == area_i
            ban_ind = i;
        else
            ban_ind = j;
        end
        
        overlapRatio = bboxOverlapRatio(boundingBoxes(i,:), boundingBoxes(j,:), 'ratioType', 'Min');
        
        % Ban overlap regions
        if lowerBound <= overlapRatio && overlapRatio <= upperBound
            if min_area <= max_area
                remove = [remove ban_ind];
            end
        end     
       
        % Ban regions which are completely inside another region if their areas are close
        if overlapRatio == 1
            if bboxOverlapRatio(boundingBoxes(i,:),boundingBoxes(j,:)) > IoU
                if min_area <= max_area
                    remove = [remove ban_ind];
                end
            end
        end
        
    end
end

keep = 1:sizeX;
keep(unique(remove)) = [];

end