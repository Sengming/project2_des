%% CPA for round 16

clear; close all; clc;

load Round16
% load MAs
new_PTASMA3 = sma(PT16round,3);
hamming = get_lr_hamming_distance();
% size(hamming)
% [local_maxima,I] = max(PT16round(84:91,:));
[local_maxima,I] = max(new_PTASMA3(50:120,:));
% local_maxima = max(PT16round(110:end,:))';
% local_maxima = max(SMA_PT16round(50:120,:))';
% size(local_maxima)

hd_average_map = zeros(32, 2);

HD_sets = unique(hamming);

for n=1:length(HD_sets)
    ind = find(hamming==HD_sets(n));
    PTmean(n) = mean(local_maxima(ind));
    A{n} = local_maxima(ind);
    nPT(n) = length(ind);
end

plotyy(HD_sets(3:18),PTmean(3:18),HD_sets(3:18),nPT(3:18))

% %%
% hamming_power_mapping = [hamming local_maxima];
% 
% 
% 
% %%
% 
% size(hamming_power_mapping)
% for i = 1:32
%   hd_average_map(i, 1) = i;
%   bucket_count = 0;
%   for j = 1:1000
%     if hamming_power_mapping(j, 1) == i
%         hd_average_map(i, 2) = hd_average_map(i, 2) + hamming_power_mapping(j, 2);
%         bucket_count = bucket_count + 1;
%     end
%   end
%   hd_average_map(i, 2) = hd_average_map(i,2)/bucket_count;
% end
% 
%   hd_average_map
%   size(hd_average_map)
% 
% plot(hd_average_map(:,1), hd_average_map(:,2))
