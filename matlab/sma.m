function [ E,Err_code ] = sma( Y,M )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[n,b] = size(Y);
k=M;

if n>M
    Err_code = 0;
else
    Err_code = 1;
    error(['Not enough T-Steps for SMA.']);
    E = Y;
    return
end

m2 = [triu(ones(n-k+1)),ones(n+1-k,k-1)];
m3 = [ones(n+1-k,k-1),tril(ones(n-k+1))];

m = m2.*m3;

E = (m*Y)./M;

end

