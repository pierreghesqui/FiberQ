function skelSegm  = segm2colorIm(listSkelf,dilz)
if nargin<2
    dilz = 0;
end
if isempty(listSkelf)
    skelSegm = [];
    return;
end
nbSegm = numel(listSkelf);
if nbSegm>0
    s = listSkelf{1}.sizeIm;
    imr = zeros(s);
    img = zeros(s);
    imb = zeros(s);
    for i =1:nbSegm
        idx = listSkelf{i}.PixelIdxList;
        color = listSkelf{i}.color;
        img(idx(color==1))=1;
        imr(idx(color==2))=1;
    end
end
skelSegm = cat(3,imr,img,imb);
skelSegm = imdilate(skelSegm,strel('disk',dilz));
%figure; imshow(skelSegm)
end