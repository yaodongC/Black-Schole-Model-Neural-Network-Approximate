%% import data from .mat
clear all
load priceAlphabet30.mat
load priceAlphabet30Name.mat
%% process data and calculate daily return
N=3;
Nsets=100;
riskFree=-0.0032971
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
plot(meanStock30)
index=randperm(30,N)
for i=1:N
stock3ReturnTr(:,i)=stock30ReturnTr(:,index(i));
stock3ReturnTe(:,i)=stock30ReturnTe(:,index(i));
meanStock3(i)=meanStock30(index(i));
end
covStock3=cov(stock3ReturnTr)
covStock30=cov(stock30ReturnTr);
%% calculate the optimal potfolio
riskFreeRate = (1+riskFree)^(1/252) - 1;
p = Portfolio('assetmean', meanStock3, 'assetcovar', covStock3, ...
'lowerbudget', 1, 'upperbudget', 1, 'lowerbound', 0, ...
'RiskFreeRate', riskFreeRate);
MVWts = estimateMaxSharpeRatio(p);
%% compute daily return and performance
%for i=1:Nsets
%    ExpReturn(:,i)=stock3ReturnTe*PWts(i,:)';
%    ExpReturn(:,i)=stock3ReturnTe*PWts(i,:)';
%end
%   sum(ExpReturn)
% Compute return on test set
ExpReturn=stock3ReturnTe*MVWts;
% Compute mean and variance of return on test set
MVperformMean= mean(ExpReturn)
MVperformVar = var(ExpReturn)
%Compute  returns the maximum potential loss in the value of a
%portfolio over one period of time (that is, monthly, quarterly, yearly,
%and so on) given the loss probability level.
MVpotentialLoss = portvrisk(MVperformMean, MVperformVar)
%Compute Sharpe ratio for one or more assets
SharpOnMV = sharpe(ExpReturn, riskFreeRate)
%% use 1/N strategy
NWts=[1/3;1/3;1/3];
%% compute daily return and performance
NExpReturn=stock3ReturnTe*NWts;
% Compute mean and variance of return on test set
NperformMean= mean(NExpReturn)
NperformVar = var(NExpReturn)
%Compute  returns the maximum potential loss in the value of a
%portfolio over one period of time (that is, monthly, quarterly, yearly,
%and so on) given the loss probability level.
NpotentialLoss = portvrisk(NperformMean, NperformVar)
%Compute Sharpe ratio for one or more assets
SharpOnN = sharpe(NExpReturn, riskFreeRate)
