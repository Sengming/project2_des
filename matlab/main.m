%% init
clear; clc; close all;

addpath('./library')
addpath('./testing')

addpath('./dataproc')
addpath('./keyguess')

addpath('./matfiles')
addpath('./results')


%% The data is acquired in this section.

disp('Reading the Power Traces ...')

getdata; % read the CSV file in to matfiles

spotcheck; % plot 10 traces and show the extracted round


disp('Press any key to proceed..')
pause;

close all;

%% testing DES

%% calling CPA for finding the sample points

disp('Getting the sample point ...')

clear;
load ./matfiles/pairs
load ./matfiles/MAs

key = [0,1,1,0,1,0,1,1,0,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,1,1,0,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,1,1,0,1,1,0,0,1,0,0];

for i=1:length(M)
[C_fromDES(i,:), C_IP(i,:), permuted_R(i,:), substituted_R(i,:),mixed_R(i,:),subKeys(i,:),expended_R(i,:),Round15(i,:),HD_Round16_LRUpdate(i)] = myDESxor(M(i,:),'ENC',key);
end

HWf = @(message) sum(message,2);
HDf = @(message1,message2) sum(xor(message1,message2),2);
HDf_w1 = @(A,B,w) (sum(and(A,xor(A,B)),2)*ones(size(w))+sum(xor(A,B)-and(A,xor(A,B)),2)*w); % w has to be a row vector of weights
HDf_w2 = @(A,B,w) (sum(and(A,xor(A,B)),2) * w +sum(xor(A,B)-and(A,xor(A,B)),2)*ones(size(w)));

% test_DES;

[MP,MPI] = max(SMA_PT(2000:end,:));
MPI = MPI+1999+9;

Limit_left = MPI-3050;
Limit_right = MPI + 1800;

P_shifted = PT(Limit_left:Limit_right,:);

% P = PT';
P = P_shifted';
HD = HD_Round16_LRUpdate';

Gcorr = corr(HD,P);

figure; plot(Gcorr);
savefig('./results/SamplePoint.fig')
saveas(gcf,'./results/SamplePoint.pdf')

[Max_sample,Ind_sample] = max(Gcorr);

disp('Press any key to proceed..')
pause;

close all;

%% calling CPA to find the 6 bits of round16 key

disp('Getting key for 1st SBOX in round 16 ...')

close all;

[hamming, weighted_hamming, L15s] = get_guess_lr_hamming_distance2(C,M);

% P = PT(Ind_sample,:)';


Correct_GuessNos = [61    12    57    47    23    51    17    45];

P = P_shifted(Ind_sample,:)';

for num_sboxes = 1:8
    HD = hamming(:,:,num_sboxes);
    WHD = weighted_hamming(:,:,num_sboxes);

    Gcorr_sol = corr(HD,P);
    Gcorr_sol_weighted = corr(WHD,P);

    figure; plot(Gcorr_sol)
    hold on;
    plot(Gcorr_sol_weighted)
    plot(Correct_GuessNos(num_sboxes),Gcorr_sol_weighted(Correct_GuessNos(num_sboxes)),'+r')
    savefig(['./results/Corr_SBOX',num2str(num_sboxes),'.fig'])
    saveas(gcf,['./results/Corr_SBOX',num2str(num_sboxes),'.pdf'])

    disp(['Getting key for ',num2str(num_sboxes),'nd SBOX in round 16 ...'])

end

save ./matfiles/CorrData hamming weighted_hamming Ind_sample P_shifted Correct_GuessNos