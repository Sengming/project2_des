%% CPA for round 16
%pkg load image
%pkg load communications
clc; clear; close all;
% hamming = get_guess_lr_hamming_distance();
[hamming,L15s] = get_guess_lr_hamming_distance2();
% get_guess_lr_hamming_distance2
save guess

%%
load DESdata
HALF_L = @(message) message(1:32);
HALF_R = @(message) message(33:64);

for i=1:64
    c(i) = sum(sum(L15s{i}-HALF_L(Coutm1)))
end
%%
load pairs
IP = @(message) message(:,[58	50	42	34	26	18	10	2 ...
                        60	52	44	36	28	20	12	4 ...
                        62	54	46	38	30	22	14	6 ...
                        64	56	48	40	32	24	16	8 ...
                        57	49	41	33	25	17	9	1 ...
                        59	51	43	35	27	19	11	3 ...
                        61	53	45	37	29	21	13	5 ...
                        63	55	47	39	31	23	15	7]);
C16 = IP(C);
HALF_L = @(message) message(:,1:32);
HALF_R = @(message) message(:,33:64);
C16R = HALF_R(C16);
C16L = HALF_L(C16);

HD16 = sum(xor(C16R,C16L),2);

save testr16 HD16
