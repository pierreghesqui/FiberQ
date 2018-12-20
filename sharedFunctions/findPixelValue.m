function int = findPixelValue(im,x1,y1,opt)
if nargin<4
    opt = '';
end
s = size(im);
if strcmp(opt,'nearest')
    x = round(x1);
    y = round(y1);
    if y<1 || y>s(1) || x<1 || x>s(2)
        int = 0;
    else
        int = im(y,x);
    end
else
    
    xd = floor(x1);
    xu = ceil(x1);
    yd = floor(y1);
    yu = ceil(y1);
    
    a = (y1-yd)*(x1-xd);
    b = (yu-y1)*(x1-xd);
    c = (y1-yd)*(xu-x1);
    d = (yu-y1)*(xu-x1);
    
    if yu<1 || yu>s(1) ||yd<1 || yd>s(1)||xd<1 || xd>s(2)||xu<1 || xu>s(2)
        int = 0;
    else
        int = a*im(yu,xu)+d*im(yd,xd)+b*im(yd,xu)+c*im(yu,xd);
    end
end
end