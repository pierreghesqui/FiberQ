function connectedSegm = LinkedGraph(object,alreadyObservedObject)
if nargin<2
    alreadyObservedObject={};
end
isM = object.ismember(alreadyObservedObject);
if ~any(isM)
    alreadyObservedObject=vertcatCell(alreadyObservedObject,object);

    EP = object.EP;
    
    for i = 1:numel(EP)
        for k = 1:numel(EP{i}.LinkedEP)
        if ~EP{i}.LinkedEP{k}.Object.ismember(alreadyObservedObject)
            alreadyObservedObject=LinkedGraph(EP{i}.LinkedEP{k}.Object,alreadyObservedObject);
        end
        end
    end
    

end
connectedSegm = alreadyObservedObject;

end