function [oPut]=MonteCarloBS(timeWindow,strike,riskRate,callMa,leng)
riskFreeRate=riskRate;
cInput=callMa;
%pInput=putMa;
cInput(:,1)=(320-(cInput(:,1)-34365))/365;
Tn=timeWindow+1;
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
outPut(:,7)=zeros(166,1);
outPut(:,8)=zeros(166,1);
oPut=[]
for i=strikePrice:25:(strikePrice+leng)
%% calculate theory price and volatility
%[Call,Put] = blsprice(Price,Strike,Rate,Time,Volatility)
[callPri,putPri] = blsprice(cInput(57:222,3),i,riskFreeRate,cInput(57:222,1),cInput(57:222,5));
%[CallDelta,PutDelta] = blsdelta(Price,Strike,Rate,Time,Volatility)
[callDelta,putDelta] = blsdelta(cInput(57:222,3),i,riskFreeRate,cInput(57:222,1),cInput(57:222,5));
outPut(:,3)=cInput(57:222,3)/i;
outPut(:,4)=callPri;
outPut(:,5)=putPri;
outPut(:,6)=callDelta;
outPut(:,7)=putDelta;
outPut(:,8)=i*ones(166,1);
oPut=[oPut;outPut];
end
end