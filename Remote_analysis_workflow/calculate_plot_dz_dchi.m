function [data_struct_cl, data_struct_hl] = calculate_plot_dz_dchi(sites_table_w_field_channelheads,ST_table, mn_ratio,A0, window)
%This function draws a figure with d_chi/dz as function of distance for a
%series of cliff and highland channels, and teturns the struct with
%distance, Z and chi for all of the sites
%   Detailed explanation goes here

    [num_sites,~] = size(sites_table_w_field_channelheads);
    data_struct_cl = struct('distance', {}, 'chi', {}, 'z', {}, 'deriv', {});
    data_struct_hl = struct('distance', {}, 'chi', {}, 'z', {}, 'deriv', {});

    for site_ind = 1:num_sites
        data_struct_cl(site_ind).distance = ST_table.cl{site_ind}.distance;
        data_struct_hl(site_ind).distance = ST_table.hl{site_ind}.distance;

        DEM = GRIDobj(string(sites_table_w_field_channelheads.DEM_path(site_ind)));
        DEM = fillsinks(DEM);
        FD = FLOWobj(DEM);
        A = flowacc(FD);
        data_struct_cl(site_ind).z = DEM.Z(ST_table.cl{site_ind}.IXgrid);
        data_struct_cl(site_ind).chi = chitransform(ST_table.cl{site_ind},A, 'mn', mn_ratio,'a0',A0); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
        
        data_struct_hl(site_ind).z = DEM.Z(ST_table.hl{site_ind}.IXgrid);
        wf_height = min(data_struct_cl(site_ind).z);
%         wf_equiv_hl_ind = find(data_struct_hl(site_ind).z > wf_height,1);
%         wf_equiv_hl_IX = ST_table.hl{site_ind}.IXgrid(wf_equiv_hl_ind);
        ind_above_wf = find(data_struct_hl(site_ind).z > wf_height);
        hl_above_wf = min(data_struct_hl(site_ind).z(ind_above_wf));
        hl_above_wf_ind = find(data_struct_hl(site_ind).z == hl_above_wf);
        wf_equiv_hl_IX = ST_table.hl{site_ind}.IXgrid(hl_above_wf_ind);

%         [~, wf_equiv_hl_ind] = min(abs(data_struct_hl(site_ind).z - wf_height) .* (data_struct_hl(site_ind).z > wf_height));
%         wf_equiv_hl_IX = ST_table.hl{site_ind}.IXgrid(wf_equiv_hl_ind);
        ST_table.hl{site_ind} = modify(ST_table.hl{site_ind},'upstreamto', wf_equiv_hl_IX);
        data_struct_hl(site_ind).z = DEM.Z(ST_table.hl{site_ind}.IXgrid);
        data_struct_hl(site_ind).distance = ST_table.hl{site_ind}.distance;

        data_struct_hl(site_ind).chi = chitransform(ST_table.hl{site_ind},A, 'mn', mn_ratio,'a0',A0); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m

    end
    
    for site_ind = 1:numel(data_struct_cl) % reorder fields according to ascending distance
        [~, sortedIndices] = sort(data_struct_cl(site_ind).distance);
        data_struct_cl(site_ind).z = data_struct_cl(site_ind).z(sortedIndices);
        data_struct_cl(site_ind).chi = data_struct_cl(site_ind).chi(sortedIndices);
        data_struct_cl(site_ind).distance = data_struct_cl(site_ind).distance(sortedIndices);
    end
    for site_ind = 1:numel(data_struct_hl) % reorder fields according to ascending distance
        [~, sortedIndices] = sort(data_struct_hl(site_ind).distance);
        data_struct_hl(site_ind).z = data_struct_hl(site_ind).z(sortedIndices);
        data_struct_hl(site_ind).chi = data_struct_hl(site_ind).chi(sortedIndices);
        data_struct_hl(site_ind).distance = data_struct_hl(site_ind).distance(sortedIndices);
    end
%     figure;
%     tiledlayout(5,2)
    for site_ind = 1:num_sites % calculate the derivative for each site
%         nexttile;
                % Extract data for the current site
        distance_cl = data_struct_cl(site_ind).distance;
        chi_cl = data_struct_cl(site_ind).chi;
        z_cl = data_struct_cl(site_ind).z;

        distance_hl = data_struct_hl(site_ind).distance;
        chi_hl = data_struct_hl(site_ind).chi;
        z_hl = data_struct_hl(site_ind).z;
        
        % Perform the analysis (similar to the previous code)
        derivative_cl = zeros(1, numel(distance_cl));
        derivative_hl = zeros(1, numel(distance_hl));

%         % 5 pix window:
%         for i = 3:numel(distance)-2
%             chi_5 = chi(i-2:i+2);
%             z_5 = z(i-2:i+2);
%             p = polyfit(chi_5, z_5, 1);
%             derivative(i) = polyval(polyder(p), chi(i));
%         end
%         data_struct(site_ind).deriv = derivative;
%         % Plot the derivative as a function of distance
%         plot(distance(3:end-2), derivative(3:end-2));
%         xlabel('Distance from Origin [m]');
%         ylabel('dZ/d_chi');
%         title([string(sites_table_w_field_channelheads.site_name(site_ind))]);

%         % 7 pix window:
%         for i = 4:numel(distance_cl)-3
%             chi_cl_7 = chi_cl(i-3:i+3);
%             z_cl_7 = z_cl(i-3:i+3);
%             p = polyfit(chi_cl_7, z_cl_7, 1);
%             derivative_cl(i) = polyval(polyder(p), chi_cl(i));
%         end
%         for i = 4:numel(distance_hl)-3
%             chi_hl_7 = chi_hl(i-3:i+3);
%             z_hl_7 = z_hl(i-3:i+3);
%             p = polyfit(chi_hl_7, z_hl_7, 1);
%             derivative_hl(i) = polyval(polyder(p), chi_hl(i));
%         end

        % flexible window:
        for i = (1+window):numel(distance_cl)-window
            chi_cl_flex = chi_cl(i-window:i+window);
            z_cl_flex = z_cl(i-window:i+window);
            p = polyfit(chi_cl_flex, z_cl_flex, 1);
            derivative_cl(i) = polyval(polyder(p), chi_cl(i));
        end
        for i = (1+window):numel(distance_hl)-window
            chi_hl_flex = chi_hl(i-window:i+window);
            z_hl_flex = z_hl(i-window:i+window);
            p = polyfit(chi_hl_flex, z_hl_flex, 1);
            derivative_hl(i) = polyval(polyder(p), chi_hl(i));
        end
        data_struct_cl(site_ind).deriv = derivative_cl;
        data_struct_hl(site_ind).deriv = derivative_hl;

        % Plot the derivative as a function of distance
%         plot(distance(4:end-3), derivative(4:end-3));
%         xlabel('Distance from Origin [m]');
%         ylabel('dZ/d_chi');
%         title([string(sites_table_w_field_channelheads.site_name(site_ind))]);
    end

end
