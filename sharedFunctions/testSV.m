function [r,g,b] = testSV(SV,s,isCategory,isDil)
if nargin<3
    isCategory=0;
    
end
if nargin<4
    isDil = 0 ;
end
r = zeros(s(1),s(2));
g = zeros(s(1),s(2));
b = zeros(s(1),s(2));
for i = 1:numel(SV)
    if any(strcmp(fieldnames(SV),'PixelIdxList'))
        PixelIdxList = SV(i).PixelIdxList;
    else
        PixelIdxList = SV(i).ind;
    end
    if isCategory==0
        intRed = SV(i).intRed;intGreen = SV(i).intGreen;intBlue = SV(i).intBlue;
        r(PixelIdxList) =intRed;
        g(PixelIdxList) =intGreen;
        b(PixelIdxList) =intBlue;
    elseif isCategory==1
        isRed = double(SV(i).color==2);isGreen = double(SV(i).color==1);isBlue = double(SV(i).color==0);
        r(PixelIdxList) =isRed;
        g(PixelIdxList) =isGreen;
        b(PixelIdxList) =isBlue;
    elseif isCategory==2
        r(PixelIdxList) =i;
        g(PixelIdxList) =i;
        b(PixelIdxList) =i;
    end
    
end
if isDil%ones(1,isDil)
    r = imdilate(r,ones(isDil,isDil));
    g = imdilate(g,ones(isDil,isDil));
    b = imdilate(b,ones(isDil,isDil));
end
%figure; imshow(cat(3,r,g,b))
end