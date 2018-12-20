function [listSkel] =  PruneSkel(imSkelRoot,imBlob,BW_rough,grayImage,param,expFold)
%figure; imshow(imSkel);

[listSkelRoot,EPList] = imSkel2List(imSkelRoot,ListEP({}),param);
[listBlob,EPList] = imBlob2List(imBlob,EPList);
EPList.connectEP(param);
EPList.setForbidList(BW_rough,grayImage,param,expFold);%figure; imshow(label2rgb(segm2Im(listSkelRoot.List,'',0),'prism','k'),[])
%% 
%save('beforePruneGraph')
%load('beforePruneGraph')
if exist('expFold','var')
    save(fullfile(expFold,'beforePruneGraph'))
    %load(fullfile(expFold,'beforePruneGraph'))
end
PruneGraph(listSkelRoot,param);%figure;imshow(segm2Im(listSkelRoot.List)==28)
listSkelRoot.Filter(param.minLength4Skeleton);

listSkelRoot.refineEnd(BW_rough);%figure,imshow(segm2Im(listSkelRoot.List,'',0)>0)
listSkel = listSkelRoot.List;%figure,imshow(segm2Im(listSkel,'',0)>0)
listSkel   = filterBoudary(listSkel);

end