
clear

M = 1.*(rand(1,64)>.5);

[Me,Key]=DES(M,'ENC');

Mc = DES(Me,'DEC',Key);