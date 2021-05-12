%% The function receives 2 derived PPG signals and returns their DCT coeffients
%% using this algorithm:
%%      1. Calculate M auto-correlation coefficients
%%      2. Take one half of the auto-correlation result.
%%      3. Calculate the DCT of the AC.
%%      4. Take C DCT coefficients.

%%
function [DCT_DB, test_DB] = get_DCT_from_PPG_der(first_ppg,first_ppg_test,isVideo)
    %% build DCT_DB matrix
    if(~isVideo)
        numOfSubject = 42;
        M = 400;
        C = M*0.1;
    else
        numOfSubject = 7;
        M = 100;
        C = 40;
    end
    DCT_DB = zeros(numOfSubject,C);
    AC_cut_DB = zeros(numOfSubject,M+1);
    for i = 1:numOfSubject 
        AC = xcorr(first_ppg(i,:),M,'normalize'); 
        mid = ceil(length(AC)/2);
        AC_cut_DB(i,:) = AC(mid:end);
        DCT = dct(AC_cut_DB(i,:));    
        DCT_DB(i,:) = DCT(1:C);
    end

    %% build test_DB matrix
    test_DB = zeros(numOfSubject,C);
    AC_cut_test = zeros(numOfSubject,M+1);
    for i = 1:numOfSubject   
        AC = xcorr(first_ppg_test(i,:),M,'normalize');
        mid = ceil(length(AC)/2);
        AC_cut_test(i,:) = AC(mid:end);
        DCT = dct(AC_cut_test(i,:));    
        test_DB(i,:) = DCT(1:C);
    end
 end