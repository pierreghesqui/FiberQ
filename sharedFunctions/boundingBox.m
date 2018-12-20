function [l_limit_min,l_limit_max,c_limit_min,c_limit_max,...
    lmin,lmax,cmin,cmax] = boundingBox(ind, s, sizDil)
if nargin<3
    sizDil =0;
end
    [lmin,cmin,lmax,cmax] = findUpLeft2(ind,s);
    l_limit_min = max(lmin-sizDil,1);
    l_limit_max = min(lmax+sizDil,s(1));
    c_limit_min = max(cmin-sizDil,1);
    c_limit_max = min(cmax+sizDil,s(2));
end