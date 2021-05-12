%% The function receives PCA and DCT coefficients for all the signals and
%% the number of required PCA and DCT coefficients.
%% Builds a set made out of the PCA and DCT coefficients.
%% Splits the coefficients to a train set of 4 and a test set of 2.
%% Builds and trains an SVM model.
%% Returns a vector containing the success rate of each of the 2 tests.

%%
function counter_s = scorePCADCT(output,DCT_output,numOfSubjects,numOfPCAcoeff, numOfDCTcoeff)
%% PCA+DCT - 2 Tests
   output1 = reshape(output(1,:,:,:),2,8,42);
   output2 = reshape(output(2,:,:,:),2,8,42);
   output3 = reshape(output(3,:,:,:),2,8,42);
   output4 = reshape(output(4,:,:,:),2,8,42);
   output5 = reshape(output(5,:,:,:),2,8,42);
   output6 = reshape(output(6,:,:,:),2,8,42);
   output7 = reshape(output(7,:,:,:),2,8,42);
   output8 = reshape(output(8,:,:,:),2,8,42);
   output9 = reshape(output(9,:,:,:),2,8,42);
   output10 = reshape(output(10,:,:,:),2,8,42);
   
   DCT1_1 = reshape(DCT_output(1,:,:),42,40);
   DCT2_1 = reshape(DCT_output(2,:,:),42,40);
   DCT3_1 = reshape(DCT_output(3,:,:),42,40);
   DCT4_1 = reshape(DCT_output(4,:,:),42,40);
   DCT5_1 = reshape(DCT_output(5,:,:),42,40);
   DCT6_1 = reshape(DCT_output(6,:,:),42,40);
   DCT7_1 = reshape(DCT_output(7,:,:),42,40);
   DCT8_1 = reshape(DCT_output(8,:,:),42,40);
   DCT9_1 = reshape(DCT_output(9,:,:),42,40);
   DCT10_1 = reshape(DCT_output(10,:,:),42,40);
   DCT11_1 = reshape(DCT_output(11,:,:),42,40);
   DCT12_1 = reshape(DCT_output(12,:,:),42,40);
   DCT13_1 = reshape(DCT_output(13,:,:),42,40);
   DCT14_1 = reshape(DCT_output(14,:,:),42,40);
   DCT15_1 = reshape(DCT_output(15,:,:),42,40);
   DCT16_1 = reshape(DCT_output(16,:,:),42,40);
   DCT17_1 = reshape(DCT_output(17,:,:),42,40);
   DCT18_1 = reshape(DCT_output(18,:,:),42,40);
   DCT19_1 = reshape(DCT_output(19,:,:),42,40);
   DCT20_1 = reshape(DCT_output(20,:,:),42,40);
   
   siz = [numOfPCAcoeff, 42];
   ECG1_1 = reshape(output1(1,1:numOfPCAcoeff,:),siz);
   ECG2_1 = reshape(output1(2,1:numOfPCAcoeff,:),siz);
   ECG3_1 = reshape(output2(1,1:numOfPCAcoeff,:),siz);
   ECG4_1 = reshape(output2(2,1:numOfPCAcoeff,:),siz);
   ECG5_1 = reshape(output3(1,1:numOfPCAcoeff,:),siz);
   ECG6_1 = reshape(output3(2,1:numOfPCAcoeff,:),siz);
   ECG7_1 = reshape(output4(1,1:numOfPCAcoeff,:),siz);
   ECG8_1 = reshape(output4(2,1:numOfPCAcoeff,:),siz);
   ECG9_1 = reshape(output5(1,1:numOfPCAcoeff,:),siz);
   ECG10_1 = reshape(output5(2,1:numOfPCAcoeff,:),siz);
   ECG11_1 = reshape(output6(1,1:numOfPCAcoeff,:),siz);
   ECG12_1 = reshape(output6(2,1:numOfPCAcoeff,:),siz);
   ECG13_1 = reshape(output7(1,1:numOfPCAcoeff,:),siz);
   ECG14_1 = reshape(output7(2,1:numOfPCAcoeff,:),siz);
   ECG15_1 = reshape(output8(1,1:numOfPCAcoeff,:),siz);
   ECG16_1 = reshape(output8(2,1:numOfPCAcoeff,:),siz);
   ECG17_1 = reshape(output9(1,1:numOfPCAcoeff,:),siz);
   ECG18_1 = reshape(output9(2,1:numOfPCAcoeff,:),siz);
   ECG19_1 = reshape(output10(1,1:numOfPCAcoeff,:),siz);
   ECG20_1 = reshape(output10(2,1:numOfPCAcoeff,:),siz);
   
   %C = 10; %DCT Cut-off
   DCT1_1_cut = DCT1_1(:,1:numOfDCTcoeff);
   DCT2_1_cut = DCT2_1(:,1:numOfDCTcoeff);
   DCT3_1_cut = DCT3_1(:,1:numOfDCTcoeff);
   DCT4_1_cut = DCT4_1(:,1:numOfDCTcoeff);
   DCT5_1_cut = DCT5_1(:,1:numOfDCTcoeff);
   DCT6_1_cut = DCT6_1(:,1:numOfDCTcoeff);
   DCT7_1_cut = DCT7_1(:,1:numOfDCTcoeff);
   DCT8_1_cut = DCT8_1(:,1:numOfDCTcoeff);
   DCT9_1_cut = DCT9_1(:,1:numOfDCTcoeff);
   DCT10_1_cut = DCT10_1(:,1:numOfDCTcoeff);
   DCT11_1_cut = DCT11_1(:,1:numOfDCTcoeff);
   DCT12_1_cut = DCT12_1(:,1:numOfDCTcoeff);
   DCT13_1_cut = DCT13_1(:,1:numOfDCTcoeff);
   DCT14_1_cut = DCT14_1(:,1:numOfDCTcoeff);
   DCT15_1_cut = DCT15_1(:,1:numOfDCTcoeff);
   DCT16_1_cut = DCT16_1(:,1:numOfDCTcoeff);
   DCT17_1_cut = DCT17_1(:,1:numOfDCTcoeff);
   DCT18_1_cut = DCT18_1(:,1:numOfDCTcoeff);
   DCT19_1_cut = DCT19_1(:,1:numOfDCTcoeff);
   DCT20_1_cut = DCT20_1(:,1:numOfDCTcoeff);
   
   
   PCADCT1_1 = [ECG1_1.' DCT1_1_cut];
   PCADCT2_1 = [ECG2_1.' DCT2_1_cut];
   PCADCT3_1 = [ECG3_1.' DCT3_1_cut];
   PCADCT4_1 = [ECG4_1.' DCT4_1_cut];
   PCADCT5_1 = [ECG5_1.' DCT5_1_cut];
   PCADCT6_1 = [ECG6_1.' DCT6_1_cut];
   PCADCT7_1 = [ECG7_1.' DCT7_1_cut];
   PCADCT8_1 = [ECG8_1.' DCT8_1_cut];
   PCADCT9_1 = [ECG9_1.' DCT9_1_cut];
   PCADCT10_1 = [ECG10_1.' DCT10_1_cut];
   PCADCT11_1 = [ECG11_1.' DCT11_1_cut];
   PCADCT12_1 = [ECG12_1.' DCT12_1_cut];
   PCADCT13_1 = [ECG13_1.' DCT13_1_cut];
   PCADCT14_1 = [ECG14_1.' DCT14_1_cut];
   PCADCT15_1 = [ECG15_1.' DCT15_1_cut];
   PCADCT16_1 = [ECG16_1.' DCT16_1_cut];
   PCADCT17_1 = [ECG17_1.' DCT17_1_cut];
   PCADCT18_1 = [ECG18_1.' DCT18_1_cut];
   PCADCT19_1 = [ECG19_1.' DCT19_1_cut];
   PCADCT20_1 = [ECG20_1.' DCT20_1_cut];
   
   % build the train set
   numOfTests = 2;
   X = [];
   for i=(1:numOfSubjects)
        X = [X;PCADCT1_1(i,:);PCADCT5_1(i,:);PCADCT7_1(i,:);
            PCADCT10_1(i,:)];        
   end  

    % build the labels for the train set
    y = (1:numOfSubjects);
    Y = [];
    for i=(1:numOfSubjects)
        for j=(1:4)
            Y = [Y;i];
        end
    end
    
    % build the test set
    test = [];
    for i=(1:numOfSubjects)
        test = [test;PCADCT12_1(i,:);PCADCT16_1(i,:)];       
    end       
    
    models = [];
    u=unique(Y);    
    
    %build SVM models
    for k=1:numOfSubjects
        %Vectorized statement that binarizes Group
        %where 1 is the current class and 0 is all other classes
        G1vAll=(Y==u(k));
        models{k} = fitcsvm(X,G1vAll,...
            'Standardize',true,...
            'KernelFunction','rbf');
    end
    
    %classify test cases
    Scores=[];
    maxScore = zeros(numOfSubjects,numOfTests);
    for i=1:numOfTests 
        test_set = [];
        for k=0:numOfSubjects-1            
            test_set = [test_set;test(i+numOfTests*k,:)];
        end
        for j=1:numel(y)
            [~,score]=predict(models{j},test_set);
            Scores(:,j)=score(:,2); % Second column contains positive-class scores
        end 
        % maxScore is the selected label for each test
        [~,maxScore(:,i)]=max(Scores,[],2);
    end 
    maxScore = maxScore.';
    
    % get success rate for each test
    counter_s = zeros(numOfTests,1);   
    for i = 1:size(maxScore,1)
        for j = 1:size(maxScore,2)
            if (maxScore(i,j) == j)
                counter_s(i) = counter_s(i) + 1;
            end             
        end
    end  
    counter_s = 100*round(counter_s/numOfSubjects,3);
    counter_s(numOfTests+1) = sum(counter_s)/numOfTests;
    
end