%% The function receives a distance matrix d
%% Calculates the false acceptance rate and the false rejection rate.
%% Returns the EER

%%
function [EER,FAR_vec,FRR_vec] = calc_EER (d)

    M = max(d, [], 'all');
    m = min(d, [], 'all');    
    i=1;
    FAR_vec = zeros(1,100);
    FRR_vec = zeros(1,100);
    for threshold = linspace(m,M)
       [FAR_vec(i), FRR_vec(i)] = calc_FAR_FRR (d, threshold);
       i = i+1;
    end
    
    EER_vec = zeros(1,size(FAR_vec,2));
    for i = 1:size(FAR_vec,2)
        EER_vec(i) = abs(FAR_vec(i)-FRR_vec(i));
    end
    [~, EER_index] = min(EER_vec);
    EER = (FAR_vec(EER_index)+FRR_vec(EER_index))/2;
    
end