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

P = PT(Ind_sample-5:Ind_sample+5,:)';
HD = result;


Gcorr_sol=corr(HD,P);
figure; plot(sum(Gcorr_sol,2)./10)
savefig('./results/Corr_SBOX1.fig')
saveas(gcf,'./results/Corr_SBOX1.pdf')






