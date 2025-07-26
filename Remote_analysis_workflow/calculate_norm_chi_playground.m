[num_sites,~] = size(sites_table_w_field_channelheads);
for i = 6:6
    DEM = GRIDobj(string(sites_table_w_field_channelheads.DEM_path(i)));
    DEM = fillsinks(DEM);
    FD = FLOWobj(DEM);
    A = flowacc(FD);
    


%     ST_table.hl{i} = modify(ST_table.hl{i}, 'upstreamto', DEM>sites_table_w_field_channelheads.WF_Z(i));
%     ST_table.cl{i} = modify(ST_table.cl{i}, 'upstreamto', DEM>sites_table_w_field_channelheads.WF_Z(i));

    Chi_val_hl = chitransform(ST_table.hl{i},A,'mn', mn_ratio,'a0',A0); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
    Chi_val_cl = chitransform(ST_table.cl{i},A, 'mn', mn_ratio,'a0',A0); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
    
    ch_alt = min(ch_cl_table.z(i), ch_hl_table.z(i));

    [~, hl_ch_ind_equal] = min(abs(DEM.Z(ST_table.hl{i}.IXgrid) - ch_alt));
    [~, cl_ch_ind_equal] = min(abs(DEM.Z(ST_table.cl{i}.IXgrid) - ch_alt));

    X_ch_hl_equal = ST_table.hl{i}.x(hl_ch_ind_equal);
    X_ch_cl_equal = ST_table.cl{i}.x(cl_ch_ind_equal);
    Y_ch_hl_equal = ST_table.hl{i}.y(hl_ch_ind_equal);
    Y_ch_cl_equal = ST_table.cl{i}.y(cl_ch_ind_equal);

    hl_ch_chi_val = Chi_val_hl(hl_ch_ind_equal);
    cl_ch_chi_val = Chi_val_cl(cl_ch_ind_equal);


%         chi_diff = Chi_val_cl(ind_ch_cl_ST)-Chi_val_hl(ind_ch_hl_ST);
%     chi_diff_norm(i) = (Chi_val_cl(ch_cl_table.ST_coord_ind(i))-Chi_val_hl(ch_hl_table.ST_coord_ind(i)))/(Chi_val_cl(ch_cl_table.ST_coord_ind(i))+Chi_val_hl(ch_hl_table.ST_coord_ind(i)));
    chi_diff(i) = hl_ch_chi_val-cl_ch_chi_val;
    chi_diff_norm(i) = (hl_ch_chi_val-cl_ch_chi_val)/(hl_ch_chi_val+cl_ch_chi_val);

    %     figure

%     imageschs(DEM, [],'colormap',[1 1 1],'colorbar',false);
    hold on
    plotc(ST_table.cl{i},Chi_val_cl,'linewidth',3);
    plotc(ST_table.hl{i},Chi_val_hl,'linewidth',3);
%     scatter(ch_cl_table.x(i),ch_cl_table.y(i),'*r');
%     scatter(ch_hl_table.x(i),ch_hl_table.y(i),'*r');
    scatter(X_ch_hl_equal,Y_ch_hl_equal,'*g');
    scatter(X_ch_cl_equal,Y_ch_cl_equal,'*g');
    colorbar
end
