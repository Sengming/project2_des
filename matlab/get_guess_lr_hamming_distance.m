function [result] = get_guess_lr_hamming_distance()
% This function gets the hamming distances at the 16th round LR register update
% and outputs them as a vector of size nT (number of traces).
% Input expected is the csv file we're getting the plaintext and ciphertext
% from. This will be nT * 2 where the 2 columns are plaintext - ciphertext pairs.

  %p_c_pairs = csvread(filename)
  
  %cipher_b = dec2bin(p_c_pairs(:,2));
  %plain_b = dec2bin(p_c_pairs(:,1));
  %p_c_pairs(1:10, :)

  %Final permutation in reverse is just the intiial permutation %
  FP_R = @(message) message([58	50	42	34	26	18	10	2 ...
                        60	52	44	36	28	20	12	4 ...
                        62	54	46	38	30	22	14	6 ...
                        64	56	48	40	32	24	16	8 ...
                        57	49	41	33	25	17	9	1 ...
                        59	51	43	35	27	19	11	3 ...
                        61	53	45	37	29	21	13	5 ...
                        63	55	47	39	31	23	15	7]);
  HALF_L = @(message) message(1:32);
  HALF_R = @(message) message(33:64);
  EF = @(halfMessage) [halfMessage([32,4:4:28])',(reshape(halfMessage,4,8))',halfMessage([5:4:29,1])'];
  PBOX = @(halfMessage) halfMessage(:,[16  7 20 21  29 12 28 17 ... 
                                    1 15 23 26   5 18 31 10 ...
                                    2  8 24 14  32 27  3  9 ...
                                   19 13 30  6  22 11  4  25]);

  PBOX_R = @(halfMessage) halfMessage(:,[9 17 23 31 13 28 2 18 ...
                                      24 16 30 6 26 20 10 1 ...
                                      8 14 25 3 4 29 11 19 ...
                                      32 12 22 7 5 27 15 21]); 
                                  
  FP = @(message) message(:, [40	8	48	16	56	24	64	32 ...
                        39	7	47	15	55	23	63	31 ...
                        38	6	46	14	54	22	62	30 ...
                        37	5	45	13	53	21	61	29 ...
                        36	4	44	12	52	20	60	28 ...
                        35	3	43	11	51	19	59	27 ...
                        34	2	42	10	50	18	58	26 ...
                        33	1	41	9	49	17	57	25]);

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
    %ST{i} = mat2cell(blkproc(st{i},[1,1],@(x) de2bi(x,4,'left-msb')),ones(1,4),ones(1,16)*4);
    ST{i} = mat2cell(blockproc(st{i},[1,1],@(x) de2bi(x,4,'left-msb')),ones(1,4),ones(1,16)*4);
end
% 1.5 define subsitution function (SBOX)
SUBS = @(expandedHalfMessage,blkNo) ST{blkNo}{bi2de(expandedHalfMessage(1, [1,6]),'left-msb')+1,bi2de(expandedHalfMessage(1,[2:5]),'left-msb')+1};
 
  % Load in M = plaintext mssages in bits, C = encrypted messages in bits, 
  % a = strings of plaintext%
%%
  load pairs
 
%%
  unpermuted_c = zeros(1000, 64);
  input_r = zeros(1000, 32);
  % Run everything through reverse of the final permutation % 
  for i = 1:1000
  	unpermuted_c(i, :) = FP_R(C(i, :));
    input_r(i, :) = HALF_R(unpermuted_c(i, :));
  end
    % Debug prints
    %permuted = C(1000, :)
    %input = input_r(1000, :)
    %unpermuted = unpermuted_c(1000, :)
    %size(unpermuted_c)
    %size(input_r)

    % Perform expansion permutation in the input_r:
    % EF generates an 8x6 matrix of the 48 values. So, we create 8 sbox input matrices of size
    % 10000x6 for each sbox plaintext input. This will later be xor-ed with our input guess.

    sbox1_plaintext = zeros(1000, 6);
    sbox2_plaintext = zeros(1000, 6);
    sbox3_plaintext = zeros(1000, 6);
    sbox4_plaintext = zeros(1000, 6);
    sbox5_plaintext = zeros(1000, 6);
    sbox6_plaintext = zeros(1000, 6);
    sbox7_plaintext = zeros(1000, 6);
    sbox8_plaintext = zeros(1000, 6);

    % More debug prints.
    %sbox1_plaintext
    %size(expanded_input_r);
    %expanded_input_r;

    % First ,we need to figure out the first Sbox's output bits by moving cryptext backwards through the FP and feistel
    unpermuted_c_l = unpermuted_c(:, 1:32);
    unpermuted_c_r = unpermuted_c(:, 33:64);
    unpermuted_c_r_hamming_bits = unpermuted_c_r([32,1,2,3,4,5]);
    before_dbox = PBOX_R(unpermuted_c_l);

    sbox1_outputs = before_dbox(:, 1:4);

    possible_sbox_inputs = zeros(4,6,length(sbox1_plaintext));
    for i = 1:length(sbox1_plaintext)
        sbox1_lookups(i, :) = bi2de(sbox1_outputs(i, :), 'left-msb');
        [sbox_row, sbox_column] = find(st{1}==sbox1_lookups(i,:));

        sbox_row = sbox_row - 1;
        sbox_column = sbox_column - 1;
        binary_rows = de2bi(sbox_row, 2,'left-msb');
        binary_columns = de2bi(sbox_column, 4,'left-msb');
        possible_sbox_inputs(:,:,i) = [binary_rows(:, 1) binary_columns(:,:) binary_rows(:,2)];
    end
    %possible_sbox_inputs is goign to be 4x6x1000
    sbox_keyguess = linspace(0, 63, 64);
    sbox_keyguess = dec2bin(sbox_keyguess(1,:)) - '0';

    hamming_distances = zeros(256, 1, 1000);

    possible_sbox_plaintexts = zeros(256, 6, 1000);

    % xor operations backwards are xors
    for i = 1:length(sbox1_plaintext)
        for j = 1:4
           for k = 1:64
               possible_sbox_plaintexts(k+((j-1)*64), :, i) = xor(possible_sbox_inputs(j, :, i), sbox_keyguess(k, :));
               hamming_distances(k+((j-1)*64), :, i)  = sum(xor(unpermuted_c_r_hamming_bits, possible_sbox_plaintexts(k+((j-1)*64), :, i))')';
           end
        end
    end

    result = hamming_distances;

%    % At this point we have our plaintext inputs to the sbox. The next step is to generate the s-box input keyguesses
%    % sbox guesses are 64x6 in size. From this point on we are only targeting sbox 1, replicate later.
%    sbox_keyguess = linspace(0, 63, 64);
%    sbox_keyguess = dec2bin(sbox_keyguess(1,:)) - '0';
%    %size(sbox_keyguess)
%    %size(sbox1_plaintext(1,:))
%    % XOR these guesses with the first 6 bits from plaintext to get our final sbox inputs
%
%    % This part is done for one sbox, one trace.
%%     sbox_guessed_inputs = zeros(64, 6);
%
%for m = 1:length(sbox1_plaintext)
%    for i = 1:64
%        sbox_guessed_inputs(i, :) = xor(sbox1_plaintext(m,:), sbox_keyguess(i, :));
%        sbox_guessed_outputs(i, :) = SUBS(sbox_guessed_inputs(i, :),1);
%    end
%
%
%    % Now we have an array of 64x1 for hamming weight guesses
%    input_P = [sbox_guessed_outputs zeros(64, 28)];
%%     input_P = [ones(64,4) zeros(64,28)];
%    FP_INPUT = [PBOX(input_P) zeros(64, 32)];
%    Cypherguesss = FP(FP_INPUT);
%    Bitposaffected = [60 62];
%    input_r_repeate64 = ones(64,2)*diag([input_r(m,Bitposaffected-32)]);
%    Cypherguesss2 = Cypherguesss(:,Bitposaffected);
%    HD1SBOX(m,:)  = sum(xor(input_r_repeate64,Cypherguesss(:,Bitposaffected))');
%    m
%end 
%    result = HD1SBOX;

end
