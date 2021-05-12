%% The function receives DCT coefficients for all the signals and the number
%% of required DCT coefficients.
%% Splits the DCT coefficients to a train set of 4 and a test set of 2.
%% Builds and trains an SVM model.
%% Returns a vector containing the success rate of each of the 2 tests.

%%
function counter_s = scoreDCT(DCT_output,numOfSubjects, numOfDCTcoeff)
%% DCT - 2 Tests
   
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

    % build the train set
    numOfTests = 2;
    X = [];
    for i=(1:numOfSubjects)
    X = [X;DCT1_1_cut(i,:);DCT5_1_cut(i,:);DCT7_1_cut(i,:);
        DCT10_1_cut(i,:)];        
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
    for i=(1:numOfSubjects) % build test set (size numOfTests)
        test = [test;DCT12_1_cut(i,:); DCT16_1_cut(i,:)];       
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

    % classify test cases   
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
    counter_s = zeros(numOfTests+1,1);   
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