function [FAST_options] = readFAST_Options(expFold_p)
    %DEFAULT
    FAST_options.nbMarker = 2;
    FAST_options.Marker1  = 'IdU';
    FAST_options.Marker2  = 'CldU';
    FAST_options.Channel1 = 'CldU';
    FAST_options.Channel2 = 'IdU';
    if ~exist(fullfile(expFold_p,'FAST_Options.txt'),'file')
        %TODO
    else
        fileID = fopen(fullfile(expFold_p,'FAST_Options.txt'));
        tline = fgetl(fileID);
        while ischar(tline)
            disp(tline)
            [FAST_options] = analyseLine(tline,FAST_options);
            tline = fgetl(fileID);
        end
        fclose(fileID);
        
    end
end