function [listSkel] = controlFibers(listSkel,I_rgN,PSF)
I_rgN = imgaussfilt(I_rgN,PSF/2);%figure; imshow(I_rgN,[])
I_red = I_rgN(:,:,1);
I_green = I_rgN(:,:,2);
I_gray = rgb2gray(I_rgN);%figure; imshow(segm2Im(listSkel))
threshI = 0.1;
threshHoleLength = 0.1;
all_holeLength = zeros(size(listSkel));
all_nbHoles = zeros(size(listSkel));
all_std = zeros(size(listSkel));
allNbSplice = zeros(numel(listSkel),1)
for i=1:numel(listSkel)
    allNbSplice(i) = listSkel{i}.nbSplices;
end

all_holeLengthT = all_holeLength>threshHoleLength&all_nbHoles>1;
str = strcat(num2str(all_holeLength',2), num2str(all_nbHoles'));

labeledImage  = BuildImageWithRatio(I_rgN,listSkel,...
     allNbSplice,size(I_rgN));
%figure; imshow(labeledImage,[]);
listSkel(all_holeLengthT)=[];

end

