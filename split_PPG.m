function cycle  = split_PPG(signal, len)    
    %% Find peaks
    [pks,locs] = findpeaks(signal,'MinPeakDistance', 100);
    
    %% Get cycles, fixed length
    mid = round(size(locs,2)/2);
    half = round(len/2);
    cycle = signal(locs(mid)-half:locs(mid)+half);
 