function [M,C] = text2binary(filepath)

dir = '../CSV/';

filename = 'message_crypt_pairs.csv.txt';

%% DONt Modidify after


% H = dlmread([dir,filename],',');
fileID = fopen(filepath,'r');
a = textscan(fileID, '%s %s','delimiter', ',', 'EmptyValue', -Inf);
fclose(fileID);

M = hexToBinaryVector(a{1,1});
C = hexToBinaryVector(a{1,2});

M = M.*1;
C = C.*1;
save pairs M C a
end