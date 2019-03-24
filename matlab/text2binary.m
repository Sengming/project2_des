function [M,C] = text2binary(T)

% dir = '../CSV/';
% 
% filename = 'message_crypt_pairs.csv.txt';

%% DONt Modidify after


% H = dlmread([dir,filename],',');
% fileID = fopen(filepath,'r');
% a = textscan(fileID, '%s %s','delimiter', ',', 'EmptyValue', -Inf);
% fclose(fileID);

M = hexToBinaryVector({T.message}');
C = hexToBinaryVector({T.cypertext}');

M = M.*1;
C = C.*1;
save pairs M C
end