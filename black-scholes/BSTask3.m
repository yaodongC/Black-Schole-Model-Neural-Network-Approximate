%% import data from .csv file
clear all
load c2925.mat
load c3025.mat
load c3125.mat
load c3225.mat
load c3325.mat
load p2925.mat
load p3025.mat
load p3125.mat
load p3225.mat
load p3325.mat
%% initial variables
T=222;
riskFree=0.06;
riskFreeRate = (1+riskFree)^(1/252) - 1;
t=floor(T/4)+1;
strike=3000;
%% monte carlo simulations
DataSet=MonteCarloBS(t,2525,riskFreeRate,c2925,1000);
DataSet2=MonteCarloBS(t,strike,riskFreeRate,c2925,25);
%% process train and test data
index=randperm(length(DataSet))';
TrainSet=DataSet(index(1:0.75*length(DataSet)),:);
TestSet=DataSet(index(0.75*length(DataSet):length(DataSet)),:);
%% configuration and training of RBF
spread=1;
net = newrbe(TrainSet(:,1:3)',TrainSet(:,4:7)',1)
[output] = net(TestSet(:,1:3)');
outputOption = (output(1:2,:)./TestSet(:,8)').^2;
[output2] = net(DataSet2(:,1:3)');
outputOption2 = (output2(1:2,:)./DataSet2(:,8)').^2;
%% configuration and training of RBF V.2
spread=1;
net2 = newrbe([TrainSet(:,1)';TrainSet(:,2)'],TrainSet(:,4:7)',1)
[output21] = net2([TestSet(:,1)';TestSet(:,2)']);
outputOption21 = (output21(1:2,:)./TestSet(:,8)').^2;
%% plot comparison between two models
realCall=((TestSet(:,4)'./TestSet(:,8)').^2);
realPut=((TestSet(:,5)'./TestSet(:,8)').^2);
real=[realCall;realPut];
figure();
boxplot([(outputOption(1,:)-realCall)',(outputOption21(1,:)-realCall)'],'Notch','on','Labels',{'With Volatility','Without Volatility'})
hold on
title('Square Error of Call Price of the Different RBF Model')
xlabel('Different Objection Strategies')
ylabel('MSE')
txt1 = ['mean is ',num2str(mean(outputOption(1,:)-realCall))];
txt2 = ['mean is ',num2str(mean(outputOption21(1,:)-realCall))];
text(1,-0.01,txt1,'FontSize',11)
text(2,-0.01,txt2,'FontSize',11)
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
figure();
boxplot([(outputOption(2,:)-realPut)',(outputOption21(2,:)-realPut)'],'Notch','on','Labels',{'With Volatility','Without Volatility'})
hold on
title('Square Error of Put Price of the Different RBF Model')
xlabel('Different Objection Strategies')
ylabel('MSE')
txt1 = ['mean is ',num2str(mean(outputOption(2,:)-realPut))];
txt2 = ['mean is ',num2str(mean(outputOption21(2,:)-realPut))];
text(1,-0.01,txt1,'FontSize',11)
text(2,-0.01,txt2,'FontSize',11)
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
%% plot Put Prices/Call Prices of RBF model and Reality 
figure()
plot(flip(DataSet2(1:166,5)));
hold on
plot(flip(output2(2,1:166)'));
title(['Put Prices/Call Prices of RBF model and Reality at Strike Price of ',num2str(strike)])
xlabel('Days to Maturity')
ylabel('Put Prices/Strike Prices')
legend('RBF model','Real Value')
hold off
%% plot MSE of option price
%realCall=((TestSet(:,4)'./TestSet(:,8)').^2);
%realPut=((TestSet(:,5)'./TestSet(:,8)').^2);
%real=[realCall;realPut];
figure();
boxplot([(outputOption-real)'],'Notch','on','Labels',{'Call Option','Put Option'})
hold on
title('Square Error of option price of the RBF model')
xlabel('call and put options')
ylabel('MSE')
txt1 = ['mean is ',num2str(mean(outputOption(1,:)-real(1,:)))];
txt2 = ['mean is ',num2str(mean(outputOption(2,:)-real(2,:)))];
text(1,-0.001,txt1,'FontSize',11)
text(2,-0.001,txt2,'FontSize',11)
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
%% plot error of delta
figure();
boxplot([(output(3:4,:)-TestSet(:,6:7)')'],'Notch','on','Labels',{'Call Delta','Put Delta'})
hold on
title('Error of Delta of the RBF model')
xlabel('call and put options')
ylabel('Error')
txt1 = ['mean is ',num2str(mean(output(3,:)-TestSet(:,6)'))];
txt2 = ['mean is ',num2str(mean(output(4,:)-TestSet(:,7)'))];
text(1,-0.01,txt1,'FontSize',11)
text(2,-0.01,txt2,'FontSize',11)
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off





