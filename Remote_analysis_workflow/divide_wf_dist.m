function [dist] = divide_wf_dist(ST_cl,kp_ind)
%div-wf distance - recieve DEM, ST_cl, kp index, and return the distance
%from the channelhead (=divide) to the waterfall.
    ST_div_wf = modify(ST_cl,'upstreamto',kp_ind);
    dist = max(ST_div_wf.distance);
end
