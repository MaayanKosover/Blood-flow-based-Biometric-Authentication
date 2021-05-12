function ppg_cut_filtered = filterPPG(ppg_cut)

    %% Filter PPG - smooth 
    ppg_cut_filtered(1,:) = smoothdata(ppg_cut(1,:),'gaussian',5);
    ppg_cut_filtered(2,:) = smoothdata(ppg_cut(2,:),'gaussian',2);
    ppg_cut_filtered(3,:) = smoothdata(ppg_cut(3,:),'gaussian',3);
    ppg_cut_filtered(4,:) = smoothdata(ppg_cut(4,:),'gaussian',9);
    ppg_cut_filtered(5,:) = smoothdata(ppg_cut(5,:),'gaussian',2);
    ppg_cut_filtered(6,:) = smoothdata(ppg_cut(6,:),'gaussian',2);
    ppg_cut_filtered(7,:) = smoothdata(ppg_cut(7,:),'movmedian',2);

    %% Filter PPG - movemean
    ppg_cut_filtered(1,:) = movmean(ppg_cut_filtered(1,:),17);
    ppg_cut_filtered(2,:) = movmean(ppg_cut_filtered(2,:),5);
    ppg_cut_filtered(3,:) = movmean(ppg_cut_filtered(3,:),2);
    ppg_cut_filtered(4,:) = movmean(ppg_cut_filtered(4,:),10);
    ppg_cut_filtered(5,:) = movmean(ppg_cut_filtered(5,:),2);
    ppg_cut_filtered(6,:) = movmean(ppg_cut_filtered(6,:),5);
    ppg_cut_filtered(7,:) = movmean(ppg_cut_filtered(7,:),7);