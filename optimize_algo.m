clear
clc

taskDetails = dlmread('task_det.txt','-');
processDetails = dlmread('proc_det.txt','-');

numTasks = 10;

[p,q] = size(taskDetails);

dlmout(1,:) = [0,0,0,0];
dlmwrite('octMat.txt',dlmout,'-');

% Finding OCT MATRIX
for i=p:-1:1
    
    oct = findOCT(taskDetails(i,:));
    %display(oct);
    dlmout(i,:) = oct;
    dlmout = findMax(dlmout,numTasks);
    dlmwrite('octMat.txt',dlmout,'-');
    
end

dlmout = unique(dlmout,'rows');
dlmout(:,5) = transpose(mean(transpose(dlmout(:,2:4))));

% Rank Graph
stem(dlmout(:,1),dlmout(:,5))
xlabel('Tasks')
ylabel('Rank')
dlmwrite('octMat.txt',dlmout,'-');



% Allocating Task
[values, order] = sort(dlmout(:,5),'descend');
sortDlmout = dlmout(order,:);

%EST VALS
EFT_p1 = 0;
EFT_p2 = 0;
EFT_p3 = 0;

OEFT_p1 = 0;
OEFT_p2 = 0;
OEFT_p3 = 0;

allocDetails = [0,0,0];

