%% init
clear; close all; clc;

%% read CSVs
% dircsv = '../CSV';
% records = mycsv2mat(dircsv);

%% DEMO MAs

load WAVEMAT

disp(['Total of ',num2str(records),' power traces read'])
n=2;
mean = sum(T(n).data(:,2)) / length(T(n).data(:,2));
close all;
plot(T(n).data(:,1),T(n).data(:,2)-mean,'r'); hold on

[SMA,err] = sma(T(n).data(:,2)-mean,10);
plot(T(n).data(length(T(n).data(:,2)) - length(SMA)+1:end,1),SMA','g')


[EMA50,err] = ema(T(n).data(:,2)-mean,50);
plot(T(n).data(length(T(n).data(:,2)) - length(EMA50)+1:end,1),EMA50','b')

[EMA100,err] = ema(T(n).data(:,2)-mean,100);
plot(T(n).data(length(T(n).data(:,2)) - length(EMA100)+1:end,1),EMA100','k')

% legend('Power Trace','SMA','EMA50','EMA100')
% legend('Power Trace','EMA50','EMA100')

%% Find MAs

LL = [T.data];
Time = [LL(:,1:2:2*records)];
PT = [LL(:,2:2:2*records)];

SMA_PT = sma(PT,10);
EMA50_PT = ema(PT,50);
EMA100_PT = ema(PT,100);

[MP,MPI] = max(SMA_PT(2000:end,:));
MPI = MPI+1999+9;


DEMA =( EMA50_PT(1+end-length(EMA100_PT(:,1)):end,:)-EMA100_PT)>0;
tmp = size(LL);
nSamples = tmp(1);
DEMA = [false(nSamples-length(EMA100_PT(:,1)),records);DEMA];
M = [-1.*eye(nSamples-1),zeros(nSamples-1,1)] + [zeros(nSamples-1,1),eye(nSamples-1)];

%% Extract Round 16

N = [zeros(1,nSamples);M]*DEMA;
N = (N<0).*1;
plot(T(n).data(:,1),0.01.*N(:,1),'m')
legend('Power Trace','SMA','EMA50','EMA100','trig')

figure; hist(MPI)

Nind = (N'*diag( 1:nSamples))';
Nind = Nind(1:min(MPI),:);

Nindsorted = sort(Nind);

ins16end = Nindsorted(end,:);
ins16start = Nindsorted(end-1,:);

len16round = max(ins16end-ins16start);
ins16end = ins16start + len16round;

%% Prev round
% 
% ins16end = ins16start;
% ins16start = ins16start - len16round;

%% Next round
% 
% ins16start = ins16end;
% ins16end = ins16start + len16round;

%%
Time16round = Time(ins16start:ins16end,:);
PT16round = PT(ins16start:ins16end,:);

%%
clear n
n=randi(1000,1,10);
for i=1:10
figure;
plot(T(n(i)).data(:,1),T(n(i)).data(:,2),'r'); hold on
plot(Time16round(:,n(i)),PT16round(:,n(i)),'g.');
end

save Round16 Time16round PT16round T

clear

%% CPA for round 16
