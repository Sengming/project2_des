function [result] = get_lr_hamming_distance()
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
 
  % Load in M = plaintext mssages in bits, C = encrypted messages in bits, 
  % a = strings of plaintext%
  load pairs
 
  unpermuted_c = zeros(length(C), 64);
  input_r = zeros(length(C), 32);
  % Run everything through reverse of the final permutation % 
  for i = 1:length(C)
  	unpermuted_c(i, :) = FP_R(C(i, :));
    input_r(i, :) = HALF_R(unpermuted_c(i, :));
  end
    % Debug prints
    %permuted = C(1000, :)
    %input = input_r(1000, :)
    %unpermuted = unpermuted_c(1000, :)
    %size(unpermuted_c)
    %size(input_r)


  % Now we can find the hamming distance between this right 32 bits and the 
  % 32 bits on the right from the final crypt
%   distances = pdist2(input_r, C(:, 1:32), 'hamming');
%  distances = sum(xor(unpermuted_c, C)')';
   distances = sum(xor(input_r, C(:,33:end))')';

  result = distances;

end
