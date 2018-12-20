function PruneGraph(listSkelRoot,param)
if isa(listSkelRoot,'ListSegm')
    listSegm = listSkelRoot;
    %listSegm.Filter(param.minLength4SkeletonBefore);%remove from list segments in forbiden zone and small segments
    listSegm.sort;
    listSegm = listSegm.List;
elseif isa(listSkelRoot,'cell')
    listSegm = listSkelRoot;
    %     [~,idx] = sort(cellfun(@(x) length(x.PixelIdxList),listSegm.List));
    %     listSegm.List=listSegm.List(idx);
end
cpt = 1;%figure;imshow(segm2Im(listSegm))
if isempty(listSegm)
    return
end
%--- order segment by size
while(numel(listSegm)>=cpt)
    if numel(listSegm)>100
        tic
    end
    %---initialisation---%
    indBest = [];
    ismodified = 0;
    chosenSegm = listSegm{cpt};
    
    if ~isvalid(chosenSegm) ||...
            isalone(chosenSegm)
        cpt = cpt+1;
        continue;
    end %figure;imshow(segm2Im({chosenSegm},'withConn'))
    %% Find the longest segment
    %any(ismember(chosenSegm.XY(:,1),995)&ismember(chosenSegm.XY(:,2),1329))
    EP = chosenSegm.EP;
    tryConnect = true(numel(EP),1);
    %--getallImportantConnection
    for i =1:numel(EP)
        EP_i = EP{i};
        
        ListConn = EP_i.getImportantConnection(); %figure;imshow(segm2Im({chosenSegm},'withConn'))
        
        if isempty(ListConn)
            continue
        end
        
        % compute the ranking position of connections with EP_i
        idxEP_i = find(cellfun(@(x) eq(x.EP{1},EP_i)|eq(x.EP{2},EP_i), ListConn));
        ListConnGoodEP = ListConn(cellfun(@(x) eq(x.EP{1},EP_i)|eq(x.EP{2},EP_i), ListConn));
        cpt2 = 1;
        while cpt2<=length(idxEP_i)&&tryConnect(i)
            % evaluate the best connection with EP_i
            idxEP_ij = idxEP_i(cpt2);
            % get the other EP (=candidateEP) of the connection
            candidateEP = ListConn{idxEP_ij}.EP{~cellfun(@(x) eq(x, EP_i),ListConn{idxEP_ij}.EP)};
            %imshow(segm2Im({chosenSegm,candidateEP.Object},'withConn'))
            % see if candidateEP is present in better connection
            NbCandidateBefore = sum(find(cellfun(@(x) eq(x.EP{1},candidateEP)...
                |eq(x.EP{2},candidateEP), ListConn))<idxEP_ij);
            ListConnGoodEPExceptCandidate =  ListConnGoodEP(cellfun(@(x) ~eq(x.EP{1},candidateEP)&~eq(x.EP{2},candidateEP),ListConnGoodEP));
            
            %imshow(segm2Im({ListConn{2}.EP{1}.Object,ListConn{2}.EP{2}.Object},'withConn'))
            if isa(candidateEP.Object,'dnaBlob')&&...
                    ListConn{idxEP_ij}.score<5&& ...
                    NbCandidateBefore<2 &&...
                    ~eq(EP_i.Object,candidateEP.Object)
                
                
                connect2EP(EP_i,ListConn{idxEP_ij},param);
                if ~isempty({ListConnGoodEPExceptCandidate{:}})
                    chosenSegm.otherCandidates(end+1) ={ListConnGoodEPExceptCandidate(:)};
                else
                    chosenSegm.otherCandidates(end+1) ={0};
                end
                chosenSegm.anglesSplices(end+1) = ListConn{idxEP_ij}.angle;
                chosenSegm.distanceSplices(end+1) = ListConn{idxEP_ij}.dist;
                chosenSegm.nbBlob = chosenSegm.nbBlob+1;
                %figure;imshow(segm2Im({EP_i.Object,candidateEP.Object},'withConn'))
                tryConnect(i) =false;
                
            elseif isa(candidateEP.Object,'dnaSegm')&&...
                    ListConn{idxEP_ij}.score<5&& ...
                    NbCandidateBefore<1 &&...
                    ~eq(EP_i.Object,candidateEP.Object)
                
                connect2EP(EP_i,ListConn{idxEP_ij},param);
                if ~isempty({ListConnGoodEPExceptCandidate{:}})
                    chosenSegm.otherCandidates(end+1) ={ListConnGoodEPExceptCandidate(:)};
                else
                    chosenSegm.otherCandidates(end+1) ={0};
                end
                chosenSegm.anglesSplices(end+1) = ListConn{idxEP_ij}.angle;
                chosenSegm.distanceSplices(end+1) = ListConn{idxEP_ij}.dist;
                chosenSegm.nbSegm = chosenSegm.nbSegm+1;
                %figure;imshow(segm2Im({EP_i.Object,candidateEP.Object},'withConn'))
                tryConnect(i) =false;
            end
            cpt2=cpt2+1;
        end
        
        
    end
    if any(~tryConnect) &&~chosenSegm.isInForbidZone
        chosenSegm.nbSplices=chosenSegm.nbSplices+sum(~tryConnect);
        
        PruneGraph({chosenSegm},param);
    end
    
    cpt = cpt+1;
    if numel(listSegm)>100
        toc
    end
end
end