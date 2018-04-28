clear all
Returns      = [0.1 0.20 0.15];


Covariances = [ 0.005  -0.010  0.004
                -0.010  0.040   -0.002
                0.004  -0.002   0.023 ];
frontcon(Returns, Covariances, 20)
portopt(Returns, Covariances, 20)
rng('default')
for i=1:30
[PortRisk, PortReturn, PWts] = NaiveMV(Returns, Covariances, 1)
[PortRisk1, PortReturn1, PWts1] = NaiveCVXMV(Returns, Covariances, 1)
diff(i,:)=PWts-PWts1;
end
boxplot(diff)

%plot (PortRisk, PortReturn, '.r')
%hold on
%plot (PortRisk1, PortReturn1, '.b')
%title('Mean-Variance Efficient Frontier and Random Portfolios')
%hold off     



