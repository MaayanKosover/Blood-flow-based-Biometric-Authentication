%% The function returns the eigenvectors of the given signal.

%%
function V2 = get_Eig(signal)
    signal_std = normalize(signal,2, 'zscore');
    P = signal_std'*signal_std;
    [V,D] = eig(P);

    D2=diag(sort(diag(D),'descend')); % make diagonal matrix out of sorted diagonal values of input D
    [c, ind]=sort(diag(D),'descend'); % store the indices of which columns the sorted eigenvalues come from
    V2=V(:,ind); % arrange the columns in this order
end