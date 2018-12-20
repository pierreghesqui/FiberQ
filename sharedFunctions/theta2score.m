function score = theta2score(theta)
    if theta<2
        score=1;
    elseif theta<5
        score = 2;
    elseif theta<10
        score = 3;
    elseif theta<15
        score = 4;
    else
        score = 5;
    end
end