function ListConnection=sortListConnection(ListConnection)
    nbConn = numel(ListConnection);
    if nbConn>0
    score =  cellfun(@(x) x.score,ListConnection);
    dist  = cellfun(@(x) x.dist,ListConnection);
    
    [~,idx]  = sortrows([score;dist]',[1 2]);
    ListConnection = ListConnection(idx);
    else
        ListConnection={};
    end
    %displaySegm({ListConnection{1}.EP{1}.Object,ListConnection{1}.EP{2}.Object})
    %displaySegm({ListConnection{2}.EP{1}.Object,ListConnection{2}.EP{2}.Object})
    %displaySegm({ListConnection{3}.EP{1}.Object,ListConnection{3}.EP{2}.Object}),hold on
%     quiver(ListConnection{3}.EP{2}.XY(1),ListConnection{3}.EP{2}.XY(2),...
%     ListConnection{3}.EP{2}.tanEP(1)*10,ListConnection{3}.EP{2}.tanEP(2)*10)
end