function filteredIm = BuildImageWithRatioOld(filteredIm,infoStrand,s)
nblabels = numel(infoStrand);
        for k=1:nblabels
            
            [l,c,lT,cT] = findUpLeft(infoStrand(k).ind,s);
            ind = sub2ind(s,lT,cT);
%             if withBlue
%                 str =num2str(round(infoStrand(k).RedRatio*100+infoStrand(k).BlueRatio*100));
%             else
                str = num2str(round(infoStrand(k).RedRatio*100));
%             end
            filteredIm = insertText(filteredIm,[c,l],str,'FontSize',30,'BoxColor',...
                'white','BoxOpacity',0.1,'TextColor','red');
            
            %figure;imshow(filteredIm,[])
        end 
end