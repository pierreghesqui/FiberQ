function [xmin,xmax,ymin,ymax] = convertBB2Limit(BB)
xmin = BB(1); xmax = xmin+BB(3);
ymin = BB(2); ymax = ymin+BB(4);
xmin=ceil(xmin);
xmax=floor(xmax);
ymin=ceil(ymin);
ymax=floor(ymax);
end