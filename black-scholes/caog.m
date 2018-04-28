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
%% 
%riskFreeRate=riskRate;
cInput=c2925;
%pInput=putMa;
cInput(:,1)=(320-(cInput(:,1)-34365))/365;
Tn=t+1;
leng=1000;
strike=2925;
%% calculate volatility using T/4 time window
for i=2:222
   cInput(i,4)=log(cInput(i,3)/cInput(i-1,3));
end

for i=57:222
   cInput(i,5)=std(cInput(2:i,4))*sqrt(252);
end
%TrueVolatility=cInput(:,5);
strikePrice=strike;
outPut(:,1)=cInput(57:222,1);
outPut(:,2)=cInput(57:222,5);
outPut(:,3)=zeros(166,1);
%outPut(:,2)=riskFreeRate*ones(166,1);% second colum free interest rate
outPut(:,4)=zeros(166,1);
outPut(:,5)=zeros(166,1);
outPut(:,6)=zeros(166,1);
oPut=[]
for i=strikePrice:25:(strikePrice+leng)
%% calculate theory price and volatility
%[Call,Put] = blsprice(Price,Strike,Rate,Time,Volatility)
[callPri,putPri] = blsprice(cInput(57:222,3),i,riskFreeRate,cInput(57:222,1),cInput(57:222,5));
outPut(:,3)=cInput(57:222,3)/i;
outPut(:,4)=callPri;
outPut(:,5)=putPri;
outPut(:,6)=strikePrice*ones(166,1);
oPut=[oPut;outPut];
end

%%
DataSet=oPut;
%%
index=randperm(length(DataSet))';
TrainSet=DataSet(index(1:0.75*length(DataSet)),:);
TestSet=DataSet(index(0.75*length(DataSet):length(DataSet)),:);
spread=1;
net = newrbe(TrainSet(:,1:3)',TrainSet(:,4:5)',0.25)
[output] = net(TestSet(:,1:3)');
[output2] = net(DataSet(1:166,1:3)');

%% plot
boxplot((output-TestSet(:,4:5)')')
max((output-TestSet(:,4:5)')')
figure()
plot(flip(DataSet(1:166,5)/2925))
hold on
plot(flip(output2(2,:)'/2925))
title(['Put Prices/Strike Prices of RBF model and Reality at Strike Price of ',num2str(strike)])
xlabel('Days to Maturity')
ylabel('Put Prices/Strike Prices')
legend('RBF model','Real Value')
hold off


%figure()
%boxplot((output(2,:)-TestSet(:,5)')')
figure()
[output2] = net(TrainSet(:,1:3)');
boxplot((output2-TrainSet(:,4:5)')')