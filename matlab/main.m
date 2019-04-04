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
[C_fromDES(i,:), Round15(i,:), HD_Round16_LRUpdate(i)] = myDES(M(i,:),'ENC',key);
end

% test_DES;

P = PT';
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

[result, L15s] = get_guess_lr_hamming_distance2(C,M);

P = PT(Ind_sample,:)';
HD = result(:,:,1);


Gcorr_sol1=corr(HD,P);
figure; plot(sum(Gcorr_sol1,2))
savefig('./results/Corr_SBOX1.fig')
saveas(gcf,'./results/Corr_SBOX1.pdf')

disp('Getting key for 2nd SBOX in round 16 ...')

P = PT(Ind_sample,:)';
HD = result(:,:,2);

Gcorr_sol2=corr(HD,P);
figure; plot(sum(Gcorr_sol2,2))
savefig('./results/Corr_SBOX2.fig')
saveas(gcf,'./results/Corr_SBOX2.pdf')

disp('Getting key for 3rd SBOX in round 16 ...')

P = PT(Ind_sample,:)';
HD = result(:,:,3);

Gcorr_sol3=corr(HD,P);
figure; plot(sum(Gcorr_sol3,2))
savefig('./results/Corr_SBOX3.fig')
saveas(gcf,'./results/Corr_SBOX3.pdf')

disp('Getting key for 4th SBOX in round 16 ...')

P = PT(Ind_sample,:)';
HD = result(:,:,4);

Gcorr_sol4=corr(HD,P);
figure; plot(sum(Gcorr_sol4,2))
savefig('./results/Corr_SBOX4.fig')
saveas(gcf,'./results/Corr_SBOX4.pdf')

disp('Getting key for 5th SBOX in round 16 ...')

P = PT(Ind_sample,:)';
HD = result(:,:,5);

Gcorr_sol5=corr(HD,P);
figure; plot(sum(Gcorr_sol5,2))
savefig('./results/Corr_SBOX5.fig')
saveas(gcf,'./results/Corr_SBOX5.pdf')

disp('Getting key for 6th SBOX in round 16 ...')

P = PT(Ind_sample,:)';
HD = result(:,:,6);

Gcorr_sol6=corr(HD,P);
figure; plot(sum(Gcorr_sol6,2))
savefig('./results/Corr_SBOX6.fig')
saveas(gcf,'./results/Corr_SBOX6.pdf')


disp('Getting key for 7th SBOX in round 16 ...')

P = PT(Ind_sample,:)';
HD = result(:,:,7);

Gcorr_sol7=corr(HD,P);
figure; plot(sum(Gcorr_sol7,2))
savefig('./results/Corr_SBOX7.fig')
saveas(gcf,'./results/Corr_SBOX7.pdf')

disp('Getting key for 8th SBOX in round 16 ...')

P = PT(Ind_sample,:)';
HD = result(:,:,8);

Gcorr_sol8=corr(HD,P);
figure; plot(sum(Gcorr_sol8,2))
savefig('./results/Corr_SBOX8.fig')
saveas(gcf,'./results/Corr_SBOX8.pdf')