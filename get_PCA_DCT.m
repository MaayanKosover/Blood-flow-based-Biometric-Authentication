%% Arrange the PCA and DCT coefficients

function [PCA_output,DCT_output] = get_PCA_DCT(numOfVectors)
%% Database
    [PCA_output1,DCT1,DCT2] = database_analysis(10000,16000,numOfVectors);
    [PCA_output2,DCT3,DCT4] = database_analysis(17000,23000,numOfVectors);
    [PCA_output3,DCT5,DCT6] = database_analysis(24000,30000,numOfVectors);
    [PCA_output4,DCT7,DCT8] = database_analysis(36000,42000,numOfVectors);
    [PCA_output5,DCT9,DCT10] = database_analysis(43000,49000,numOfVectors);
    [PCA_output6,DCT11,DCT12] = database_analysis(50000,56000,numOfVectors);
    [PCA_output7,DCT13,DCT14] = database_analysis(57000,63000,numOfVectors);
    [PCA_output8,DCT15,DCT16] = database_analysis(64000,70000,numOfVectors);
    [PCA_output9,DCT17,DCT18] = database_analysis(71000,77000,numOfVectors);
    [PCA_output10,DCT19,DCT20] = database_analysis(78000,84000,numOfVectors);
    
%% Sort output
    PCA_output = zeros(10,size(PCA_output1,1),size(PCA_output1,2),size(PCA_output1,3));
    PCA_output(1,:,:,:) = PCA_output1;
    PCA_output(2,:,:,:) = PCA_output2;
    PCA_output(3,:,:,:) = PCA_output3;
    PCA_output(4,:,:,:) = PCA_output4;
    PCA_output(5,:,:,:) = PCA_output5;
    PCA_output(6,:,:,:) = PCA_output6;
    PCA_output(7,:,:,:) = PCA_output7;
    PCA_output(8,:,:,:) = PCA_output8;
    PCA_output(9,:,:,:) = PCA_output9;
    PCA_output(10,:,:,:) = PCA_output10;   
    
%% Sort DCT output
    DCT_output = zeros(20,size(DCT1,1),size(DCT1,2));
    DCT_output(1,:,:,:) = DCT1;
    DCT_output(2,:,:,:) = DCT2;
    DCT_output(3,:,:,:) = DCT3;
    DCT_output(4,:,:,:) = DCT4;
    DCT_output(5,:,:,:) = DCT5;
    DCT_output(6,:,:,:) = DCT6;
    DCT_output(7,:,:,:) = DCT7;
    DCT_output(8,:,:,:) = DCT8;
    DCT_output(9,:,:,:) = DCT9;
    DCT_output(10,:,:,:) = DCT10;
    DCT_output(11,:,:,:) = DCT11;
    DCT_output(12,:,:,:) = DCT12;
    DCT_output(13,:,:,:) = DCT13;
    DCT_output(14,:,:,:) = DCT14;
    DCT_output(15,:,:,:) = DCT15;
    DCT_output(16,:,:,:) = DCT16;
    DCT_output(17,:,:,:) = DCT17;
    DCT_output(18,:,:,:) = DCT18;
    DCT_output(19,:,:,:) = DCT19;
    DCT_output(20,:,:,:) = DCT20;
