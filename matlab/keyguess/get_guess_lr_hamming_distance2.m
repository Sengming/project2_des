function [hamming, weighted_hamming, L15s] = get_guess_lr_hamming_distance2(C,M)
% -------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                   1. Cryptographical primitives                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.1 define splitting function
HALF_L = @(message) message(:,1:32);
HALF_R = @(message) message(:,33:64);
% 1.2 define expansion function
EF = @(halfMessage) [halfMessage([32,4:4:28])',(reshape(halfMessage,4,8))',halfMessage([5:4:29,1])'];

  
% 1.3 define key mixing (KM)
KM = @(expandedHalfMessage,rK) xor(expandedHalfMessage,reshape(rK,6,8)');
% 1.4 define eight substitution tables
% input: 0	1   2   3   4   5   6   7   8   9   10  11  12  13  14  15
st{1} = [14	4	13	1	2	15	11	8	3	10	6	12	5	9	0	7;...
         0  15	7	4	14	2	13	1	10	6	12	11	9	5	3	8;...
         4	1	14	8	13	6	2	11	15	12	9	7	3	10	5	0;...
         15	12	8	2	4	9	1	7	5	11	3	14	10	0	6	13];
st{2} = [15	1	8	14	6	11	3	4	9	7	2	13	12	0	5	10;...
    	3	13	4	7	15	2	8	14	12	0	1	10	6	9	11	5;...
		0	14	7	11	10	4	13	1	5	8	12	6	9	3	2	15;...
		13	8	10	1	3	15	4	2	11	6	7	12	0	5	14	9];
st{3} = [10	0	9	14	6	3	15	5	1	13	12	7	11	4	2	8;...
		13	7	0	9	3	4	6	10	2	8	5	14	12	11	15	1;...
		13	6	4	9	8	15	3	0	11	1	2	12	5	10	14	7;...
		1	10	13	0	6	9	8	7	4	15	14	3	11	5	2	12];
st{4} = [7	13	14	3	0	6	9	10	1	2	8	5	11	12	4	15;...
		13	8	11	5	6	15	0	3	4	7	2	12	1	10	14	9;...
		10	6	9	0	12	11	7	13	15	1	3	14	5	2	8	4;...
		3	15	0	6	10	1	13	8	9	4	5	11	12	7	2	14];
st{5} = [2	12	4	1	7	10	11	6	8	5	3	15	13	0	14	9;...
		14	11	2	12	4	7	13	1	5	0	15	10	3	9	8	6;...
		4	2	1	11	10	13	7	8	15	9	12	5	6	3	0	14;...
		11	8	12	7	1	14	2	13	6	15	0	9	10	4	5	3];
st{6} = [12	1	10	15	9	2	6	8	0	13	3	4	14	7	5	11;...
		10	15	4	2	7	12	9	5	6	1	13	14	0	11	3	8;...
		9	14	15	5	2	8	12	3	7	0	4	10	1	13	11	6;...
		4	3	2	12	9	5	15	10	11	14	1	7	6	0	8	13];
st{7} = [4	11	2	14	15	0	8	13	3	12	9	7	5	10	6	1;...
		13	0	11	7	4	9	1	10	14	3	5	12	2	15	8	6;...
		1	4	11	13	12	3	7	14	10	15	6	8	0	5	9	2;...
		6	11	13	8	1	4	10	7	9	5	0	15	14	2	3	12];
st{8} = [13	2	8	4	6	15	11	1	10	9	3	14	5	0	12	7;...
		1	15	13	8	10	3	7	4	12	5	6	11	0	14	9	2;...
		7	11	4	1	9	12	14	2	0	6	10	13	15	3	5	8;...
		2	1	14	7	4	10	8	13	15	12	9	0	3	5	6	11];
% the eight binary s-boxes
for i = 1:8
    ST{i} = mat2cell(blkproc(st{i},[1,1],@(x) de2bi(x,4,'left-msb')),ones(1,4),ones(1,16)*4);
end
% 1.5 define subsitution function (SBOX)
SUBS = @(expandedHalfMessage,blkNo) ST{blkNo}{bi2de(expandedHalfMessage(blkNo,[1,6]),'left-msb')+1,bi2de(expandedHalfMessage(blkNo,[2:5]),'left-msb')+1};
SBOX = @(expandedHalfMessage) [SUBS(expandedHalfMessage,1);SUBS(expandedHalfMessage,2);...
                               SUBS(expandedHalfMessage,3);SUBS(expandedHalfMessage,4);...
                               SUBS(expandedHalfMessage,5);SUBS(expandedHalfMessage,6);...
                               SUBS(expandedHalfMessage,7);SUBS(expandedHalfMessage,8)];
% 1.6 define permutation function (PBOX)
PBOX = @(halfMessage) halfMessage([16  7 20 21  29 12 28 17 ... 
                                    1 15 23 26   5 18 31 10 ...
                                    2  8 24 14  32 27  3  9 ...
                                   19 13 30  6  22 11  4  25]);
                               
PBOX_R = @(halfMessage) halfMessage([9 17 23 31 13 28 2 18 ...
                                      24 16 30 6 26 20 10 1 ...
                                      8 14 25 3 4 29 11 19 ...
                                      32 12 22 7 5 27 15 21]); 
% 1.7 define initial permutation (IP)
IP = @(message) message(:,[58	50	42	34	26	18	10	2 ...
                        60	52	44	36	28	20	12	4 ...
                        62	54	46	38	30	22	14	6 ...
                        64	56	48	40	32	24	16	8 ...
                        57	49	41	33	25	17	9	1 ...
                        59	51	43	35	27	19	11	3 ...
                        61	53	45	37	29	21	13	5 ...
                        63	55	47	39	31	23	15	7]);
% 1.8 define final permutation (FP)
FP = @(message) message([40	8	48	16	56	24	64	32 ...
                        39	7	47	15	55	23	63	31 ...
                        38	6	46	14	54	22	62	30 ...
                        37	5	45	13	53	21	61	29 ...
                        36	4	44	12	52	20	60	28 ...
                        35	3	43	11	51	19	59	27 ...
                        34	2	42	10	50	18	58	26 ...
                        33	1	41	9	49	17	57	25]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                           2. key schedule                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.1 define permuted choice 1 (PC1)
PC1L = @(key64) key64([57	49	41	33	25	17	9 ...
                    1	58	50	42	34	26	18 ...
                    10	2	59	51	43	35	27 ...
                    19	11	3	60	52	44	36]);
PC1R = @(key64) key64([63	55	47	39	31	23	15 ...
                    7	62	54	46	38	30	22 ... 
                    14	6	61	53	45	37	29 ...
                    21	13	5	28	20	12	4]);
% 2.2 define permuted choice 2 (PC2)
PC2 = @(key56) key56([14 17	11	24	1	5	3	28 ...
                     15	6	21	10	23	19	12	4 ...
                     26	8	16	7	27	20	13	2 ...
                     41	52	31	37	47	55	30	40 ...
                     51	45	33	48	44	49	39	56 ...
                     34	53	46	42	50	36	29	32]);
% 2.3 define rotations in key-schedule (RK)
% round# 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6
   RK = [1 1 2 2 2 2 2 2 1 2 2 2 2 2 2 1];
% 2.4 define key shift function (KS)
KS = @(key28,s) [key28(s+1:end),key28(1:s)];    
% 2.5 define sub-keys for each round
% leftHKey = PC1L(K); % 28-bit half key
% rightHKey = PC1R(K);% 28-bit half key
% for i = 1:16
%     leftHKey = KS(leftHKey,RK(i));
%     rightHKey = KS(rightHKey,RK(i));
%     key56 = [leftHKey ,rightHKey];
%     subKeys(i,:) = PC2(key56(:));
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                           3. DES main loop                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.1 initial permutation
     
% switch mode
%     case 'ENC' % if encryption, split 64 message to two halves
%         L{1} = HALF_L(C); % left-half 32-bit
%         R{1} = HALF_R(C); % right-half 32-bit
%     case 'DEC' % if decryption, swapping two halves
%         L{1} = HALF_R(C);
%         R{1} = HALF_L(C);       
% end
% 3.2 cipher round 1 to 16
% load pairs
HWf = @(message) sum(message,2);
HDf = @(message1,message2) sum(xor(message1,message2),2);
HDf_w1 = @(A,B,w) (sum(and(A,xor(A,B)),2)*ones(size(w))+sum(xor(A,B)-and(A,xor(A,B)),2)*w); % w has to be a row vector of weights
HDf_w2 = @(A,B,w) (sum(and(A,xor(A,B)),2) * w +sum(xor(A,B)-and(A,xor(A,B)),2)*ones(size(w)));

C = IP(C);
R{2} = HALF_R(C);
L{2} = HALF_L(C);
R{1} = HALF_R(C);
L{1} = HALF_L(C);


randomkeys = linspace(0, 63, 64);
randomkeys = dec2bin(randomkeys(1,:)) - '0';
sbox_keyguess = zeros(64,48);

%r = 2; % the S-box being used
% Adding sbox keyguesses to offsets in the sbox_keyguess matrix so all
% sboxes can be done.
for r=1:8
    sbox_keyguess(:,1+(r-1)*6:r*6) = randomkeys;
end

i = 1;

% Create HDS 3d matrix for traces x guesses x sboxes
HDS = zeros(length(C),64, 8);

% Create Weighted HDS 3d matrix for traces x guesses x sboxes
WHDS = zeros(length(C), 64, 8);
WHDS_weight = 0.55;

TempR1 = R{i};
TempR2 = R{i+1};
TempL1 = L{i};
TempL2 = L{i+1};

% for n=1:64
%     for m=1:length(C)
%         expended_R = EF(TempR1(m,:)); % expended half key: 32-bit to 48-bit
%         mixed_R = KM(expended_R,sbox_keyguess(n,:)); % mixed with sub-key: 48-bit
%         substituted_R = SBOX(mixed_R); % substitution: 48-bit to 32-bit
%         permuted_R = PBOX(reshape(substituted_R',1,32)); % permutation: 32-bit
%         TempL(m,:) = xor(TempL1(m,:),permuted_R); % Feistel function: 32-bit
% %         HDS(m,n) = sum(xor(TempL(m,:),TempL2(m,:)))+sum(xor(TempR1(m,:),TempR2(m,:)));
%         HDS(m,n) = sum(xor(TempL(m,[9 17 23 31]),TempL2(m,[9 17 23 31])));
% 
%     end
%     L15s{n}=TempL;
%     clear TempL
% %     clear expended_R 
% end

for n=1:64
    for m=1:length(C)
        expended_R = EF(TempR1(m,:)); % expended half key: 32-bit to 48-bit
        mixed_R = KM(expended_R,sbox_keyguess(n,:)); % mixed with sub-key: 48-bit
        substituted_R = SBOX(mixed_R); % substitution: 48-bit to 32-bit
        permuted_R = PBOX(reshape(substituted_R',1,32)); % permutation: 32-bit
        TempL(m,:) = xor(TempL1(m,:),permuted_R); % Feistel function: 32-bit

        % Regular hamming distance for each sbox
%         HDS(m,n,1) = sum(xor(TempL(m,[9 17 23 31]),TempL2(m,[9 17 23 31])));
%         HDS(m,n,2) = sum(xor(TempL(m,[13 28 2 18]),TempL2(m,[13 28 2 18])));
%         HDS(m,n,3) = sum(xor(TempL(m,[24 16 30 6]),TempL2(m,[24 16 30 6])));
%         HDS(m,n,4) = sum(xor(TempL(m,[26 20 10 1]),TempL2(m,[26 20 10 1])));
%         HDS(m,n,5) = sum(xor(TempL(m,[8 14 25 3]),TempL2(m,[8 14 25 3])));
%         HDS(m,n,6) = sum(xor(TempL(m,[4 29 11 19]),TempL2(m,[4 29 11 19])));
%         HDS(m,n,7) = sum(xor(TempL(m,[32 12 22 7]),TempL2(m,[32 12 22 7])));
%         HDS(m,n,8) = sum(xor(TempL(m,[5 27 15 21]),TempL2(m,[5 27 15 21])));
        HDS(m,n,1) = HWf(substituted_R(1,:));
        HDS(m,n,2) = HWf(substituted_R(2,:));
        HDS(m,n,3) = HWf(substituted_R(3,:));
        HDS(m,n,4) = HWf(substituted_R(4,:));
        HDS(m,n,5) = HWf(substituted_R(5,:));
        HDS(m,n,6) = HWf(substituted_R(6,:));
        HDS(m,n,7) = HWf(substituted_R(7,:));
        HDS(m,n,8) = HWf(substituted_R(8,:));
        % Weighted HDS
        WHDS(m,n,1) = HDf_w2(TempL(m,[9 17 23 31]),TempL2(m,[9 17 23 31]), WHDS_weight);
        WHDS(m,n,2) = HDf_w2(TempL(m,[13 28 2 18]),TempL2(m,[13 28 2 18]), WHDS_weight);
        WHDS(m,n,3) = HDf_w2(TempL(m,[24 16 30 6]),TempL2(m,[24 16 30 6]), WHDS_weight);
        WHDS(m,n,4) = HDf_w2(TempL(m,[26 20 10 1]),TempL2(m,[26 20 10 1]), WHDS_weight);
        WHDS(m,n,5) = HDf_w2(TempL(m,[8 14 25 3]),TempL2(m,[8 14 25 3]), WHDS_weight);
        WHDS(m,n,6) = HDf_w2(TempL(m,[4 29 11 19]),TempL2(m,[4 29 11 19]), WHDS_weight);
        WHDS(m,n,7) = HDf_w2(TempL(m,[32 12 22 7]),TempL2(m,[32 12 22 7]), WHDS_weight);
        WHDS(m,n,8) = HDf_w2(TempL(m,[5 27 15 21]),TempL2(m,[5 27 15 21]), WHDS_weight);
        
    end
    L15s{n}=TempL;
    clear TempL
%     clear expended_R 
end

hamming = HDS;
weighted_hamming = WHDS;
% hamming = result;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                   END                                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
