function segmIm3 = BuildImageWithRatio(segmIm3,infoStrandBico,...
            ratio,s)
        %figure
         for k=1:numel(infoStrandBico)
            [l,c,lT,cT] = findUpLeft(infoStrandBico{k}.PixelIdxList,s);
            if ~isnumeric(ratio)
                str = ratio(k,:);
            else
                str = num2str(round(ratio(k)));
            end
            segmIm3 = insertText(segmIm3,[c,l],str,'FontSize',30,'BoxColor',...
                'white','BoxOpacity',0,'TextColor','yellow');
            %imshow(segmIm3,[])
        end 
end