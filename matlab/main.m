clear; close all; clc;

dircsv = '../CSV';
records = mycsv2mat(dircsv);

load WAVEMAT

for n=1:records
    figure(n)
    plot(T(n).data(:,1),T(n).data(:,2))
end