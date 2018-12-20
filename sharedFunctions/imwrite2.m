function imwrite2(im,path)
if isempty(im)
    imwrite(0,path);
    return;
end
imwrite(im,path);
end