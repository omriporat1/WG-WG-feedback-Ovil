function [ST_cl, ST_hl] = separate_ST_across_wg(DEM,ST_2_trunks)
%This function recieves across-divide channel ST and returns 2 separate ST.
    [~,I] = min(DEM.Z(ST_2_trunks.IXgrid));
    ST_cl = modify(ST_2_trunks,'upstreamto',ST_2_trunks.IXgrid(I));
    ST_hl = modify(ST_2_trunks,'rmnodes',ST_cl);
end