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
[calls,callsDiff,puts,putsDiff,impliVolatility,truVolatility,volaDiff]=BlackScholes(t,2925,riskFreeRate,c2925,p2925,1);
[calls2,callsDiff2,puts2,putsDiff2,impliVolatility2,truVolatility2,volaDiff2]=BlackScholes(t,3025,riskFreeRate,c3025,p3025,1);
[calls3,callsDiff3,puts3,putsDiff3,impliVolatility3,truVolatility3,volaDiff3]=BlackScholes(t,3125,riskFreeRate,c3125,p3125,1);
[calls4,callsDiff4,puts4,putsDiff4,impliVolatility4,truVolatility4,volaDiff4]=BlackScholes(t,3225,riskFreeRate,c3225,p3225,1);
[calls5,callsDiff5,puts5,putsDiff5,impliVolatility5,truVolatility5,volaDiff5]=BlackScholes(t,3325,riskFreeRate,c3325,p3325,1);

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