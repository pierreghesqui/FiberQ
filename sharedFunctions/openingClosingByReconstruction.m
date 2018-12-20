function im2 = openingClosingByReconstruction(im,szFilter)

se = strel('disk',round((szFilter-1)/2));
Ie = imerode(im, se);%figure; imshowpair(im,Ie,'montage')
Iobr = imreconstruct(Ie, im);%figure; imshowpair(im,Iobr,'montage')
diff = im-Iobr;

%% 
imf = imcomplement(imfill(imcomplement(im),'holes'));figure; imshow(imf,[])


figure; subplot(1,2,1),imshow(im(:,:,1),[]),subplot(1,2,2),imshow(diff(:,:,1)>0,[])
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
im2 = imcomplement(Iobrcbr);
im3 = im2-imerode(im2,strel('disk',20));
J = histeq(im3(:,:,1));
figure; subplot(1,2,1),imshow(im(:,:,1),[]),subplot(1,2,2),imshow(J,[]);
end