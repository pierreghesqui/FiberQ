function displaySegm(SegmList,opts)
    if nargin<2
        opts = 'label';
    end
    s = SegmList{1}.sizeIm;
    im = zeros(s);
    for i =1:numel(SegmList)
        im(SegmList{i}.PixelIdxList)=i;
    end
    if strcmp(opts,'label')
        imshow(im,[])
    else
        imshow(im>0,[])
    end
    
end