function [A_drain] = kp_drainage(DEM, kp_DEM_ind)
%recieve DEM and knickpoint index (IX) and return drainage area.
    cellsize = DEM.cellsize;
    FD  = FLOWobj(DEM,'preprocess','c');
    A = flowacc(FD);
    A_drain = A.Z(kp_DEM_ind)*(cellsize^2);
end


