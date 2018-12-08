function [ oct ] = findOCT( task )
%FINDRANK Summary of this function goes here
%   Detailed explanation goes here

procDetails = dlmread('proc_det.txt','-');
octMatrix  = dlmread('octMat.txt','-');

%prceeding task
P = task(1,1);

%suceeding task
S = task(1,2);

%communication cost
C = task(1,3);

%task order
T = task(1,4);


if(T==0)
    oct = [P,0,0,0];
else
    
    %display(S);
    succprocDetails = procDetails(S,:);
    indx = octMatrix(:,1) == S;
    succOCTDetails = octMatrix(indx,:);
    succOCTDetails = succOCTDetails(1,:);
    
    %display(succOCTDetails);
    %display(succprocDetails);
    
    %for p1
     val_p1_p1 = succOCTDetails(1,2)+succprocDetails(1,2)+0;
     val_p1_p2 = succOCTDetails(1,3)+succprocDetails(1,3)+C;
     val_p1_p3 = succOCTDetails(1,4)+succprocDetails(1,4)+C;
     
     %for p2
     val_p2_p1 = succOCTDetails(1,2)+succprocDetails(1,2)+C;
     val_p2_p2 = succOCTDetails(1,3)+succprocDetails(1,3)+0;
     val_p2_p3 = succOCTDetails(1,4)+succprocDetails(1,4)+C;
     
     %for p3
     val_p3_p1 = succOCTDetails(1,2)+succprocDetails(1,2)+C;
     val_p3_p2 = succOCTDetails(1,3)+succprocDetails(1,3)+C;
     val_p3_p3 = succOCTDetails(1,4)+succprocDetails(1,4)+0;
     
     min_p1 = min(val_p1_p3,min(val_p1_p1,val_p1_p2));
     min_p2 = min(val_p2_p1,min(val_p2_p2,val_p2_p3));
     min_p3 = min(val_p3_p1,min(val_p3_p2,val_p3_p3));
    
    oct = [P,min_p1,min_p2,min_p3];
end

end

