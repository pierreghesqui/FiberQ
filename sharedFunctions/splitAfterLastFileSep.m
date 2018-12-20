function str2 = splitAfterLastFileSep(str1)
str2 = strsplit(str1,filesep);
str2=str2{end};
end