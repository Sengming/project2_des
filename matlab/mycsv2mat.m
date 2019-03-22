function [records] = mycsv2mat(dircsv)

K = dir([dircsv,'/']);

names_csv = {K(~[K.isdir]).name}';

records = length(names_csv);

T=[];
for n=1:length(names_csv)
    C = strsplit(names_csv{n},'-');
    T(n).index = str2num(C{1});
    T(n).data = dlmread([dircsv,'/',names_csv{n}]);
    T(n).filename = names_csv{n};
end

[b,i]=sort([T.index]);
T=T(i);

delete WAVEMAT.mat

save WAVEMAT T
end