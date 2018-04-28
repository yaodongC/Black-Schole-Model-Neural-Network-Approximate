%% import data from .csv file
%clear all
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
t=floor(T/4)+1
%% calculate volatility using T/4 time window
c2925(:,1)=(320-(c2925(:,1)-34365))/365;
 
for i=2:222
   c2925(i,4)=log(c2925(i,3)/c2925(i-1,3));
end

for i=57:222
   c2925(i,5)=std(c2925(2:i,4))*sqrt(252);
end
%% normalize
Max1=max(c2925(:,3))
Min1=min(c2925(:,3))
Rang1=Max1-Min1
Max2=max(c2925(:,5))
Min2=min(c2925(:,5))
Rang2=Max2-Min2
Mul=Max1/Max2;
c2925(:,6)=Min1;
c2925(57:222,6)=c2925(57:222,5)*Mul;
%% plot Asset value of term time
plot(c2925(:,3))
title('Asset value of term time')
xlabel('days')
ylabel('FTSE index')
hold on
plot(c2925(:,6))
title('volatility value of term time')
xlabel('days')
ylabel('FTSE index')
hold off
figure()
plot(c2925(57:222,5))
title('volatility value of term time')
xlabel('days')
ylabel('FTSE index')
%%
strike2925=2925*ones(222,1);
[Call,Put] = blsprice(c2925(57:222,3),strike2925(57:222),riskFreeRate,c2925(57:222,1),c2925(57:222,5))
%[Call,Put] = blsprice(Price,Strike,Rate,Time,Volatility)
figure()
plot(Call)
title('Asset value of term time')
xlabel('days')
ylabel('FTSE index')
hold on
plot(c2925(57:222,2))
legend('Black-Scholes Model Call Price','Real Call Price')
