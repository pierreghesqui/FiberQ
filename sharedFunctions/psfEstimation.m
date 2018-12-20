function psfEsti = psfEstimation(i,threshError,halfLengthProfile,vecNor,segm_i,im,I_rg,largeSegment)
%% ini output
psfEsti =[];
%% 
x = [-halfLengthProfile:halfLengthProfile];
xi = segm_i.XYsmoothed(i,1);
    yi = segm_i.XYsmoothed(i,2);
    xp = xi+vecNor(i,1)*x;
    yp = yi+vecNor(i,2)*x;
    sizIm=size(im);
    %figure; subplot(1,2,1),imshow(im),hold on,plot(xp,yp,'xr'),subplot(1,2,2),imshow(largeSegment),hold on, plot(xp,yp,'xr')
    if max(xp)>sizIm(2)||min(xp)<1||max(yp)>sizIm(1)||min(yp)<1
        return
    end
%     tic
%     profil2 = improfile(im,xp,yp);
%     toc
%     tic
    profil = im(sub2ind(size(im),round(yp),round(xp)))';
%     toc
    minpro = prctile(profil,10);
    s = [1:length(profil)]';
    f = fit(s,profil-minpro,'gauss1');
    if 0
        figure;
        plot([1:length(profil)],profil-minpro,'x','MarkerSize',10,'LineWidth',2);set(gca,'FontSize',15)
        hold on; plot([1:0.1:length(profil)],f([1:0.1:length(profil)]),'LineWidth',2),
        
    end
    
    
    coeffvals = coeffvalues(f);
    erreur = mean(abs(f([1:length(profil)])-(profil-minpro)))/(profil(round(length(profil)/2))-minpro);
    if  erreur > threshError
        return;
    end
    if 0
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,2,[3,4]),imshow(I_rg),hold on,plot(xp,yp,'xr'),
    subplot(2,2,1),imshow(largeSegment),hold on, plot(xp,yp,'xr')
    subplot(2,2,2),plot(f,[1:length(profil)],profil-minpro)
    end
    psfEsti = coeffvals(3);
end