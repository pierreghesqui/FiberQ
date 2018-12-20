function out = delBorderSegm(inp,s,opt)
if nargin<3
    opt = 'large';
end
if strcmp(opt,'large')
    largeSegm = inp;
    imlabel = bwlabel(largeSegm);
    mask = false(size(largeSegm));
    mask(1:2,:) = true;
    mask(end-1:end,:)=true;
    mask(:,1:2) = true;
    mask(:,end-1:end) = true;
    label2Del = setdiff(unique(imlabel(mask)),0);
    imlabel(ismember(imlabel, label2Del)) =0;
    largeSegm2 =imlabel>0; 
    out = largeSegment2;
elseif strcmp(opt,'SV')
    SV = inp;
    ind2Del = [];
    for i =1:numel(SV)
        xyLarge = SV(i).xyLarge;
        x = xyLarge(:,1);
        y = xyLarge(:,2);
        if any( [x==1;x==2; x==s(2);x==s(2)-1;y==1;y==2;y==s(1);y==s(1)-1])
            ind2Del = [ind2Del,i];
        end
    end
    SV(ind2Del) = [];
    out = SV;
else
    error('delBorderSegm : opts unknown');
end
    %figure; imshowpair(largeSegm>0,largeSegm2>0)
end