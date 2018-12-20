function BP_im2 = labelBP(skelLabel)%figure; imshow(skelLabel)
BP_im = bwmorph(skelLabel,'branchPoints'); %figure; imshow(BP_im,[])
BP_im2 = double(BP_im);
BP_im2(BP_im) = skelLabel(BP_im);%

end