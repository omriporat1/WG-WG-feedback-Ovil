function [ch_cl_table,ch_hl_table] = create_channelhead_table(sites_table,sites_ST_coord_struct,ch_ratio)
%This function receives the sites table with field channelhead locations,
%the sites coordinates location and channelhead location ratio.
%Where field data is available it finds the closest coordinate along the
%path and adds its coordinates to ch_table. If field data is not available
%it returns the points at ch_ratio of the height along each ST (cl,hl).
%   Detailed explanation goes here
    [num_sites, ~] = size(sites_table);
    table_headers = {'x','y','z','d','ST_coord_ind','source'};
    varTypes = {'double','double','double','double','double','string'};
    ch_cl_table = table('Size',[num_sites,6],'VariableNames', table_headers,'VariableTypes',varTypes);
    ch_hl_table = table('Size',[num_sites,6],'VariableNames', table_headers,'VariableTypes',varTypes);
    for i = 1:num_sites
        if sites_table.ch_cliff_X(i) == 0
            ch_height = min(sites_ST_coord_struct(i).two_trunks.z) + ch_ratio*(max(sites_ST_coord_struct(i).two_trunks.z)-min(sites_ST_coord_struct(i).two_trunks.z));
            cl_ch_ind = find(sites_ST_coord_struct(i).cl.z<ch_height,1);
            hl_ch_ind = find(sites_ST_coord_struct(i).hl.z<ch_height,1);
            ch_cl_table(i,1:5) = table(sites_ST_coord_struct(i).cl.x(cl_ch_ind), sites_ST_coord_struct(i).cl.y(cl_ch_ind), sites_ST_coord_struct(i).cl.z(cl_ch_ind), sites_ST_coord_struct(i).cl.d(cl_ch_ind),cl_ch_ind);
            ch_cl_table(i,6) = {"remote"};
            ch_hl_table(i,1:5) = table(sites_ST_coord_struct(i).hl.x(hl_ch_ind), sites_ST_coord_struct(i).hl.y(hl_ch_ind), sites_ST_coord_struct(i).hl.z(hl_ch_ind), sites_ST_coord_struct(i).hl.d(hl_ch_ind),hl_ch_ind);
            ch_hl_table(i,6) = {"remote"};

        else
            cl_coord.x = sites_ST_coord_struct(i).cl.x; cl_coord.y = sites_ST_coord_struct(i).cl.y;
            field_ch_cl.x = sites_table.ch_cliff_X(i); field_ch_cl.y = sites_table.ch_cliff_Y(i);
            cl_dist = sqrt((cl_coord.x - field_ch_cl.x).^2 + (cl_coord.y - field_ch_cl.y).^2);
            [~,cl_ch_ind] = min(cl_dist); 

            hl_coord.x = sites_ST_coord_struct(i).hl.x; hl_coord.y = sites_ST_coord_struct(i).hl.y;
            field_ch_hl.x = sites_table.ch_highland_X(i); field_ch_hl.y = sites_table.ch_highland_Y(i);
            hl_dist = sqrt((hl_coord.x - field_ch_hl.x).^2 + (hl_coord.y - field_ch_hl.y).^2);
            [~,hl_ch_ind] = min(hl_dist);

            ch_cl_table(i,1:5) = table(sites_ST_coord_struct(i).cl.x(cl_ch_ind), sites_ST_coord_struct(i).cl.y(cl_ch_ind), sites_ST_coord_struct(i).cl.z(cl_ch_ind), sites_ST_coord_struct(i).cl.d(cl_ch_ind),cl_ch_ind);
            ch_cl_table(i,6) = {"field"};
            ch_hl_table(i,1:5) = table(sites_ST_coord_struct(i).hl.x(hl_ch_ind), sites_ST_coord_struct(i).hl.y(hl_ch_ind), sites_ST_coord_struct(i).hl.z(hl_ch_ind), sites_ST_coord_struct(i).hl.d(hl_ch_ind),hl_ch_ind);
            ch_hl_table(i,6) = {"field"};

        end
    end

end
