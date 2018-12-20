function vStep = possibleStep(P1,v,s)

potStep = [-1 ,   -1 ,   -1,    0 ,    0,     1,     1,     1;
    -1 ,   0 ,    1,    -1 ,    1,    -1,     0,     1];

if P1(1)==1
    potStep(:,potStep(1,:)==-1) =[];
elseif P1(1)==s(2)
    potStep(:,potStep(1,:)==1) =[];
end
if P1(2)==1
    potStep(:,potStep(2,:)==-1) =[];
elseif P1(1)==s(2)
    potStep(:,potStep(2,:)==1) =[];
end
vStep=potStep(:,v'*potStep>=0);

end