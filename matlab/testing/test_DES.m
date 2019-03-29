clear; clc;

load pairs;
% load WAVEMAT
key = [0,1,1,0,1,0,1,1,0,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,1,1,0,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,1,1,0,1,1,0,0,1,0,0];

nkey = [key(1:7),key(9:15),key(17:23),key(25:31),key(33:39),key(41:47),key(49:55),key(57:63)];
for i=1:length(M)
% [Cout(i,:),HD(i)] = DES(M(i,:),'ENC',key);
[Cout(i,:),Coutm1(i,:),HD(i)] = myDES(M(i,:),'ENC',key);

i
end
%%
% Ti = mod([1:63],2);
% T = diag(Ti,1) + diag(Ti,-1);
a =sum(C);
b =sum(Cout);
[a',b']

max(max(abs(C-Cout)))

save DESdata Coutm1 HD

% sum(sum(C*T-Cout))
% 
% save Ls L Cout