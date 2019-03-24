function [records] = mycsv2mat(dircsv)

K = dir([dircsv,'/']);
a = {strfind({K.name}','DES_HW')};
b = not(cellfun(@isempty,a{1,1}));
names_csv = {K(b).name}';

records = length(names_csv);

T=[];
for n=1:length(names_csv)
    C = strsplit(names_csv{n},{'-','=','.','_'});
    T(n).index = str2num(C{1});
    T(n).key = C{12};
    T(n).message = C{14};
    T(n).cypertext = C{16};
    T(n).data = dlmread([dircsv,'/',names_csv{n}]);
    T(n).filename = names_csv{n};
end

[b,i]=sort([T.index]);
T=T(i);

delete WAVEMAT.mat

save WAVEMAT T records
end