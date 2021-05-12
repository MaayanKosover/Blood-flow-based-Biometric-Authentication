%% The function extracts the red channel from a given video and returns the
%% mean of each frame.

function [ppg_raw,numberOfFrames]  = video_to_rgb(video)
    k=1;

    numberOfFrames = int16(fix(video.FrameRate*video.Duration));   
    ppg_raw = zeros(1,numberOfFrames);
    while hasFrame(video)
        img = readFrame(video);
        M = img(:,:,1);        
        ppg_raw(k) = mean2(M(M >= 0));        
        k = k+1;
    end   
end


