%% import data from .mat
clear all
load priceAlphabet30.mat
load priceAlphabet30Name.mat
%% process data and calculate daily return
N=30;
M=100;
Nsets=100;
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
%%
Port_greed_N = GreedyForward(zeros(N,1), stock30ReturnTr,FTSE100ReturnTr);
Port_greed_N
%for i = 1:5
    Port_greed_N = GreedyForward(Port_greed_N, stock30ReturnTr, FTSE100ReturnTr);
%end
Port_greed_N
sum(Port_greed_N)