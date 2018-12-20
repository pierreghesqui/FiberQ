function [l2,c2,l,c] = findUpLeft(ind,s)
    [l,c] = ind2sub(s,ind);
    [l2] = min(l); c2=min(c); 
    
    thresh = 30;
    if l2>s(1)-thresh
        l2 = l2-thresh;
    end
     if c2>s(2)-thresh
        c2 = c2-thresh;
     end
     if l2<thresh
        l2 = l2+thresh;
     end
     if c2<thresh
        c2 = c2+thresh;
    end
end