%% The function converts videos to PPG signals.

function [ppg_cut, numberOfFrames] = read_videos()

    %% read videos
    %% read video 1
    video = VideoReader('..\Videos\maayan1.mp4');
    [ppg1,numberOfFrames(1)] = video_to_rgb(video);

    %% read video 2
    video = VideoReader('..\Videos\gal1.mp4');
    [ppg2,numberOfFrames(2)] = video_to_rgb(video);

    %% read video 3
    video = VideoReader('..\Videos\adi1.mp4');
    [ppg3,numberOfFrames(3)] = video_to_rgb(video);

    %% read video 4
    video = VideoReader('..\Videos\doron2.mp4');
    [ppg4,numberOfFrames(4)] = video_to_rgb(video);

    %% read video 5
    video = VideoReader('..\Videos\nir.mp4');
    [ppg5,numberOfFrames(5)] = video_to_rgb(video);

    %% read video 6
    video = VideoReader('..\Videos\rachel2.mp4');
    [ppg6,numberOfFrames(6)] = video_to_rgb(video);

    %% read video 7
    video = VideoReader('..\Videos\ariel2.mp4');
    [ppg7,numberOfFrames(7)] = video_to_rgb(video);

    %% cut vidoes
    numOfSubjects = 7;
    len = 1401;
    ppg_cut = zeros(numOfSubjects,len);

    ppg_cut(1,:) = -ppg1(1500:2900);
    ppg_cut(2,:) = -ppg2(1000:2400);
    ppg_cut(3,:) = -ppg3(2500:3900);
    ppg_cut(4,:) = -ppg4(1700:3100);
    ppg_cut(5,:) = -ppg5(2600:4000);
    ppg_cut(6,:) = -ppg6(2000:3400);
    ppg_cut(7,:) = -ppg7(1360:2760);
    