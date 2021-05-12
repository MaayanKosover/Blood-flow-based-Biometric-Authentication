%% The function receives PCA coefficients for all the signals, the number
%% of required PCA coefficients and a number of subjects. 
%% Splits the PCA coefficients to a train set of 4 and a test set of 2.
%% Builds and trains an SVM model.
%% Returns a vector containing the success rate of each of the 2 tests.

%%
function counter_s = scorePCA(PCA_output,numOfSubjects,numOfPCAcoeff)
%% PCA - 2 Tests
    output1 = reshape(PCA_output(1,:,:,:),2,8,42);
    output2 = reshape(PCA_output(2,:,:,:),2,8,42);
    output3 = reshape(PCA_output(3,:,:,:),2,8,42);
    output4 = reshape(PCA_output(4,:,:,:),2,8,42);
    output5 = reshape(PCA_output(5,:,:,:),2,8,42);
    output6 = reshape(PCA_output(6,:,:,:),2,8,42);
    output7 = reshape(PCA_output(7,:,:,:),2,8,42);
    output8 = reshape(PCA_output(8,:,:,:),2,8,42);
    output9 = reshape(PCA_output(9,:,:,:),2,8,42);
    output10 = reshape(PCA_output(10,:,:,:),2,8,42);
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
    
    % build the train set
    numOfTests = 2;
    X = [];
    for i=(1:numOfSubjects)
        X = [X;ECG1_1(:,i).';ECG5_1(:,i).';ECG7_1(:,i).';
        ECG10_1(:,i).'];       
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
        test = [test;ECG12_1(:,i).';ECG16_1(:,i).'];       
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