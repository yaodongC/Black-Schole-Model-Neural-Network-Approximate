%% import data from .mat
clear all
load priceAlphabet30.mat
load priceAlphabet30Name.mat
%% process data and calculate daily return
N=30;
M=100;
Nsets=100;
NaiveWeight1=zeros(1,N);
NaiveWeight2=zeros(1,N);
riskFree=-0.0032971
riskFreeRate = (1+riskFree)^(1/252) - 1;
stock=flip(Price);
stock30=stock(:,1:30);
FTSE100=stock(:,31);
stockShift=circshift(stock,1);
stockReturn=stockShift-stock;
% calculate daily change
stock30Return=stockReturn(2:761,1:30);
FTSE100Return=stockReturn(2:761,31);
% calculate daily change in percentage
stock30ReturnPer=stock30Return./stockShift(2:761,1:30);
FTSE100ReturnPer=FTSE100Return./stockShift(2:761,31);
%% divid into training and test set
rowN=length(stock30ReturnPer);
stock30ReturnTr=stock30ReturnPer(1: floor(rowN/2),:);
stock30ReturnTe=stock30ReturnPer(floor(rowN/2):rowN,:);
FTSE100ReturnTr=FTSE100ReturnPer(1: floor(rowN/2),:);
FTSE100ReturnTe=FTSE100ReturnPer(floor(rowN/2):rowN,:);
% mean and variance
meanStock30=mean(stock30ReturnTr);
covStock30=cov(stock30ReturnTr);
meanFTSE100=mean(FTSE100ReturnTr);
covFTSE100=cov(FTSE100ReturnTr);
%% b. sparse index tracking
%tau = 0.13;
tau = 0.17;
weightIndex=7
cvx_begin
variable PortoRegu(1,N) nonnegative
minimize(power(2,norm( FTSE100ReturnTr - stock30ReturnTr*PortoRegu', 2)) +  ...
        tau * norm( PortoRegu, 1 ) )
%subject to
%PortoRegu * ones(N,1) == 1
%PortoRegu > 0
%PortoRegu * meanStock3' ==  meanFTSE100
cvx_end
weightIndex = sum(PortoRegu > 0.0001)
sum(PortoRegu)
stockIndex=find(PortoRegu > 0.0001)
OptimalWeights=PortoRegu(find(PortoRegu > 0.0001))
PortoRegu=PortoRegu./sum(PortoRegu);
sum(PortoRegu)
NaiveWeight1(1,stockIndex)=1/weightIndex
%% a.greedy forward selection
greedWeights = GreedyForward(zeros(N,1), stock30ReturnTr,FTSE100ReturnTr);
%greedWeights
for i = 1:5
    greedWeights = GreedyForward(greedWeights, stock30ReturnTr, FTSE100ReturnTr);
end
%greedWeights
%sum(greedWeights);
weightIndex2 = sum(greedWeights > 0.0001)
stockGreedyIndex=find(greedWeights > 0)
OptimalGreedyWeights=greedWeights(find(greedWeights > 0))
NaiveWeight2(1,stockGreedyIndex)=1/weightIndex2
%% compute daily return and performance
j=1;
% Compute return on test set
ExpReturn(j,:)=stock30ReturnTe*PortoRegu';
ExpReturnNaive(j,:)=stock30ReturnTe*NaiveWeight1';
ExpReturnTr(j,:)=stock30ReturnTr*PortoRegu';
% Compute return on whole set
ExpWholReturn(j,:)=stock30ReturnPer*PortoRegu';
% Compute mean and variance of return on test set
MVperformMean(j)= mean(ExpReturn(j,:));
MVperformVar(j) = var(ExpReturn(j,:));
%Compute  returns the maximum potential loss in the value of a
%portfolio over one period of time (that is, monthly, quarterly, yearly,
%and so on) given the loss probability level.
MVpotentialLoss(j) = portvrisk(MVperformMean(j), MVperformVar(j));
%Compute Sharpe ratio for one or more assets
SharpOnMV(j) = sharpe(ExpReturn(j,:), riskFreeRate)
%% compute daily return and performance
% Compute return on test set
NExpReturn(j,:)=stock30ReturnTe*greedWeights;
ExpReturnNaive2(j,:)=stock30ReturnTe*NaiveWeight2';
NExpReturnTr(j,:)=stock30ReturnTr*greedWeights;
% Compute return on whole set
NExpWholReturn(j,:)=stock30ReturnPer*greedWeights;
% Compute mean and variance of return on test set
NperformMean(j)= mean(NExpReturn(j,:));
NperformVar(j) = var(NExpReturn(j,:));
%Compute  returns the maximum potential loss in the value of a
%portfolio over one period of time (that is, monthly, quarterly, yearly,
%and so on) given the loss probability level.
NpotentialLoss(j) = portvrisk(NperformMean(j), NperformVar(j));
%Compute Sharpe ratio for one or more assets
SharpOnN(j) = sharpe(NExpReturn(j,:), riskFreeRate)
SharpOnFTSE = sharpe(FTSE100ReturnPer, riskFreeRate)
%%
stockIndex1=find(PortoRegu > 0.0001)
stockIndex2=find(greedWeights~=0)
%%
plot(ExpWholReturn)
hold on
plot(NExpWholReturn)
plot(FTSE100ReturnPer')
hold off
title('Daily Returns of 3 years')
xlabel('Days')
ylabel('Daily Returns')
legend('Sparse Index Tracking','Greedy Index Tracking','FTSE100 Daily Retruns')
%%
figure()
plot(ExpReturn)
hold on
plot(NExpReturn)
plot(FTSE100ReturnTe')
hold off
title('Daily Returns of Test Data Set')
xlabel('Days')
ylabel('Daily Returns')
legend('Sparse Index Tracking','Greedy Index Tracking','FTSE100 Daily Retruns')
%%
figure()
boxplot([(FTSE100ReturnPer-ExpWholReturn'),(FTSE100ReturnPer-NExpWholReturn')],'Notch','on','Labels',{'Sparse Tracking Return','Greedy Tracking Return'})
hold on
title('Return difference between FTSE and subset on train data set')
xlabel('Different Strategies')
ylabel('Daily Returns')
txt1 = ['mean is ',num2str(mean((FTSE100ReturnPer-ExpWholReturn')))];
txt2 = ['mean is ',num2str(mean((FTSE100ReturnPer-NExpWholReturn')))];
text(1,-0.01,txt1,'FontSize',11)
text(2,-0.01,txt2,'FontSize',11)
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
%% histogram
figure()
histogram((FTSE100ReturnTe-ExpReturn'))
hold on
histogram((FTSE100ReturnTe-NExpReturn'))
hold off
title('Return difference between FTSE and subset on test data set')
xlabel('returns')
ylabel('number of instances')
legend('Sparse Index Tracking','Greedy Index Tracking')
%% plot comparison data
% Comparison of variance of Daily Returns with Different Strategies
figure()
boxplot([(FTSE100ReturnTr-NExpReturnTr'),(FTSE100ReturnTr-ExpReturnTr')],'Notch','on','Labels',{'Sparse Tracking Return','Greedy Tracking Return'})
hold on
title('Return difference between FTSE and subset on training data set')
xlabel('Different Strategies')
ylabel('Daily Returns')
txt1 = ['mean is ',num2str(mean((FTSE100ReturnTr-ExpReturnTr')))];
txt2 = ['mean is ',num2str(mean((FTSE100ReturnTr-NExpReturnTr')))];
text(1,-0.01,txt1,'FontSize',11)
text(2,-0.01,txt2,'FontSize',11)
var((FTSE100ReturnTr-ExpReturnTr'))
var((FTSE100ReturnTr-NExpReturnTr'))
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
%% plot comparison data
% Comparison of variance of Daily Returns with Different Strategies
figure()
boxplot([(FTSE100ReturnTe-ExpReturn'),(FTSE100ReturnTe-NExpReturn')],'Notch','on','Labels',{'Sparse Tracking Return','Greedy Tracking Return'})
hold on
title('Return difference between FTSE and subset on test data set')
xlabel('Different Strategies')
ylabel('Daily Returns')
txt1 = ['mean is ',num2str(mean((FTSE100ReturnTe-ExpReturn')))];
txt2 = ['mean is ',num2str(mean((FTSE100ReturnTe-NExpReturn')))];
text(1,-0.01,txt1,'FontSize',11)
text(2,-0.01,txt2,'FontSize',11)
var((FTSE100ReturnTe-ExpReturn'))
var((FTSE100ReturnTe-NExpReturn'))
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
%%
figure()
boxplot([(ExpReturn'),(NExpReturn'),FTSE100ReturnTe],'Notch','on','Labels',{'Sparse Tracking Return','Greedy Tracking Return','FTSE Return'})
hold on
title('Return of FTSE and two subsets on test data set')
xlabel('Different Strategies')
ylabel('Daily Returns')
txt1 = ['mean is ',num2str(mean(ExpReturn'))];
txt2 = ['mean is ',num2str(mean(NExpReturn'))];
txt3 = ['mean is ',num2str(mean(FTSE100ReturnTe))];
text(1,-0.01,txt1,'FontSize',11)
text(2,-0.01,txt2,'FontSize',11)
text(3,-0.01,txt3,'FontSize',11)
x = 0:0.05:4;
y = x*0;
plot(x,y,'r--')
hold off
%% plot comparison data 1/N naive
% Comparison of variance of Daily Returns with Different Strategies
figure()
boxplot([(FTSE100ReturnTe-ExpReturnNaive'),(FTSE100ReturnTe-ExpReturnNaive2')],'Notch','on','Labels',{'Sparse Tracking Return','Greedy Tracking Return'})
hold on
title('Return difference between FTSE and subset on test data set using 1/N weighting strategy')
xlabel('Different Strategies')
ylabel('Daily Returns')
txt1 = ['mean is ',num2str(mean((FTSE100ReturnTe-ExpReturnNaive')))];
txt2 = ['mean is ',num2str(mean((FTSE100ReturnTe-ExpReturnNaive2')))];
text(1,-0.01,txt1,'FontSize',11)
text(2,-0.01,txt2,'FontSize',11)
var((FTSE100ReturnTe-ExpReturnNaive'))
var((FTSE100ReturnTe-ExpReturnNaive2'))
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
%% histogram
figure()
histogram((FTSE100ReturnTe-ExpReturnNaive'))
hold on
histogram((FTSE100ReturnTe-ExpReturnNaive2'))
x = 0;
y = 0:80;
plot(x,y,'r--')
hold off
hold off
title('Return difference between FTSE and subset on test data set using 1/N weighting strategy')
xlabel('returns')
ylabel('number of instances')
legend('Sparse Index Tracking','Greedy Index Tracking')