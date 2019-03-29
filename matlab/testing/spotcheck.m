clear;

load ./matfiles/WAVEMAT
load ./matfiles/Round16
n=randi(records,1,10);
figure;
for i=1:length(n)
subplot(5,2,i)
plot(T(n(i)).data(:,1),T(n(i)).data(:,2),'r'); hold on
plot(Time16round(:,n(i)),PT16round(:,n(i)),'g.');

end

legend('Powertrace','Round16')
filename = ['./results/Spotcheck',num2str(i),'.fig'];
savefig(filename)
filename = ['./results/Spotcheck',num2str(i),'.pdf'];
saveas(gcf,filename)