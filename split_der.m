%% The function receives signal and len
%% Returns len sized cycles with a peak in the middle

%%
function cycle  = split_der(signal, len)    
    %% Find peaks          
    [pks,locs] = findpeaks(signal,'MinPeakDistance', 130);
    
    %% Get cycles, fixed length
    mid = round(size(locs,2)/2);
    half = round(len/2);
    cycle = signal(locs(mid)-half:locs(mid)+half);
    