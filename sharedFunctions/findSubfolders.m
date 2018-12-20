function [ subfolds2 ] = findSubfolders( path1 )

subfolds = dir(path1); tag = [subfolds.isdir]; subfolds(~tag)=[];subfolds(1:2)=[];

subfolds2 = fullfile(path1,{subfolds.name})';
end

