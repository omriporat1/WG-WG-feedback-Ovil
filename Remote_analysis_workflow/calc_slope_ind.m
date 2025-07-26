function [slope_asym] = calc_slope_ind(DEM,ST_cl,ST_hl)
%Recieves DEM, ST_cl, ST_hl and channel ratio and returns slope asymmetry
%index.

    ST_cl_Z = DEM.Z(ST_cl.IXgrid);
    ST_hl_Z = DEM.Z(ST_hl.IXgrid);

    ST_cl_slope = (max(ST_cl_Z)-min(ST_cl_Z))/max(ST_cl.distance);
    ST_hl_slope = (max(ST_hl_Z)-min(ST_hl_Z))/max(ST_hl.distance);

    slope_asym = (ST_cl_slope-ST_hl_slope)/(ST_cl_slope+ST_hl_slope);
end