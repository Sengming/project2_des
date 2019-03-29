function [ E,Err_code ] = ema( Y,M )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[l,b] = size(Y);

if l>M
    Err_code = 0;
else
    Err_code = 1;
    disp(['Not enough T-Steps for EMA',num2str(M),'. Returning SMA.']);
    E = Y;
    return
end

a = 2/(M + 1);

N = l-M;

T_bar1 = [ones(1,M)./M , zeros(1,N)];
T_bar2 = [zeros(N,M),eye(N).*a];

T_bar = [T_bar1;T_bar2];

Y_bar = T_bar*Y;

x = 1-a;

L = tril(ones(N+1),-1);

P = L*L+L;

A = tril(x.^P);

E = A*Y_bar;

end

