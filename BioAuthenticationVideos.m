%% This script performs the authentication algorithm on 7 pre-recorded  
%% videos. The script extracts ppg signals from those videos.
%% 6 segments are extracted from each video. 4 segments will be used to train 
%% the SVM model and 2 segments will be used to test the SVM model.
%% DCT and PCA coefficients are calculated from all segments.
%% The script makes 3 tables:
%%     1. The success rate of the classification based on DCT.
%%     2. The success rate of the classification based on PCA.
%%     3. The success rate of the classification based on both DCT and PCA.

%% read videos (Videos are too big for git, so instead we load .mat file
%[ppg_tot,~] = read_videos();
PPG_videos = load('PPG_videos.mat');
ppg_tot = PPG_videos.ppg_tot;

%% Get DCTs from Videos
numOfSubjects = 7;
numOfVectors = 20;  % num of eigenVectors used from PCA
peaks = [7,30,22,25,43,18]; % peaks to use for classification
[DCT_first,PCA] = video_analysis(peaks,numOfSubjects,numOfVectors,ppg_tot);

%% DCT VIDEO
    counter_DCT_video = [];
    values = [];
    for numOfDCTcoeff = [1,2,3,4,5,7,9,11,15]
       counter_DCT_video = [counter_DCT_video; score_video_DCT(DCT_first,numOfDCTcoeff).'];
       values = [values; numOfSubjects numOfDCTcoeff];
    end
    
    counter_DCT_video = [values counter_DCT_video];
    header = {'number of subjects', 'number of DCT coefficients', 'test 1(%)','test 2(%)','average(%)'};
    counter_DCT_header = [header;num2cell(counter_DCT_video)];
    DCT_table = table(counter_DCT_header);
  
%% PCA VIDEO
    counter_PCA_video = [];
    values = [];
    for numOfPCAcoeff = (2:15)
           counter_PCA_video= [counter_PCA_video; score_video_PCA(PCA,numOfPCAcoeff).'];
           values = [values; numOfSubjects numOfPCAcoeff];
    end
    counter_PCA_video = [values counter_PCA_video];
    header = {'number of subjects', 'number of PCA coefficients', 'test 1(%)','test 2(%)','average(%)'};
    counter_PCA_header = [header;num2cell(counter_PCA_video)];
    PCA_table = table(counter_PCA_header);
    
%% PCA+DCT VIDEO
    counter_PCADCT_video = [];
    values = [];
    for numOfPCAcoeff = (3:9)
        for numOfDCTcoeff = [1,2,3,4,5,7,9]
               counter_PCADCT_video = [counter_PCADCT_video; score_video_PCADCT(PCA,DCT_first,numOfPCAcoeff,numOfDCTcoeff).'];
               values = [values; numOfSubjects numOfPCAcoeff numOfDCTcoeff];
        end
    end
    counter_PCADCT_video = [values counter_PCADCT_video];
    
    header = {'number of subjects', 'number of PCA coefficients', 'number of DCT coefficients', 'test 1(%)','test 2(%)','average(%)'};
    counter_PCADCT_header = [header;num2cell(counter_PCADCT_video)];
    PCADCT_table = table(counter_PCADCT_header);