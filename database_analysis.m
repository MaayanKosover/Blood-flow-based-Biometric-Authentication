%% The function receives 2 start points which point to the required segments
%% and the number of PCA eigenvectors to use.
%% Calculates EER based on a normalized distance matrix between the PCA 
%% and DCT coefficients of the 2 signals.
%% Returns the DCT and PCA coefficients of the cycles specified by the start
%% points.

function [PCA_output,DCT_DB_first_1, test_DB_first_1] = database_analysis(sig1_start,sig2_start, numOfVectors)
    %% build database out of 42 signals
    myDir = '..\TBME2013-PPGRR-Benchmark_R3\data'; 
    myFiles = dir(fullfile(myDir,'*.mat')); 
    numOfSubjects = length(myFiles);
    ppg = zeros(numOfSubjects,8*60*300+1);
    for k = 1:numOfSubjects 
      baseFileName = myFiles(k).name;
      fullFileName = fullfile(myDir, baseFileName);
      signal = load(fullFileName,'signal');
      ppg(k,:) = signal.signal.pleth.y;
    end

    %% segmentation
    ppg_cut = zeros(numOfSubjects,6000);
    test = zeros(numOfSubjects,6000);
    for i = 1:numOfSubjects
        ppg_cut(i,:) = ppg(i,(sig1_start:sig1_start+5999));        
        test(i,:) = ppg(i,(sig2_start:sig2_start+5999));
    end
    
    %% Get filtered PPG
    Fs = 300; %[Hz]    
    filter_order = 3; %filter specs
    low_freq = 0.5;
    high_freq = 5;
    [b,a] = butter(filter_order, [low_freq high_freq]/(Fs/2));
    
    filtered_ppg = zeros(numOfSubjects,6000);
    filtered_ppg_test = zeros(numOfSubjects,6000);
    for i = 1:numOfSubjects
        filtered_ppg(i,:) = filter(b,a,ppg_cut(i,:));
        filtered_ppg_test(i,:) = filter(b,a,test(i,:));
    end
    
    %% find first derivative of filtered PPG
    
    first_filtered_ppg = zeros(numOfSubjects,5999);
    first_filtered_ppg_test = zeros(numOfSubjects,5999);
    
    for i=1:numOfSubjects
        first_filtered_ppg(i,:) = diff(filtered_ppg(i,:));
        first_filtered_ppg_test(i,:) = diff(filtered_ppg_test(i,:));
    end
    
    %% Get one cycle from each signal
    fixed_len = 180;
    first_der_1_cycles = zeros(numOfSubjects,fixed_len+1);
    first_der_test_1_cycles = zeros(numOfSubjects,fixed_len+1);
    
    for i = 1:numOfSubjects
        first_der_1_cycles(i,:) = split_der(first_filtered_ppg(i,:),fixed_len);
        first_der_test_1_cycles(i,:) = split_der(first_filtered_ppg_test(i,:),fixed_len);
    end       
    
    %% DCT
    %% Get DCT coefficients 
    [DCT_DB_first_1,test_DB_first_1] = get_DCT_from_PPG_der(first_der_1_cycles,first_der_test_1_cycles,0);    
    
    %% Normalize DCTs
    DCT_DB_first_1_std = normalize(DCT_DB_first_1,2,'scale');
    test_DB_first_1_std = normalize(test_DB_first_1,2,'scale');
    
    %% find dist matrix for normalized DCTs
    numOfSubject = 42;
    C = size(DCT_DB_first_1_std,2);
    d_DCT_first_1 = zeros(numOfSubject);  
    for i = 1:numOfSubject 
        for j = 1:numOfSubject            
            d_DCT_first_1(i,j) = norm(test_DB_first_1_std(i,:)-DCT_DB_first_1_std(j,:))/C;
        end
    end   
    
    %% PCA
    %% get eigenvectors for cycled signals
    eigVecotrs_first_der_1 = get_Eig(first_der_1_cycles);
    
    %% Multilpy eigenVectors with signals   
    first_der_1_cycles_mul = eigVecotrs_first_der_1(:,1:numOfVectors)'*first_der_1_cycles';
    first_der_test_1_cycles_mul = eigVecotrs_first_der_1(:,1:numOfVectors)'*first_der_test_1_cycles'; 
    
    %% Normalize PCAs
    first_der_1_cycles_mul_std = normalize(first_der_1_cycles_mul,2,'scale');
    first_der_test_1_cycles_mul_std = normalize(first_der_test_1_cycles_mul,2,'scale');
    
    %% find dist matrix for normalized PCAs  
    numOfSubject = 42;
    d_PCA_first_1 = zeros(numOfSubject);  
    for i = 1:numOfSubject 
        for j = 1:numOfSubject            
            d_PCA_first_1(i,j) = norm(first_der_test_1_cycles_mul_std(:,i)-first_der_1_cycles_mul_std(:,j))/numOfVectors;
        end
    end
    
    %% Get average dist martices, find min
    d_first_1 = zeros(numOfSubject);  
    for i = 1:numOfSubject 
        for j = 1:numOfSubject            
            d_first_1(i,j) = (d_PCA_first_1(i,j) + d_DCT_first_1(i,j))/2;
        end
    end    

    Min_d_first_1 = zeros(1,numOfSubject);
    Min_i_first_1 = zeros(1,numOfSubject);
    for i = 1:numOfSubject
        [Min_d_first_1(i),Min_i_first_1(i)] = min(d_first_1(i,:));
    end 
    
    %% count successful matches for dist
    counter_d_first_1 = 0 ;
    for i = 1:numOfSubject
        if (Min_i_first_1(i) == i)
            counter_d_first_1 = counter_d_first_1 + 1;
        end
    end
    
    %% calc EER
    [EER_first_1,~,~] = calc_EER(d_first_1);
    
    %% Arrange output
    PCA_output = zeros(2,numOfVectors,numOfSubjects);
    PCA_output(1,:,:) = first_der_1_cycles_mul_std;
    PCA_output(2,:,:) = first_der_test_1_cycles_mul_std;
   
end
