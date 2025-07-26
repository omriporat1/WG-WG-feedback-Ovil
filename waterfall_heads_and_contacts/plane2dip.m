function [dip, dip_dir] = plane2dip(a, b)
%This function recieves the coefficients of x and y of the plane equation
%and returns the dip and dip direction of the plane
%   Detailed explanation goes here
norm_vec = [a, b, -1];
horizontal_norm = [0 0 1];

if a<0
    dip_dir = 90-atand(b/a);
else
    dip_dir = 270-atand(b/a);
end
dip = acosd(abs((dot(norm_vec,horizontal_norm))/(norm(norm_vec)*norm(horizontal_norm))));
end

