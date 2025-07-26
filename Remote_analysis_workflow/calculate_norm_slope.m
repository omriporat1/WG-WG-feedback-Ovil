function [slope_asym_table] = calculate_norm_slope(sites_ST_coord_struct_vert,ch_cl_table,ch_hl_table,RMSE)
%This function receives the coordinates of the streams and the locations
%(including indexes) of channelheads, and returns windgap-channelhead
%and channelhead-waterfall slope asymmetry
%   Detailed explanation goes here
    [num_sites, ~] = size(sites_ST_coord_struct_vert);

    for i = 1:num_sites
        [cl_num_coords, ~] = size(sites_ST_coord_struct_vert(i).cl(:,'d'));
        [hl_num_coords, ~] = size(sites_ST_coord_struct_vert(i).hl(:,'d'));
        cl_ind(i).wf = cl_num_coords-1;
        hl_ind(i).wf = hl_num_coords-1;
        cl_ind(i).ch = ch_cl_table.ST_coord_ind(i);
        hl_ind(i).ch = ch_hl_table.ST_coord_ind(i);
        cl_ind(i).div = 1;
        hl_ind(i).div = 1;
        
        cl_slope(i).div_ch = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch))/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch));
        cl_slope(i).ch_wf = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).wf))/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).wf));
        hl_slope(i).div_ch = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch))/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch));
        hl_slope(i).ch_wf = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).wf))/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).wf));

%         cl_slope_max(i).div_ch = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch)+2*RMSE)/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch));
%         cl_slope_max(i).ch_wf = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).wf)+2*RMSE)/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).wf));
%         hl_slope_max(i).div_ch = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch)+2*RMSE)/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch));
%         hl_slope_max(i).ch_wf = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).wf)+2*RMSE)/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).wf));
% 
%         cl_slope_min(i).div_ch = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch)-2*RMSE)/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch));
%         cl_slope_min(i).ch_wf = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).wf)-2*RMSE)/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).wf));
%         hl_slope_min(i).div_ch = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch)-2*RMSE)/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch));
%         hl_slope_min(i).ch_wf = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).wf)-2*RMSE)/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).wf));


        cl_slope_max(i).div_ch = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch)+RMSE)/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch));
        cl_slope_max(i).ch_wf = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).wf)+RMSE)/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).wf));
        hl_slope_max(i).div_ch = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch)+RMSE)/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch));
        hl_slope_max(i).ch_wf = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).wf)+RMSE)/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).wf));

        cl_slope_min(i).div_ch = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch)-RMSE)/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).div)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch));
        cl_slope_min(i).ch_wf = (sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.z(cl_ind(i).wf)-RMSE)/(sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).ch)-sites_ST_coord_struct_vert(i).cl.d(cl_ind(i).wf));
        hl_slope_min(i).div_ch = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch)-RMSE)/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).div)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch));
        hl_slope_min(i).ch_wf = (sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.z(hl_ind(i).wf)-RMSE)/(sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).ch)-sites_ST_coord_struct_vert(i).hl.d(hl_ind(i).wf));




    end
    table_headers = {'div_ch_norm_slope','ch_wf_norm_slope'};
    varTypes = {'double','double'};
    slope_asym_table = table('Size',[num_sites,2],'VariableNames', table_headers,'VariableTypes',varTypes);
    slope_asym_table.div_ch_norm_slope = (([cl_slope.div_ch]-[hl_slope.div_ch])./([cl_slope.div_ch]+[hl_slope.div_ch]))';
    slope_asym_table.div_ch_norm_slope_max = (([cl_slope_max.div_ch]-[hl_slope_min.div_ch])./([cl_slope_max.div_ch]+[hl_slope_min.div_ch]))';
    slope_asym_table.div_ch_norm_slope_min = (([cl_slope_min.div_ch]-[hl_slope_max.div_ch])./([cl_slope_min.div_ch]+[hl_slope_max.div_ch]))';
    
    slope_asym_table.ch_wf_norm_slope = (([cl_slope.ch_wf]-[hl_slope.ch_wf])./([cl_slope.ch_wf]+[hl_slope.ch_wf]))';
    slope_asym_table.ch_wf_norm_slope_max = (([cl_slope_max.ch_wf]-[hl_slope_min.ch_wf])./([cl_slope_max.ch_wf]+[hl_slope_min.ch_wf]))';
    slope_asym_table.ch_wf_norm_slope_min = (([cl_slope_min.ch_wf]-[hl_slope_max.ch_wf])./([cl_slope_min.ch_wf]+[hl_slope_max.ch_wf]))';
    slope_asym_table.hl_slope_max = [hl_slope_max.ch_wf]';
    slope_asym_table.hl_slope_min = [hl_slope_min.ch_wf]';
end