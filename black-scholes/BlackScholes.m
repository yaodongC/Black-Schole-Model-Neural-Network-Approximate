function [callPri,callDif,putPri,putDif,Volatility ,TrueVolatility,VolatilityDif]=BlackScholes(timeWindow,strike,riskRate,callMa,putMa,drawFlag)
riskFreeRate=riskRate;
cInput=callMa;
pInput=putMa;
cInput(:,1)=(320-(cInput(:,1)-34365))/365;
Tn=timeWindow+1;
%% calculate volatility using T/4 time window
for i=2:222
   cInput(i,4)=log(cInput(i,3)/cInput(i-1,3));
end

for i=57:222
   cInput(i,5)=std(cInput(2:i,4))*sqrt(252);
end
TrueVolatility=cInput(:,5);
strikePrice=strike;
%% calculate theory price and volatility
%[Call,Put] = blsprice(Price,Strike,Rate,Time,Volatility)
[callPri,putPri] = blsprice(cInput(57:222,3),strikePrice,riskFreeRate,cInput(57:222,1),cInput(57:222,5));
%Volatility = blsimpv(Price,Strike,Rate,Time,Value)
Volatility = blsimpv(cInput(57:222,3),strikePrice,riskFreeRate,cInput(57:222,1),cInput(57:222,2));
%% calculate the difference between real and theory
callDif=cInput(57:222,2)-callPri;
putDif=pInput(57:222,2)-putPri;
VolatilityDif=TrueVolatility(57:222)-Volatility;
%% plot call's theory price and real price
if drawFlag==1
figure()
plot(callPri)
%title('Call Prices of theory and reality')
title(['Call Prices of Theory and Reality at Strike Price of ',num2str(strike)])
xlabel('days')
ylabel('Option Prices')
hold on
plot(cInput(57:222,2))
legend('Black-Scholes Model Call Price','Real Call Price')
hold off


%% plot put's theory price and real price
figure()
plot(putPri)
%title('Put Prices of theory and reality')
title(['Put Prices of Theory and Reality at Strike Price of ',num2str(strike)])
xlabel('days')
ylabel('Option Prices')
hold on
plot(pInput(57:222,2))
legend('Black-Scholes Model Put Price','Real Put Price')
hold off
%% plot volatility's theory price and real price
figure()
plot(Volatility,'.')
hold on
plot(TrueVolatility(57:222),'.')
%title('Call Prices of theory and reality')
title(['Implied Volatility and True Volatility at Strike Price of ',num2str(strike)])
xlabel('days')
ylabel('volatility rate')
hold off
legend('Implied Volatility','Real Volatility')
end
%% prepare data for neural network input
cInput(:,4)=strikePrice*ones(222,1);
cInput(:,2)=riskFreeRate*ones(222,1);% second colum free interest rate
cInput(:,6)=zeros(222,1);
cInput(:,7)=zeros(222,1);
cInput(57:222,6)=callPri;
cInput(57:222,7)=putPri;
cInput=cInput(57:222,:)
end