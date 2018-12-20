function PSFs = calculatePSF(segm_i,im,largeSegment,I_rg)
sizIm = size(im);
lengthSegm = length(segm_i);
tan = segm_i.XYsmoothed(2:end,:)-segm_i.XYsmoothed(1:end-1,:);
tan =[tan(1,:);tan];
tan = tan./vecnorm(tan')';
vecNor = [-tan(:,2),tan(:,1)];
PSFs =[]; 
nbDiv = 6;
possible_i = round([1:nbDiv]*lengthSegm/nbDiv);
cpt = 0;
threshError = 5/100;
halfLengthProfile = 6;

while length(PSFs)<4&& cpt<length(possible_i)
    try
    cpt = cpt+1;
    i = possible_i(cpt);
    psfEsti = Inf;
    cptLength = 0;
    cptWhile = 0;
    while ~isempty(psfEsti)&&...
            psfEsti>0.25*halfLengthProfile
    halfLengthProfile = 6+5*cptLength;
    
    psfEsti = psfEstimation(i,threshError,halfLengthProfile,vecNor,segm_i,im,I_rg,largeSegment);
    
    cptLength = cptLength+1;
    cptWhile=cptWhile+1;
    end
    if ~isempty(psfEsti)
    PSFs(end+1) = psfEsti;
    end
    catch
        continue
    end
end



end



%%
% x = [-halfLengthProfile:halfLengthProfile];
%     xi = segm_i.XYsmoothed(i,1);
%     yi = segm_i.XYsmoothed(i,2);
%     xp = xi+vecNor(i,1)*x;
%     yp = yi+vecNor(i,2)*x;
%     %figure; subplot(1,2,1),imshow(im),hold on,plot(xp,yp,'xr'),subplot(1,2,2),imshow(largeSegment),hold on, plot(xp,yp,'xr')
%     if max(xp)>sizIm(2)||min(xp)<1||max(yp)>sizIm(1)||min(yp)<1
%         continue
%     end
%     profil = improfile(im,xp,yp);
%     minpro = prctile(profil,10);
%     s = [1:length(profil)]';
%     f = fit(s,profil-minpro,'gauss1');%figure;plot(f,[1:length(profil)],profil-minpro)
%     coeffvals = coeffvalues(f);
%     erreur = mean(abs(f([1:length(profil)])-(profil-minpro)))/(profil(round(length(profil)/2))-minpro);
%     if  erreur > threshError
%         continue;
%     end
%     if 0
%     figure('units','normalized','outerposition',[0 0 1 1])
%     subplot(2,2,[3,4]),imshow(I_rg),hold on,plot(xp,yp,'xr'),
%     subplot(2,2,1),imshow(largeSegment),hold on, plot(xp,yp,'xr')
%     subplot(2,2,2),plot(f,[1:length(profil)],profil-minpro)
%     end
%     PSFs(end+1) = 3*coeffvals(3);