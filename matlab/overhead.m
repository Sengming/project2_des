%% init
clear; clc; close all;

addpath('./library')
addpath('./testing')

addpath('./dataproc')
addpath('./keyguess')

addpath('./matfiles')
addpath('./results')


%% The Comparison of Models

disp('Overhead Measurement');

load ./matfiles/CorrData

nTraces = 100:10:1000;
nTrials = 1000;

SBOX_num = 2;

for m=1:8

correct_count_normal_matrix = zeros(nTrials,length(nTraces));
correct_count_weighted_matrix = zeros(nTrials,length(nTraces));

for n=1:length(nTraces)
    n
    m
    correct_count_normal = zeros(nTrials,1);
    correct_count_weighted = zeros(nTrials,1);
    for Trial = 1:nTrials
        Reduced_set = randperm(length(hamming),nTraces(n));
%         Reduced_set = randi(1000,1,nTraces(n));
        
        P_Reduced = P_shifted(Ind_sample,Reduced_set)';
        HD_Reduced = hamming(Reduced_set,:,m);
        WHD_Reduced = weighted_hamming(Reduced_set,:,m);
        
        Gcorr_sol = corr(HD_Reduced,P_Reduced);
        Gcorr_sol_weighted = corr(WHD_Reduced,P_Reduced);
        
        [~,Ind_cor] = max(Gcorr_sol);
        [~,Ind_cor_we] = max(Gcorr_sol_weighted);
        
        correct_count_normal(Trial) = Ind_cor==Correct_GuessNos(m);
        correct_count_weighted(Trial) = Ind_cor_we==Correct_GuessNos(m);
        
    end
    correct_count_normal_matrix(:,n) = correct_count_normal;
    correct_count_weighted_matrix(:,n) = correct_count_weighted;
end

%%

A = sum(correct_count_normal_matrix);
B = sum(correct_count_weighted_matrix);
figure; plot(nTraces,A./10,'.b',nTraces,B./10,'.g')

end
