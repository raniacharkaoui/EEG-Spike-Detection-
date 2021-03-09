function [ DeuzDet ] = AddAndSortDetect(DeuzDetCluster,EcartMax,timeIn)

for k=1:length(timeIn)
    AddDet = [];
    for CurrentCluster = 1:length(DeuzDetCluster)
        if (~isempty(DeuzDetCluster(CurrentCluster).Det)) && (~isempty(DeuzDetCluster(CurrentCluster).Det.Epoch(k).DetectedTime))
            AddDet = [AddDet' DeuzDetCluster(CurrentCluster).Det.Epoch(k).DetectedTime']';
        end
    end
    if isempty(AddDet)
        DeuzDet(k).Det = [];
    else
        SortDet = sortrows(AddDet,1);
        i = 1;
        while i < length(SortDet(:,1))
            if SortDet(i+1,1)-SortDet(i,1)<EcartMax
                SortDet(i,1) = min([SortDet(i,1) SortDet(i+1,1)]);
                SortDet(i,2) = max([SortDet(i,2) SortDet(i+1,2)]);
                SortDet(i+1,:) = [];
            else
                i=i+1;
            end
        end
        DeuzDet(k).Det = SortDet;
    end
end
    
