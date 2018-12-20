function I = imfuse2(I_rgN,skelSegmColor)
if isempty(I_rgN)||isempty(skelSegmColor)
    I = [];
    return;
end
I = imfuse(I_rgN,skelSegmColor,'blend');
end