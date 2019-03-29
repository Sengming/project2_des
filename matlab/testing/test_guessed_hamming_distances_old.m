%% CPA for round 16
pkg load image
pkg load communications
clc;
hamming = get_guess_lr_hamming_distance();

save guess.mat hamming
