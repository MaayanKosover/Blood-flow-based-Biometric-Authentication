%% The function receives PCA coefficients for all the signals and the number
%% of required PCA coefficients.
%% Splits the PCA coefficients to a train set of 4 and a test set of 2.
%% Builds and trains an SVM model.
%% Returns a vector containing the success rate of each of the 2 tests.

%%
function counter_s = score_video_PCA(PCA_output,numOfPCAcoeff)
%% PCA - 2 Tests
    numOfSubjects = 7;
    siz = size(PCA_output);
    
    PCA1_1 = reshape(PCA_output(1,1:numOfPCAcoeff,:),numOfPCAcoeff,siz(3));
    PCA2_1 = reshape(PCA_output(2,1:numOfPCAcoeff,:),numOfPCAcoeff,siz(3));
    PCA3_1 = reshape(PCA_output(3,1:numOfPCAcoeff,:),numOfPCAcoeff,siz(3));
    PCA4_1 = reshape(PCA_output(4,1:numOfPCAcoeff,:),numOfPCAcoeff,siz(3));
    PCA5_1 = reshape(PCA_output(5,1:numOfPCAcoeff,:),numOfPCAcoeff,siz(3));
    PCA6_1 = reshape(PCA_output(6,1:numOfPCAcoeff,:),numOfPCAcoeff,siz(3));

    % build the train set
    numOfTests = 2;
    X = [];
    for i=(1:numOfSubjects) 
        X = [X;PCA1_1(:,i).';PCA2_1(:,i).';PCA3_1(:,i).';
        PCA4_1(:,i).'];       
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
        test = [test;PCA5_1(:,i).';PCA6_1(:,i).'];       
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