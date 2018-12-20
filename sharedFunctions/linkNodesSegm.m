function [listSegm,listNodes] = linkNodesSegm(listSegm,listNodes)
    nbSegm = numel(listSegm);
    nbNodes = numel(listNodes);
    s = listSegm{1}.sizeIm;
    imNodes = zeros(s);
    for i =1:nbNodes
        nodes_i = listNodes{i};
        imNodes(nodes_i.PixelIdxList)=i;%figure; imshow(imNodes,[])
    end
    for itSegm = 1:nbSegm
        segm_it = listSegm{itSegm};
        XYEP = segm_it.XY([1,end],:);
        x2search1 = max(XYEP(1,1)-1,1):min(XYEP(1,1)+1,s(2));
        x2search2 = max(XYEP(2,1)-1,1):min(XYEP(2,1)+1,s(2));
        y2search1 = max(XYEP(1,2)-1):min(XYEP(1,2)+1,s(1));
        y2search2 = max(XYEP(2,2)-1,1):min(XYEP(2,2)+1,s(1));
        lblNodes1 = setdiff(imNodes(y2search1,x2search1),0);%figure; imshow(imNodes>0,[]),hold on, plot(segm_it.XY(:,1),segm_it.XY(:,2))
        lblNodes2 = setdiff(imNodes(y2search2,x2search2),0);
        
            LinkedNodes =cell(2,1);
            if ~isempty(lblNodes1)
                node = listNodes{lblNodes1};
                LinkedNodes{1} = node;
                %node.addLinkedSegment(segm_it);
            end
            if ~isempty(lblNodes2)
                node = listNodes{lblNodes2};
                LinkedNodes{2} = node;
                %node.addLinkedSegment(segm_it);
            end
            
        segm_it.setLinkedNodes(LinkedNodes);
    end
end