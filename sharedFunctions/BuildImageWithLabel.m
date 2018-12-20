function filteredIm  = BuildImageWithLabel(filteredIm,listSkelf,...
            FiberLabel,s)
        
        for k=FiberLabel'
            [l,c,lT,cT] = findUpLeft(listSkelf{k}.PixelIdxList,s);
            str = num2str(k);
            filteredIm = insertText(filteredIm,[c,l],str,'FontSize',30,'BoxColor',...
                'white','BoxOpacity',0,'TextColor','white');
            %figure;imshow(filteredIm,[])
        end 
        
        
end