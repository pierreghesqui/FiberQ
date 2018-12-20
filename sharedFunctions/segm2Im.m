function im2 = segm2Im(ListSegm,opts1,opts2)
if nargin<2
    opts1 = '';
    opts2 = 0;
end
if isempty(ListSegm)
    im2 = [];
    return;
end
segm = ListSegm{1};
s = segm.sizeIm;
im = zeros(s);
imConn = zeros(s);
im(segm.PixelIdxList) = 1;
for i =2:numel(ListSegm)
    im(ListSegm{i}.PixelIdxList) = i;
end
if strcmp(opts1,'withConn')
    for i =1:numel(ListSegm)
        for k = 1:numel(ListSegm{i}.EP)
                if ~isempty(ListSegm{i}.EP{k})
                    linkedEP = ListSegm{i}.EP{k}.LinkedEP;
                    for l = 1:numel(linkedEP)
                    [ ~,~,Index ,maxNbP] = plotLine2( ListSegm{i}.EP{k}.XY',linkedEP{l}.XY',s,0 );
                    imConn(Index) = 1;%figure; imshow(imConn,[])
                    end
                end
        end
            
    end
    im2 = cat(3,im,im,imConn);%figure; imshow(im2,[])
    
else
    im2 = imdilate(im,strel('disk',opts2));
    
end
end
