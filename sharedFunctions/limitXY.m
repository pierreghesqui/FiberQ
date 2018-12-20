function [Xlim,Ylim] = limitXY(XY)
Xlim = [min(XY(:,1)),max(XY(:,1))];
Ylim = [min(XY(:,2)),max(XY(:,2))];
end

