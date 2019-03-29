% Let us say that we have power traces from a device that that constantly
% writes some value to a register, where each sample point of the trace 
% corresponds to the power consumed during the register update.
%
% Furthermore, let's assume that the power consumed is related to the HD of
% initial and final state of the register by P = a*HD+e where 'a' is a
% constant and 'e' is i.i.d (identically and independently distributed)
% gaussian noise with mean zero and std deviation of one (e ~ N(0,1))
%
% We have guesses for the content of the register at the initial and final
% states that we wish to verity using CPA

% number of traces: each sample point corresponds to register update
nT = 1000; %num of traces
lT = 10000; %length of trace (lT register writes)

% correct hamming distances: trace-by-sample point
HD = randi([0 8],nT,lT); %registers are 8-bit => 8

% power consumed in register updates: trace-by-sample point
a = 0.1;
e = randn(nT,lT);
P = a*HD + e;

figure;plot(P(1,:))
xlabel('sample point');ylabel('Power consumed [W]');title('Power Trace of Device Updating Register (each sample point corresponds to an update)')
figure;plot(HD(1,:));axis([0 lT 0 10]);
xlabel('sample point');ylabel('Hamming distance');title('Hamming Distance for Device Updating Register (each sample point corresponds to an update)')


%%
% Let's assume that we have a correct guess for a single register update 
% for each trace but don't know where it's located in the trace; find it
spg = 5500; %sample point of correct guess in each trace
G = HD(:,spg); %our guess

% do correlation across every sample point of every trace
Gcorr = corr(G,P);
% plot correlation
figure;plot(Gcorr);title('correct guess');xlabel('sample point');ylabel('correlation');
[~,I] = max(Gcorr); %sample point with max correlation

if I == spg
    disp('unknown location, correct guess: guess verified');
else
    disp('cpa failure');
end

%%
% What if our guess is incorrect?
G = randi([0 8],nT,1); %generate random guesses

% do correlation across every sample point of every trace
Gcorr = corr(G,P);
% plot correlation
figure;plot(Gcorr);title('incorrect guess');xlabel('sample point');ylabel('correlation');
[~,I] = max(Gcorr); %sample point with max correlation

if I == spg
    disp('guess verified');
else
    disp('known location, incorrect guess: cpa failure');
end

%%
% Now we assume that we know the sample point corresponding to the reigister
% update but we don't have the correct guess; so we guess all and take
% the max correlation
% G = randi([0 8],nT,10e3); %generate random guesses (let's say 10e3; 80e3 for all possible guesses)
G = randi([0 8],nT,2^8); %generate all combination of guesses (I'm lazy so do this randomly...doesn't result in all combination of guesses)
gc = 10; %make our tenth guess the correct one
G(:,gc) = HD(:,spg); 
Gcorr = corr(G,P(:,spg));

figure;plot(Gcorr);title('2^8 guesses, one correct');xlabel('guess');ylabel('correlation');
[~,I] = max(Gcorr); %sample point with max correlation

if I == gc
    disp('known location, all combination of guesses: guess verified');
else
    disp('cpa failure');
end

%%
% Now we only have a range of possible sample points; use same guesses as
% last time
spr = 10; %range around correct location (+/-)
spF = spg-10; spL = spg+10; %look to verify guess in this range
Gcorr = corr(G,P(:,spF:spL));

figure;plot(Gcorr);title('2^8 guesses, one correct; only have range for correct sample point');xlabel('guess');ylabel('correlation');
[~,Isp] = max(max(Gcorr)); %find sample point with max correlation; use to verify guess
[~,I] = max(Gcorr(:,Isp)); %see which guess gives max correlation

if I == gc && spF+Isp-1 == spg
    disp('known range, all combination of guesses: guess verified');
else
    disp('cpa failure');
end