%% The function receives DCT coefficients for all the signals and the number
%% of required DCT coefficients.
%% Splits the DCT coefficients to a train set of 4 and a test set of 2.
%% Builds and trains an SVM model.
%% Returns a vector containing the success rate of each of the 2 tests.

%%
function counter_s = score_video_DCT(DCT_output, numOfDCTcoeff)
%% DCT - 2 Tests
   numOfSubjects = 7;
   sz = size(DCT_output);
   
   DCT1_1 = reshape(DCT_output(1,:,:),sz(2:3));
   DCT2_1 = reshape(DCT_output(2,:,:),sz(2:3));
   DCT3_1 = reshape(DCT_output(3,:,:),sz(2:3));
   DCT4_1 = reshape(DCT_output(4,:,:),sz(2:3));
   DCT5_1 = reshape(DCT_output(5,:,:),sz(2:3));
   DCT6_1 = reshape(DCT_output(6,:,:),sz(2:3));   

   DCT1_1_cut = DCT1_1(:,1:numOfDCTcoeff);
   DCT2_1_cut = DCT2_1(:,1:numOfDCTcoeff);
   DCT3_1_cut = DCT3_1(:,1:numOfDCTcoeff);
   DCT4_1_cut = DCT4_1(:,1:numOfDCTcoeff);
   DCT5_1_cut = DCT5_1(:,1:numOfDCTcoeff);
   DCT6_1_cut = DCT6_1(:,1:numOfDCTcoeff);

   % build the train set
    numOfTests = 2;
    X = [];
    for i=(1:numOfSubjects)
        X = [X;DCT1_1_cut(i,:);DCT2_1_cut(i,:);DCT3_1_cut(i,:);
            DCT4_1_cut(i,:)];        
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
        test = [test;DCT5_1_cut(i,:); DCT6_1_cut(i,:)];       
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