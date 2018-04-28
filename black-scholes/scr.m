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
t=floor(T/4)+1;
%% create volatility smile
VolaSmile(t,2925,riskFreeRate,c2925,p2925,1);
%riskFreeRate=riskRate;
timeWindow=t;
drawFlag=1
strike=2925;
cInput=c2925;
pInput=p2925;
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
%boxplot([Volatility],'Notch','on',)
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
%% plot box plot of the difference between theory and reality
figure()
boxplot([callsDiff,callsDiff2,callsDiff3,callsDiff4,callsDiff5,],'Notch','on','Labels',{'strike price 2925','strike price 3025','strike price 3125','strike price 3225','strike price 3325'})
hold on
title('Difference between real call price and theory call price')
xlabel('Different Strike Prices')
ylabel('Price Difference')
txt1 = ['mean is ',num2str(mean(callsDiff))];
txt2 = ['mean is ',num2str(mean(callsDiff2))];
txt3 = ['mean is ',num2str(mean(callsDiff3))];
txt4 = ['mean is ',num2str(mean(callsDiff4))];
txt5 = ['mean is ',num2str(mean(callsDiff5))];
text(1,-20,txt1,'FontSize',11)
text(2,-20,txt2,'FontSize',11)
text(3,-20,txt3,'FontSize',11)
text(4,-20,txt4,'FontSize',11)
text(5,-20,txt5,'FontSize',11)
x = 0:0.05:6;
y = x*0;
plot(x,y,'r--')
hold off
%% plot box plot of the difference between theory and reality
figure()
boxplot([putsDiff,putsDiff2,putsDiff3,putsDiff4,putsDiff5,],'Notch','on','Labels',{'strike price 2925','strike price 3025','strike price 3125','strike price 3225','strike price 3325'})
hold on
title('Difference between real put price and theory put price')
xlabel('Different Strike Prices')
ylabel('Price Difference')
txt1 = ['mean is ',num2str(mean(putsDiff))];
txt2 = ['mean is ',num2str(mean(putsDiff2))];
txt3 = ['mean is ',num2str(mean(putsDiff3))];
txt4 = ['mean is ',num2str(mean(putsDiff4))];
txt5 = ['mean is ',num2str(mean(putsDiff5))];
text(1,-40,txt1,'FontSize',11)
text(2,-40,txt2,'FontSize',11)
text(3,-40,txt3,'FontSize',11)
text(4,-40,txt4,'FontSize',11)
text(5,-40,txt5,'FontSize',11)
x = 0:0.05:6;
y = x*0;
plot(x,y,'r--')
hold off
%% plot box plot of the difference between theory and reality
figure()
boxplot([volaDiff,volaDiff2,volaDiff3,volaDiff4,volaDiff5,],'Notch','on','Labels',{'strike price 2925','strike price 3025','strike price 3125','strike price 3225','strike price 3325'})
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