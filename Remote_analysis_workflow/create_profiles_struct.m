function [profile_table] = create_profiles_table(sites_table_with_field_ch,channelhead_vertical_ratio)
%This function creates a stuct containing the data for all profiles
%including the profiles themselves.
%   The function receives a table with all the information existing
%   regarding each site: name, DEM_path, min_area, site_ind reference in
%   that DEM, WF location (XYZ), and field-measured channelhead location
%   where this info exists. It then extracts the two main trunks from the
%   divide and saves them as STREAMobjs in the struct.
%   If channelhead locations exist, the function finds the closest
%   locations along the main trunk and difines it as channelhead. It then
%   calculates the two normalized slope asymmetry parameters to these
%   points. Otherwise, it defines channelheads by
%   "channelhead_vertical_ratio" which represents a user-defined relative
%   vertical location of the channelheads, and then calculates both
%   measures
%   
n_sites = size(sites_table_with_field_ch,1);
profile_table = sites_table_with_field_ch;
ST_cliff = cell(n_sites,1);
ST_highland = cell(n_sites,1);
profile_table = profile_table,ST_cliff,ST_highland;

profile_table.ST_cliff = NaN; profile_table.ST_highland = NaN;
    for i = 1:n_sites
        if sites_table_with_field_ch.ch_cliff_X == 0
            profile_struct(end+1) = stability_line_no_field_data(sites_table_with_field_ch(i,:),channelhead_vertical_ratio);
        else
            profile_struct(end+1) = stability_line_with_field_data(sites_table_with_field_ch(i,:));

    end


end