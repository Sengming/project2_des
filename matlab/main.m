clear; close all; clc;

dircsv = '../CSV';
records = mycsv2mat(dircsv);

load WAVEMAT

disp(['Total of ',num2str(records),' power traces read'])