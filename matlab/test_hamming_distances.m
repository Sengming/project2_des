%% CPA for round 16

%load Round16

hamming = get_lr_hamming_distance();
%size(hamming)
%local_maxima = max(PT16round)';
%size(local_maxima)
%
%hd_average_map = zeros(32, 2);
%
%hamming_power_mapping = [hamming local_maxima];
%
%size(hamming_power_mapping)
%for i = 1:32
%  hd_average_map(i, 1) = i;
%  bucket_count = 0;
%  for j = 1:1000
%    if hamming_power_mapping(j, 1) == i
%        hd_average_map(i, 2) = hd_average_map(i, 2) + hamming_power_mapping(j, 2);
%        bucket_count = bucket_count + 1;
%    end
%  end
%  hd_average_map(i, 2) = hd_average_map(i,2)/bucket_count;
%end
%
%  hd_average_map
%  size(hd_average_map)
%
%plot(hd_average_map(:,1), hd_average_map(:,2))
%
load MAs
P = PT';
size(hamming)
size(P(1:1000, :))
Gcorr = corr(hamming,P(1:1000,:));
figure;plot(Gcorr);title('correct guess');xlabel('sample point');ylabel('correlation');
pause;
