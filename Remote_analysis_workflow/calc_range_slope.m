function [range_slope] = calc_range_slope(DEM, ST_hl, antec_slope_range)
%antecedent slope - recieve DEM, ST_hl and distance range for calculation of the antecedent slope.

ST_range = modify(ST_hl,'maxdsdistance',antec_slope_range(2));
ST_range  = modify(ST_range,'shrinkfromtop',antec_slope_range(1));
range_slope = abs(((DEM.Z(ST_range.IXgrid(1)))-DEM.Z(ST_range.IXgrid(end)))/(ST_range.distance(1)-ST_range.distance(end)));
end

