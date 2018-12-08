function [ dlmout ] = findMax( dlmout,numTasks )
%FINDMAX Summary of this function goes here
%   Detailed explanation goes here


for i = 1:numTasks
    
    indx = dlmout(:,1) == i;
    tempMat = dlmout(indx,:);
    tempMat = max(tempMat);
    
    
    [p,q] = size(dlmout);
   
    for j = 1:p
        if(dlmout(j,1)==i)
            [x,y] = size(tempMat);
            %dlmout(j,:) %= tempMat
            if(y==4)
             dlmout(j,:) = tempMat;
            end
        end
        
    end
    
    
end


end

