function [chi_diff] = calculate_norm_chi(sites_table_w_field_channelheads,ST_table,ch_cl_table,ch_hl_table, mn_ratio,A0)
%This function returns the normalized chi difference for a series of
%windgaps
%   Detailed explanation goes here
    [num_sites,~] = size(sites_table_w_field_channelheads);
    chi_diff = zeros(num_sites,2);
%     chi_diff_norm = zeros(num_sites,1);
    for i = 1:num_sites
        DEM = GRIDobj(string(sites_table_w_field_channelheads.DEM_path(i)));
        DEM = fillsinks(DEM);
        FD = FLOWobj(DEM);
        A = flowacc(FD);

        Chi_val_hl = chitransform(ST_table.hl{i},A,'mn', mn_ratio,'a0',A0); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
        Chi_val_cl = chitransform(ST_table.cl{i},A, 'mn', mn_ratio,'a0',A0); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
        
        ch_alt = min(ch_cl_table.z(i), ch_hl_table.z(i));

        [~, hl_ch_ind_equal] = min(abs(DEM.Z(ST_table.hl{i}.IXgrid) - ch_alt));
        [~, cl_ch_ind_equal] = min(abs(DEM.Z(ST_table.cl{i}.IXgrid) - ch_alt));
        hl_ch_chi_val = Chi_val_hl(hl_ch_ind_equal);
        cl_ch_chi_val = Chi_val_cl(cl_ch_ind_equal);

        chi_diff(i,1) = hl_ch_chi_val-cl_ch_chi_val;
        chi_diff(i,2) = (hl_ch_chi_val-cl_ch_chi_val)/(hl_ch_chi_val+cl_ch_chi_val);
        
        
    end
end