for i=1:numTasks
    
    task = sortDlmout(i,:);
    
    indx = processDetails(:,1) == sortDlmout(i,1);
    values = processDetails(indx,2:4);
    
    if(task(1,1)==1)
        temp_EFT_p1 = values(1,1);
        temp_EFT_p2 = values(1,2);
        temp_EFT_p3 = values(1,3);
        
        OEFT_p1 = values(1,1)+task(1,2);
        OEFT_p2 = values(1,2)+task(1,3);
        OEFT_p3 = values(1,3)+task(1,4);
    else
        
        %Current Task
        current_task = task(1,1);
        
        %finding preceeding task
        preceeding_task_indx = find(taskDetails(:,2)==current_task);
        preceeding_task = taskDetails(preceeding_task_indx,1);
        preceeding_task_temp_comm_cost = taskDetails(preceeding_task_indx,3);
        
        %find max preceeding rft val
        [m,n] = size(preceeding_task);
        
        test_mat = preceeding_task;
        test_mat(:,2) = preceeding_task_indx;
        
        
        if(m>1)
            t = 0; c=0;
            for j=1:m
                max_eft_task_indx = find(allocDetails(:,1)== preceeding_task(j,1));
                max_eft_task = allocDetails(max_eft_task_indx,:);
                
                
                
                if(~isempty(max_eft_task))
                    if(max_eft_task(1,3)>c)
                        c=max_eft_task(1,3);
                        t=max_eft_task(1,1);
                        
                    end
                end
                
                
            end
            
           preceeding_task = t;
           preceeding_task_indx=test_mat(find(test_mat(:,1)==t),2);
           
           %preceeding_task_indx = find(taskDetails(:,1:2))
           
           %preceeding_task_indx = find(taskDetails(:,2)== current_task && taskDetails(:,1)==t)
           
        end
        
        preceeding_task_commcost = taskDetails(preceeding_task_indx,3);
        preceeding_task_process_indx = find(allocDetails(:,1)==preceeding_task);
        preceeding_task_process = allocDetails(preceeding_task_process_indx,2);
        preceeding_task_process_eft = allocDetails(preceeding_task_process_indx,3);
        
        if(preceeding_task_process == 1)
            
            temp_EFT_p1 = preceeding_task_process_eft+values(1,1);
            temp_EFT_p2 = preceeding_task_process_eft+values(1,2)+preceeding_task_commcost;
            temp_EFT_p3 = preceeding_task_process_eft+values(1,3)+preceeding_task_commcost;
            
            if(EFT_p1>preceeding_task_process_eft)
                temp_EFT_p1 = EFT_p1+values(1,1);
            end
            if(EFT_p2>preceeding_task_process_eft)
                temp_EFT_p2 = EFT_p2+values(1,2);
                if(preceeding_task_commcost > preceeding_task_process_eft)
                    temp_EFT_p2 = temp_EFT_p2-EFT_p2+preceeding_task_commcost+preceeding_task_process_eft;
                end
            end
            if(EFT_p3>preceeding_task_process_eft)
                temp_EFT_p3 = EFT_p3+values(1,3);
            end
            
            if(EFT_p1>EFT_p2 && i==10)
               temp_EFT_p1 = EFT_p1+preceeding_task_commcost*4;
            end
            
            fprintf('EFT_1 = %d, EFT_2 = %d, EFT3 = %d \n',temp_EFT_p1,temp_EFT_p2,temp_EFT_p3)
            
            OEFT_p1 = temp_EFT_p1+task(1,2);
            OEFT_p2 = temp_EFT_p2+task(1,3);
            OEFT_p3 = temp_EFT_p3+task(1,4);
            
        elseif(preceeding_task_process == 2)
            temp_EFT_p1 = preceeding_task_process_eft+values(1,1)+preceeding_task_commcost;
            temp_EFT_p2 = preceeding_task_process_eft+values(1,2);
            temp_EFT_p3 = preceeding_task_process_eft+values(1,3)+preceeding_task_commcost;
            
            if(EFT_p1>preceeding_task_process_eft)
               temp_EFT_p1 = EFT_p1+values(1,1);
            end
            if(EFT_p2>preceeding_task_process_eft)
                temp_EFT_p2 = EFT_p2+values(1,2);
            end
            if(EFT_p3>preceeding_task_process_eft)
                temp_EFT_p3 = EFT_p3+values(1,3);
            end
            
            fprintf('EFT_1 = %d, EFT_2 = %d, EFT3 = %d \n',temp_EFT_p1,temp_EFT_p2,temp_EFT_p3)
            
            OEFT_p1 = temp_EFT_p1+task(1,2);
            OEFT_p2 = temp_EFT_p2+task(1,3);
            OEFT_p3 = temp_EFT_p3+task(1,4);
        elseif(preceeding_task_process == 3)
            
            
            temp_EFT_p1 = preceeding_task_process_eft+values(1,1)+preceeding_task_commcost;
            temp_EFT_p2 = preceeding_task_process_eft+values(1,2)+preceeding_task_commcost;
            temp_EFT_p3 = preceeding_task_process_eft+values(1,3);
            
            
            if(EFT_p1>preceeding_task_process_eft)
               temp_EFT_p1 = EFT_p1+values(1,1);
                if(preceeding_task_commcost > EFT_p1-preceeding_task_process_eft)
                    temp_EFT_p1 = temp_EFT_p1-EFT_p1+preceeding_task_commcost+preceeding_task_process_eft;
                end
            end
            if(EFT_p2>preceeding_task_process_eft)
                temp_EFT_p2 = EFT_p2+values(1,2);
                if(preceeding_task_commcost > EFT_p2-preceeding_task_process_eft)
                    temp_EFT_p2 = temp_EFT_p2-EFT_p2+preceeding_task_commcost+preceeding_task_process_eft;
                end
            end
            if(EFT_p3>preceeding_task_process_eft)
                temp_EFT_p3 = EFT_p3+values(1,3);
            end
            
            fprintf('EFT_1 = %d, EFT_2 = %d, EFT3 = %d \n',temp_EFT_p1,temp_EFT_p2,temp_EFT_p3)
            
            OEFT_p1 = temp_EFT_p1+task(1,2);
            OEFT_p2 = temp_EFT_p2+task(1,3);
            OEFT_p3 = temp_EFT_p3+task(1,4);
            
        end
        
        
    end
    
    [best amount]=knapsack([OEFT_p1,OEFT_p2,OEFT_p3],[temp_EFT_p1,temp_EFT_p2,temp_EFT_p3],min([OEFT_p1,OEFT_p2,OEFT_p3]));
    
    indc = find(amount == 1);
    
    if(indc(:,1)==1)
        EFT_p1 = temp_EFT_p1;
        allocDetails(i,:) = [task(1,1),1,EFT_p1];
        fprintf('Task %d allocated to processor 1 with EFT = %d \n',task(1,1),temp_EFT_p1);
    elseif(indc(:,1)==2)
        EFT_p2 = temp_EFT_p2;
        allocDetails(i,:) = [task(1,1),2,EFT_p2];
        fprintf('Task %d allocated to processor 2 with EFT = %d \n',task(1,1),temp_EFT_p2);
    elseif(indc(:,1)==3)
        EFT_p3 = temp_EFT_p3;
        allocDetails(i,:) = [task(1,1),3,EFT_p3];
        fprintf('Task %d allocated to processor 3 with EFT = %d  \n',task(1,1),temp_EFT_p3);
    end
    
    
    
end