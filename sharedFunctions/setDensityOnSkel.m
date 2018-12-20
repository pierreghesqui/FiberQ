function listSkel = setDensityOnSkel(listSkel,BW_rough,param)
s = size(BW_rough);
sigma = round(param.DensityStd);
hsize = round(5*sigma);
density = imfilter(double(BW_rough),fspecial('gaussian',hsize,...
    sigma),'symmetric');
for i =1:numel(listSkel)
    listSkel{i}.density = density(listSkel{i}.PixelIdxList);
end

end