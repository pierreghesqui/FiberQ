function FAST_options = buildFiberQ_options(inp)
MarkerName ={'IdU','CldU'};
FAST_options = struct;
for i =1:size(inp,1)
    FAST_options(i).FirstMarker = inp{i,2};
    FAST_options(i).SecondMarker = MarkerName{~strcmp(MarkerName,inp{i,2})};
    FAST_options(i).ChannelFirstMarker = inp{i,3};
    FAST_options(i).colorFirstMarker = inp{i,4};
end
end