function linkMatrix2=DisconnectEPFromSameFiber(linkMatrix)
    linkMatrix2 = linkMatrix;
    s = size(linkMatrix2);
    linkMatrix2(eye(s,'logical')) = false;
    for i=1:2:s(1)-1
        linkMatrix2(i,i+1) = false;
        linkMatrix2(i+1,i) = false;
    end
    %figure; imshowpair(linkMatrix,linkMatrix2);
end