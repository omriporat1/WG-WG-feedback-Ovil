function [] = create_profiles_figure(sites_ST_coord_struct_vert,ch_cl_table,ch_hl_table,asym_table,sites_table)
%This function creates the profile figure included in the results chatper
%of the thesis. that includes across-divide d-z profile from remote data
%with waterfall and channelheads marked differently according to data
%source, normalized slope asymmetry bars and normalized chi asymmetry bars
%where available.
%   Detailed explanation goes here
    [num_sites, ~] = size(sites_ST_coord_struct_vert);
    figure
    for i = 1:num_sites
        hl_flip_temp = sites_ST_coord_struct_vert(i).hl;
%         hl_flip_temp(end,:) = [];
        hl_cumsum = cumsum(abs(diff(hl_flip_temp.d)));
        hl_flip_temp.d(1) = max(sites_ST_coord_struct_vert(i).cl.d) + 0.5;
        hl_flip_temp.d(2:end) = hl_flip_temp.d(1) + hl_cumsum;
        sites_ST_coord_struct_vert(i).full = [flipud(sites_ST_coord_struct_vert(i).cl);hl_flip_temp];
%         ch_hl_table.full_ind(i) = height(sites_ST_coord_struct_vert(i).cl)+height(hl_flip_temp)-ch_hl_table.ST_coord_ind(i);
        ch_hl_table.full_ind(i) = height(sites_ST_coord_struct_vert(i).cl)+ch_hl_table.ST_coord_ind(i);

        ch_cl_table.full_ind(i) = height(sites_ST_coord_struct_vert(i).cl)-ch_cl_table.ST_coord_ind(i)+1;
    end



    T = tiledlayout(1,4,'TileSpacing','compact');
    T_profiles = tiledlayout(T,num_sites,1,'TileSpacing','compact');
    T_profiles.Layout.Tile = (1);
    T_profiles.Layout.TileSpan = [1 2];
    title(T_profiles, "Profiles", 'FontSize', 20)
    T_slope = tiledlayout(T,num_sites,1);
    T_slope.Layout.Tile = 3;
    title(T_slope, "Slope asymmetry", 'FontSize', 20)
    T_chi = tiledlayout(T,num_sites,1);
    T_chi.Layout.Tile = 4;
    title(T_chi, "Chi asymmetry", 'FontSize', 20)
    chi_ax = [];


    for i = 1:num_sites
        nexttile(T_profiles);
        % create profiles and mark points
        
        plot(sites_ST_coord_struct_vert(i).full,'d','z','LineWidth', 3);
        hold on
        ax = gca;
        ax.YGrid = 'on';
        ax.XGrid = 'off';
           
        
        set(ax,'FontSize',7);
        
        if ch_hl_table.source(i) == "field"
            scatter(sites_ST_coord_struct_vert(i).full.d([ch_cl_table.full_ind(i),ch_hl_table.full_ind(i)]),sites_ST_coord_struct_vert(i).full.z([ch_cl_table.full_ind(i),ch_hl_table.full_ind(i)]),'^', 'filled');
        else
            scatter(sites_ST_coord_struct_vert(i).full.d([ch_cl_table.full_ind(i);ch_hl_table.full_ind(i)]),sites_ST_coord_struct_vert(i).full.z([ch_cl_table.full_ind(i);ch_hl_table.full_ind(i)]),'*');
        end
    
        ylabel(string(sites_table.site_name(i)), "FontSize",12, "FontWeight","bold"); xlabel('');
        % normalized stability index parameters calculation

%         grid off
    
        slope_ax(i) = nexttile(T_slope);

        
        barh(slope_ax(i),i,[asym_table.div_ch_norm_slope(i),asym_table.ch_wf_norm_slope(i)],'BaseValue',0,'LineWidth',0.7);
        hold on;
        er = errorbar([asym_table.div_ch_norm_slope(i),asym_table.ch_wf_norm_slope(i)], [i-0.15,i+0.15], [asym_table.div_ch_norm_slope(i)-asym_table.div_ch_norm_slope_min(i),asym_table.ch_wf_norm_slope(i)-asym_table.ch_wf_norm_slope_min(i)],[asym_table.div_ch_norm_slope_max(i)-asym_table.div_ch_norm_slope(i),asym_table.ch_wf_norm_slope_max(i)-asym_table.ch_wf_norm_slope(i)],'.','horizontal');

        er.Color = [0 0 0];                            
        er.LineStyle = 'none';
        er.LineWidth = 1.5;
        er.Color = 'k';
        er.MarkerSize = 3;
        hold off;

%         grid on
        ax = gca;
        ax.YTickLabels = {''};
        xlim([-0.8, 1]);
    


        if ~isnan(asym_table.lower_ch_norm_chi_asym(i))
%             chi_ax(i) = nexttile(T_chi,i);
            chi_ax = [chi_ax,nexttile(T_chi,i)];
            b = barh(chi_ax(end),i,asym_table.lower_ch_norm_chi_asym(i),'BaseValue',0);
%             b = barh(chi_ax(end),i,asym_table.lower_ch_chi_asym(i),'BaseValue',0); % return to previous later

            ax = gca;
            ax.YTickLabels = {''};
            xlim([-0.4, 0.8]);
%             xlim([-300, 900]); % return to previous later

            b.FaceColor = [0.9290 0.6940 0.1250];
        %     grid on
            grid off
        end
    end
    
    nexttile(T_profiles,num_sites);
    
    % h(1) = plot(nan, nan, 'r*', 'MarkerSize', 16, 'DisplayName', 'channelheads');
    % h(2) = plot(nan, nan, 'rp', 'MarkerSize', 16, 'DisplayName', 'waterfall head');
    h(1) = scatter(nan, nan, 'r*', 'DisplayName', 'remote channelheads');
    h(2) = scatter(nan, nan, 'r^', 'filled', 'DisplayName', 'field channelheads');
    lgd = legend(h, 'Orientation',"horizontal");
    
    % lgd  = legend('','waterfall head','channelheads','Orientation',"horizontal");
    
    lgd.Layout.Tile = 'south';
    lgd.FontSize = 11;
    
    
    
    linkaxes([slope_ax(:)],'x');
    xticklabels(slope_ax(1:end-1),{})
    yticklabels(slope_ax(:),{})
    xlim(slope_ax(:),[-0.8, 1]);
    
    
    
    nexttile(T_slope,8);
    lgd = legend('divide - channelhead','channelhead - waterfall','Orientation',"horizontal");
    lgd.Layout.Tile = 'south';
    lgd.FontSize = 10;
    
    ax = gca;
    % ax.YGrid = 'on';
    set(ax,'FontSize',12);
    
    
    
    linkaxes([chi_ax(:)],'x');
    xticklabels(chi_ax(1:end-1),{})
    yticklabels(chi_ax(:),{})
%     xlim(chi_ax(:),[0, 0.8]);
    ax = gca;
    set(ax,'FontSize',12);
%     nexttile(T_chi,num_sites);
%     lgd = legend('Chi asymmetry','Orientation',"horizontal");
%     lgd.Layout.Tile = 'south';
%     lgd.FontSize = 13;


    % ax.YGrid = 'on';


end