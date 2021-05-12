%% The function receives a distance matrix d and a threshold
%% Returns the false acceptance rate and the false rejection rate by 
%% calculating the true positive, true negative, false positive and false
%% negative.

%%
function [FAR,FRR] = calc_FAR_FRR (d, threshold)
    TP = 0;
    TN = 0;
    FP = 0;
    FN = 0;
    for i = 1:size(d,1)
        if(d(i,i)<threshold)
          TP = TP + 1;
        else
          FN = FN + 1;
        end
        
        for j = 1:size(d,1)
            if (j ~= i)
                if(d(i,j)<threshold)
                  FP = FP + 1;
                else
                  TN = TN + 1;
                end
            end
        end
    end  
    FRR = FN/(FN+TP);
    FAR = FP/(FP+TN);   

end