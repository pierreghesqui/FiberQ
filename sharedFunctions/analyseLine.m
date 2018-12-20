function [FAST_options] = analyseLine(tline,FAST_options)
    tline = lower(tline);
    if contains(tline,'nb of marker')||contains(tline,'nb of markers')
            contains(tline,'nbofmarker')||contains(tline,'nbofmarkers')||...
            contains(tline,'markernb')
        C = strsplit(tline,':');
        FAST_options.nbMarker = str2num(C{2});
    elseif contains(tline,'marker1')
        C = strsplit(tline,':');
        marker1 = C{2};
        marker1= marker1(find(~isspace(marker1)));
        FAST_options.Marker1 = marker1;
    elseif contains(tline,'marker2')
        C = strsplit(tline,':');
        marker2 = C{2};
        marker2= marker2(find(~isspace(marker2)));
        FAST_options.Marker2 = marker2;
    elseif contains(tline,'channel1')
        C = strsplit(tline,':');
        channel1 = C{2};
        channel1= channel1(find(~isspace(channel1)));
        FAST_options.Channel1 = channel1;
    elseif contains(tline,'channel2')
        C = strsplit(tline,':');
        channel2 = C{2};
        channel2= channel2(find(~isspace(channel2)));
        FAST_options.Channel2 = channel2;
    end
    
end