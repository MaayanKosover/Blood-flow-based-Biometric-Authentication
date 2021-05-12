%% This script performs the authentication algorithm on a database of 42 
%% ppg signals.
%% 6 segments are extracted from each signal. 4 segments will be used to train 
%% the SVM model and 2 segments will be used to test the SVM model.
%% DCT and PCA coefficients are calculated from all segments.
%% The script makes 3 tables:
%%     1. The success rate of the classification based on DCT.
%%     2. The success rate of the classification based on PCA.
%%     3. The success rate of the classification based on both DCT and PCA.


%% Get PCA and DCT coefficients
    numOfVectors = 8;   % num of eigenVectors used from PCA
    [PCA_output,DCT_output] = get_PCA_DCT(numOfVectors);


%% DCT
    counter_DCT = [];
    values = [];
    for numOfSubjects = [5,10,15,25,42]
        for numOfDCTcoeff = [13,15,17,19,21]
               counter_DCT = [counter_DCT; scoreDCT(DCT_output,numOfSubjects,numOfDCTcoeff).'];
               values = [values; numOfSubjects numOfDCTcoeff];
        end
    end
    counter_DCT = [values counter_DCT];
    header = {'number of subjects', 'number of DCT coefficients', 'test 1(%)','test 2(%)','average(%)'};
    counter_DCT_header = [header;num2cell(counter_DCT)];
    DCT_table = table(counter_DCT_header);
    
%% PCA
    counter_PCA = [];
    values = [];
    for numOfSubjects = [5,10,15,25,42]
        for numOfPCAcoeff = (2:6)
               counter_PCA = [counter_PCA; scorePCA(PCA_output,numOfSubjects,numOfPCAcoeff).'];
               values = [values; numOfSubjects numOfPCAcoeff];
        end
    end
    counter_PCA = [values counter_PCA];
    header = {'number of subjects', 'number of PCA coefficients', 'test 1(%)','test 2(%)','average(%)'};
    counter_PCA_header = [header;num2cell(counter_PCA)];
    PCA_table = table(counter_PCA_header);
    
%% PCA+DCT
    counter_PCADCT = [];
    values = [];    
    for numOfSubjects = [5,10,15,25,42]
        for numOfPCAcoeff = (3:5)
            for numOfDCTcoeff = [13,15,17,19,21]
                   counter_PCADCT = [counter_PCADCT; scorePCADCT(PCA_output,DCT_output,numOfSubjects,numOfPCAcoeff,numOfDCTcoeff).'];
                   values = [values; numOfSubjects numOfPCAcoeff numOfDCTcoeff];
            end
        end
    end
    
    counter_PCADCT = [values counter_PCADCT];
    header = {'number of subjects', 'number of PCA coefficients', 'number of DCT coefficients', 'test 1(%)','test 2(%)','average(%)'};
    counter_PCADCT_header = [header;num2cell(counter_PCADCT)];
    PCADCT_table = table(counter_PCADCT_header);


   