function [out] = Contrary1vs2(d)
if  d==1
    out = 2;
elseif  d==2
    out = 1;
else
    error('input is neither 1 nor 2')
end
end

