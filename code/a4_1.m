%% import data from .mat
clear all
load priceAlphabet30.mat
load priceAlphabet30Name.mat
%% process data and calculate daily return
N=3;
M=200;
Nsets=100;
NumPorts=30;
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
FTSE100ReturnPer=FTSE100Return./stockShift(2:761,1:30);
%% divid into training and test set
rowN=length(stock30ReturnPer)
stock30ReturnTr=stock30ReturnPer(1: floor(rowN/2),:);
stock30ReturnTe=stock30ReturnPer(floor(rowN/2):rowN,:);
FTSE100ReturnTr=FTSE100ReturnPer(1: floor(rowN/2),:);
FTSE100ReturnTe=FTSE100ReturnPer(floor(rowN/2):rowN,:);
%% get 3 random stocks
meanStock30=mean(stock30ReturnTr);
covStock30=cov(stock30ReturnTr);
%% compare mean-variance with 1/N strategy
for j=1:M
index=randperm(30,N)
for i=1:N
stock3ReturnTr(:,i)=stock30ReturnTr(:,index(i));
stock3ReturnTe(:,i)=stock30ReturnTe(:,index(i));
meanStock3(i)=meanStock30(index(i));
end
covStock3=cov(stock3ReturnTr);
%% calculate the optimal potfolio
p = Portfolio('assetmean', meanStock3, 'assetcovar', covStock3, ...
'lowerbudget', 1, 'upperbudget', 1, 'lowerbound', -1, ...
'RiskFreeRate', riskFreeRate);
MVWts(:,j) = estimateMaxSharpeRatio(p);
%plotFrontier(p, NumPorts);
[risk, ret] = estimatePortMoments(p, MVWts(:,j));
%hold on
%plot(risk,ret,'*r');

%% compute daily return and performance
%for i=1:Nsets
%    ExpReturn(:,i)=stock3ReturnTe*PWts(i,:)';
%    ExpReturn(:,i)=stock3ReturnTe*PWts(i,:)';
%end
%   sum(ExpReturn)
ExpReturn(j,:)=stock3ReturnTe*MVWts(:,j);
% Compute return on test set
ExpReturn2(j,:)=stock3ReturnTr*MVWts(:,j);
% Compute mean and variance of return on test set
MVperformMean(j)= mean(ExpReturn(j,:));
MVperformVar(j) = var(ExpReturn(j,:));
MVperformMean2(j)= mean(ExpReturn2(j,:));
MVperformVar2(j) = var(ExpReturn2(j,:));
%Compute  returns the maximum potential loss in the value of a
%portfolio over one period of time (that is, monthly, quarterly, yearly,
%and so on) given the loss probability level.
MVpotentialLoss(j) = portvrisk(MVperformMean(j), MVperformVar(j));
MVpotentialLoss2(j) = portvrisk(MVperformMean2(j), MVperformVar2(j));
%Compute Sharpe ratio for one or more assets
SharpOnMV(j) = sharpe(ExpReturn(j,:), riskFreeRate);
SharpOnMV2(j) = sharpe(ExpReturn2(j,:), riskFreeRate);
%% sharp ratio of train set
%if M==1
%x=linspace(0,risk,20);
%y=SharpOnMV2(j)*x+(ret-SharpOnMV2(j)*risk)
%plot(x,y);
% sharp ratio of test set
%x=linspace(0,risk,20);
%y=SharpOnMV(j)*x+(MVperformMean-SharpOnMV(j)*MVperformVar)
%plot(x,y);
%hold off
%end
%% use 1/N strategy
NWts=[1/3;1/3;1/3];
%% compute daily return and performance
NExpReturn(j,:)=stock3ReturnTe*NWts;
% Compute mean and variance of return on test set
NperformMean(j)= mean(NExpReturn(j,:));
NperformVar(j) = var(NExpReturn(j,:));
%Compute  returns the maximum potential loss in the value of a
%portfolio over one period of time (that is, monthly, quarterly, yearly,
%and so on) given the loss probability level.
NpotentialLoss(j) = portvrisk(NperformMean(j), NperformVar(j));
%Compute Sharpe ratio for one or more assets
SharpOnN(j) = sharpe(NExpReturn(j,:), riskFreeRate);
end
%% plot comparison data
% Comparison of Mean of Daily Returns with Different Strategies
boxplot([MVperformMean',NperformMean'],'Notch','on','Labels',{'Mean-Variance Strategy','1/N Strategy'})
hold on
title('Comparison of Mean of Daily Returns')
xlabel('Different Strategies')
ylabel('Mean of Daily Returns')
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
min(MVperformMean)
max(MVperformMean)
quantile(MVperformMean,[.25 .5 .75])
mean(MVperformMean)
% Comparison of variance of Daily Returns with Different Strategies
figure()
boxplot([MVperformVar',NperformVar'],'Notch','on','Labels',{'Mean-Variance Strategy','1/N Strategy'})
hold on
title('Comparison of variance of Daily Returns')
xlabel('Different Strategies')
ylabel('variance of Daily Returns')
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
% Comparison of sharp ratio of Daily Returns with Different Strategies
figure()
boxplot([SharpOnMV',SharpOnN'],'Notch','on','Labels',{'Mean-Variance Strategy','1/N Strategy'})
hold on
title('Comparison of Sharp Ratio of Daily Returns')
xlabel('Different Strategies')
ylabel('Sharp Ratio of Daily Returns')
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off
% Comparison of Potential Loss of Daily Returns with Different Strategies
figure()
boxplot([MVpotentialLoss',NpotentialLoss'],'Notch','on','Labels',{'Mean-Variance Strategy','1/N Strategy'})
hold on
title('Comparison of Potential Loss of Daily Returns')
xlabel('Different Strategies')
ylabel('Potential Loss')
x = 0:0.05:3;
y = x*0;
plot(x,y,'r--')
hold off


