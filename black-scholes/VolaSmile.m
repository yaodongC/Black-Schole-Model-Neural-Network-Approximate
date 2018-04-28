function VolaSmile(timeWindow,strike,riskRate,callMa,putMa,drawFlag)
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
%% calculate theory volatility
%Volatility = blsimpv(Price,Strike,Rate,Time,Value)
i=1;
for strikePrice=strike:100:(strike+1000)
i=i+1;
Volatility(:,i) = blsimpv(cInput(57:222,3),strikePrice,riskFreeRate,cInput(57:222,1),cInput(57:222,2));
end
%% plot call's theory price and real price
if drawFlag==1
%% plot box plot of volatility smile
figure()
%boxplot([Volatility],'Notch','on','Labels',{'strike price 2425','strike price 2525','strike price 2625','strike price 2725','strike price 2825','strike price 2925','strike price 3025','strike price 3125','strike price 3225','strike price 3325'})
boxplot(Volatility)
hold on
title('Difference between real volatility and theory volatility')
xlabel('Different Strike Prices')
ylabel('Price Difference')
txt1 = ['mean is ',num2str(mean(volaDiff))];
txt2 = ['mean is ',num2str(mean(volaDiff2))];
txt3 = ['mean is ',num2str(mean(volaDiff3))];
txt4 = ['mean is ',num2str(mean(volaDiff4))];
txt5 = ['mean is ',num2str(mean(volaDiff5))];
text(1,-0.15,txt1,'FontSize',11)
text(2,-0.15,txt2,'FontSize',11)
text(3,-0.15,txt3,'FontSize',11)
text(4,-0.15,txt4,'FontSize',11)
text(5,-0.15,txt5,'FontSize',11)
x = 0:0.05:6;
y = x*0;
plot(x,y,'r--')
hold off
end

end