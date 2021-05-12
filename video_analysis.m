%% The function receives ppg signals and an array of peaks.
%% Returns the DCT and PCA coefficients of the cycles specified by peaks.

function [DCT_DB_first_1, first_1_cycles_mul_std] = video_analysis(peaks, numOfSubjects, numOfVectors, ppg_cut)

    numOfSegments = 6;
    %% Filter PPG - smooth 
    ppg_cut_filtered = filterPPG(ppg_cut);

    %% Find first derivative of filtered PPG
    len = size(ppg_cut_filtered,2);
    first_ppg = zeros(numOfSubjects,len-1);
    for i=1:numOfSubjects
        first_ppg(i,:) = diff(ppg_cut_filtered(i,:));      
    end
    
    %% Find Peaks
    locsFirst = zeros(numOfSubjects,round(len/20));
    for i=1:numOfSubjects
        [~,tmp] = findpeaks(first_ppg(i,:),'MinPeakDistance', 20);
        locsFirst(i,1:length(tmp)) = tmp;
    end    
%     locsFirst(:,1) = [];
%     locsFirst(:,end) = [];
    
    %% Get one cycle from each signal
    fixed_len = 20;
    half = round(fixed_len/2);
    first_1_cycles = zeros(numOfSegments,numOfSubjects,fixed_len+1);

    for i = 1:numOfSegments
        for j = 1:numOfSubjects
            first_1_cycles(i,j,:) = first_ppg(j,locsFirst(j,peaks(i))-half:locsFirst(j,peaks(i))+half);
        end
    end

    %%  Align signals
    first_1_cycles_aligned = zeros(size(first_1_cycles));
    for i = 1:numOfSegments
        first_1_cycles_aligned(i,:,:) = align_signal(first_1_cycles(i,:,:));
    end

    %% Get DCT coefficients
    for i = 1:numOfSegments
        sz = size(first_1_cycles_aligned);
        tmp = reshape(first_1_cycles_aligned(i,:,:),sz(2:3));
        [DCT_DB_first_1(i,:,:), ~] = get_DCT_from_PPG_der(tmp,tmp,1);
    end
    
    %% Get PCA coefficients
    
    sz = size(first_1_cycles_aligned);
    % combine 4 signals to 1 train matrix
    train = [reshape(first_1_cycles_aligned(1,:,:),sz(2:3)); reshape(first_1_cycles_aligned(2,:,:),sz(2:3)); 
            reshape(first_1_cycles_aligned(3,:,:),sz(2:3)); reshape(first_1_cycles_aligned(4,:,:),sz(2:3));]; 
     
    % Get Eigen vectors  
    eigVectors_first_1 = get_Eig(train);
    
    % Multiply train and test by the *train* EV
    len = size(eigVectors_first_1,2);    
    first_1_cycles_mul = zeros(numOfSegments,numOfVectors,numOfSubjects);    
    for i = 1:numOfSegments
        first_1_cycles_mul(i,:,:) = eigVectors_first_1(:,1:numOfVectors)'*reshape(first_1_cycles_aligned(i,:,:),numOfSubjects,len)';
    end
    
    % Normalize
    first_1_cycles_mul_std = zeros(size(first_1_cycles_mul));
    for i = 1:numOfSegments
        first_1_cycles_mul_std(i,:,:) = normalize(first_1_cycles_mul(i,:,:),2,'scale');
    end
    
end