function [Div,Div_cell,wg_table] = map_all_divides_and_windgaps(DEM_path,min_area,height_axis)
% This function recieves DEM_path (a path of DEM), min_area (minimum
% threshold area for catchment),and height_axis (height range for color scale). It
% creates a map of all divide sections and highlights the minimum along each
% divide, with divide index and point index in that divide. It returns
% div_cell (a table with all divide sections IX reffered to in the DEM) and
% wg_table (a table with the indexes of each windgap and its X, Y, Z locations. 
    DEM = GRIDobj(DEM_path);
    DEM = fillsinks(DEM);
    cellsize = DEM.cellsize;
    
    FD  = FLOWobj(DEM,'preprocess','c');
    ST_area = STREAMobj(FD,'minarea',min_area/(cellsize^2));
    Div = DIVIDEobj(FD,ST_area);
    Div = cleanedges(Div,FD);
    
    % separate the sections of divide:
    Div_nans = find(~isnan(Div.IX));
    idx = find(diff(Div_nans)~=1);
    A_tmp = [idx(1);diff(idx);numel(Div_nans)-idx(end)];
    Div_cell = mat2cell(Div.IX(~isnan(Div.IX)),A_tmp,1);
    
    % General map with 1 local min for each divide section:
    figure
%     imageschs(DEM,[], 'colormap', landcolor,'caxis',height_axis);
    imageschs(DEM);
    hold on
    plot(ST_area,'k');

    wg_sec_ind = zeros(numel(Div_cell),1);
    wg_insec_ind = zeros(numel(Div_cell),1);
    wg_X = zeros(numel(Div_cell),1);
    wg_Y = zeros(numel(Div_cell),1);
    wg_Z = zeros(numel(Div_cell),1);

    for i = 1:numel(Div_cell)
        [current_div_X, current_div_Y] = ind2coord(Div,cell2mat(Div_cell(i)));
        current_div_Z = DEM.Z(coord2ind(DEM,current_div_X, current_div_Y));
        [~, TF] = min(current_div_Z);
        current_serial_wg = 1:length(current_div_X);    
        plot(current_div_X,current_div_Y,'-g', LineWidth = 2);
        if (current_serial_wg(TF) ~= 1) && (current_serial_wg(TF) ~= numel(current_serial_wg))
            scatter(current_div_X(TF), current_div_Y(TF),'*r');
            text(current_div_X(TF),current_div_Y(TF),string(i) + '\' + string(current_serial_wg(TF)),'interpreter','none');
        end
        wg_sec_ind(i) = i;
        wg_insec_ind(i) = current_serial_wg(TF);
        wg_X(i) = current_div_X(TF);
        wg_Y(i) = current_div_Y(TF);
        wg_Z(i) = current_div_Z(TF);
    end
    wg_table = table(wg_sec_ind,wg_insec_ind,wg_X,wg_Y,wg_Z);
end


