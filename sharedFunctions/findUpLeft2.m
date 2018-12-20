function [lmin,cmin,lmax,cmax] = findUpLeft2(ind,s)
    [l,c] = ind2sub(s,ind);
    [lmin] = min(l); cmin = min(c); 
    [lmax] = max(l); cmax = max(c);
    
end