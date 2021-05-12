%% The function aligns the signals until it reaches the minimal norm between 
%% all the signals.

%% 
function aligned = align_signal(signal)
    aligned = signal;
    len1 = size(signal,1);
    len2 = size(signal,2);    
    lags = zeros(1,len1);
    for i = 2:len1
        sum_of_dists = zeros(1,len2);
        for lag = 0:(len2-1)
            tmp = circshift(signal(i,:),lag);
            for j = 1:(i-1)
                sum_of_dists(lag+1) =  sum_of_dists(lag+1) + norm(aligned(j,:)-tmp);
            end
        end
        [~,lags(i)] = min(sum_of_dists);
        aligned(i,:) = circshift(aligned(i,:),lags(i)); 
    end       
end