function [M,C] = text2binary(filepath)

dir = '../CSV/';

filename = 'message_crypt_pairs.csv.txt';

%% DONt Modidify after


% H = dlmread([dir,filename],',');
fileID = fopen(filepath,'r');
a = textscan(fileID, '%s %s','delimiter', ',', 'EmptyValue', -Inf);
fclose(fileID);

%M = hexToBinaryVector(a{1,1});
%C = hexToBinaryVector(a{1,2});
M = dec2bin(hex2dec(a{1,1}));
A = a{1,1};
B = A(1:10)
C = dec2bin(hex2dec(a{1,2}));

end
