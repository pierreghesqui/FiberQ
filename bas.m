cd 'sharedFunctions'
D = dir('*m');
files = {D.name}';
all = {};
for i=1:numel(files)
[fList,pList] = matlab.codetools.requiredFilesAndProducts(files{i});
Names = {pList.Name};
v = ~contains(Names,all);
all={all{:},Names{v}};

end