%% import data from .mat
clear all
load priceAlphabet30.mat
load priceAlphabet30Name.mat
%% process data and calculate daily return
N=5;
M=100;
Nsets=1000;
NumPorts=20;
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

meanStock30=mean(stock30ReturnTr);
covStock30=cov(stock30ReturnTr);
%% compare mean-variance with 1/N strategy
for j=1:M
%% get 3 random stocks    
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
%disp(p);
MVWts(:,j) = estimateMaxSharpeRatio(p);
%plotFrontier(p, NumPorts);
%hold on
%% compute daily return and performance
%for i=1:Nsets
%    ExpReturn(:,i)=stock3ReturnTe*PWts(i,:)';
%    ExpReturn(:,i)=stock3ReturnTe*PWts(i,:)';
%end
%   sum(ExpReturn)
% Compute return on test set
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
%% use 1/N strategy
NWts=ones(N, 1) ./ N;
%% compute daily return and performance
NExpReturn2(j,:)=stock3ReturnTr*NWts;
%% compute daily return and performance
NExpReturn(j,:)=stock3ReturnTe*NWts;
% Compute mean and variance of return on test set
NperformMean(j)= mean(NExpReturn(j,:));
NperformVar(j) = var(NExpReturn(j,:));
NperformMean2(j)= mean(NExpReturn2(j,:));
NperformVar2(j) = var(NExpReturn2(j,:));
%Compute  returns the maximum potential loss in the value of a
%portfolio over one period of time (that is, monthly, quarterly, yearly,
%and so on) given the loss probability level.
NpotentialLoss(j) = portvrisk(NperformMean(j), NperformVar(j));
NpotentialLoss2(j) = portvrisk(NperformMean2(j), NperformVar2(j));
%Compute Sharpe ratio for one or more assets
SharpOnN(j) = sharpe(NExpReturn(j,:), riskFreeRate);
SharpOnN2(j) = sharpe(NExpReturn2(j,:), riskFreeRate);
%%
p2 = Portfolio('assetmean', meanStock3, 'assetcovar', covStock3, ...
'lowerbudget', 1, 'upperbudget', 1, 'lowerbound', 0, ...
'RiskFreeRate', riskFreeRate);
NoShortWts(:,j) = estimateMaxSharpeRatio(p2);
if M==1
[risk, ret] = estimatePortMoments(p, MVWts(:,j));
[risk2, ret2] = estimatePortMoments(p2, NoShortWts(:,j));
plotFrontier(p, NumPorts);
hold on
plotFrontier(p2, NumPorts);
plot(risk,ret,'*r');
plot(risk2,ret2,'*r');
%x=linspace(0,risk,20);
%y=SharpOnMV2(j)*x+(ret-SharpOnMV2(j)*risk)
%plot(x,y);
%x1=linspace(0,risk2,20);
%y1=SharpOnN2(j)*x1+(ret2-SharpOnN2(j)*risk2)
%plot(x1,y1);
legend('Mean-Variance strategy','Short sale-constrained strategy')
hold off
else
end
%% compute daily return and performance
NoShortExpReturn(j,:)=stock3ReturnTe*NoShortWts(:,j);
%% compute daily return and performance
NoShortExpReturn2(j,:)=stock3ReturnTr*NoShortWts(:,j);
% Compute mean and variance of return on test set
NoShortperformMean(j)= mean(NoShortExpReturn(j,:));
NoShortperformVar(j) = var(NoShortExpReturn(j,:));
NoShortperformMean2(j)= mean(NoShortExpReturn2(j,:));
NoShortperformVar2(j) = var(NoShortExpReturn2(j,:));
%Compute  returns the maximum potential loss in the value of a
%portfolio over one period of time (that is, monthly, quarterly, yearly,
%and so on) given the loss probability level.
NoShortpotentialLoss(j) = portvrisk(NoShortperformMean(j), NoShortperformVar(j));
NoShortpotentialLoss2(j) = portvrisk(NoShortperformMean2(j), NoShortperformVar2(j));
%Compute Sharpe ratio for one or more assets
SharpOnNoShort(j) = sharpe(NoShortExpReturn(j,:), riskFreeRate);
SharpOnNoShort2(j) = sharpe(NoShortExpReturn2(j,:), riskFreeRate);
end
%% plot comparison data
% Comparison of Mean of Daily Returns with Different Strategies
figure()
boxplot([MVperformMean',NoShortperformMean',NperformMean'],'Notch','on','Labels',{'Mean-Variance Strategy','No Short Sale Strategy','1/N Strategy'})
hold on
title('Comparison of Mean of Daily Returns')
xlabel('Different Strategies')
ylabel('Mean of Daily Returns')
x = 0:0.05:4;
y = x*0;
plot(x,y,'r--')
hold off
%min(MVperformMean)
%max(MVperformMean)
%quantile(MVperformMean,[.25 .5 .75])
mean(MVperformMean)
mean(NoShortperformMean)
mean(NperformMean)
% Comparison of variance of Daily Returns with Different Strategies
figure()
boxplot([MVperformVar',NoShortperformVar',NperformVar'],'Notch','on','Labels',{'Mean-Variance Strategy','No Short Sale Strategy','1/N Strategy'})
hold on
title('Comparison of variance of Daily Returns')
xlabel('Different Strategies')
ylabel('variance of Daily Returns')
x = 0:0.05:4;
y = x*0;
plot(x,y,'r--')
hold off
mean(MVperformVar)
mean(NoShortperformVar)
mean(NperformVar)
% Comparison of sharp ratio of Daily Returns with Different Strategies
figure()
boxplot([SharpOnMV',SharpOnNoShort',SharpOnN'],'Notch','on','Labels',{'Mean-Variance Strategy','No Short Sale Strategy','1/N Strategy'})
hold on
title('Comparison of Sharp Ratio of Daily Returns')
xlabel('Different Strategies')
ylabel('Sharp Ratio of Daily Returns')
x = 0:0.05:4;
y = x*0;
plot(x,y,'r--')
hold off
mean(SharpOnMV)
mean(SharpOnNoShort)
mean(SharpOnN)
% Comparison of Potential Loss of Daily Returns with Different Strategies
figure()
boxplot([MVpotentialLoss',NoShortpotentialLoss',NpotentialLoss'],'Notch','on','Labels',{'Mean-Variance Strategy','No Short Sale Strategy','1/N Strategy'})
hold on
title('Comparison of Value of Risk')
xlabel('Different Strategies')
ylabel('Potential Loss')
x = 0:0.05:4;
y = x*0;
plot(x,y,'r--')
hold off
mean(MVpotentialLoss)
mean(NoShortpotentialLoss)
mean(NpotentialLoss)
%%
aaaa=1
mean(MVperformMean2)
mean(NoShortperformMean2)
mean(NperformMean2)
mean(MVperformVar2)
mean(NoShortperformVar2)
mean(NperformVar2)
mean(SharpOnMV2)
mean(SharpOnNoShort2)
mean(SharpOnN2)
mean(MVpotentialLoss2)
mean(NoShortpotentialLoss2)
mean(NpotentialLoss2)



