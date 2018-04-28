clear all
Returns      = [0.1 0.20 0.15];


Covariances = [ 0.005  -0.010  0.004
                -0.010  0.040   -0.002
                0.004  -0.002   0.023 ];


[PortRisk, PortReturn, PWts] = NaiveCVXMV(Returns, Covariances, 100)
[PortRisk1, PortReturn1, PWts1] = NaiveCVXMV(Returns, Covariances, 100)
portopt(Returns, Covariances, 20)
rng('default')
hold on
plot (PortRisk, PortReturn, '.r')
plot (PortRisk, PortReturn, '.g')
title('Mean-Variance Efficient Frontier and Random Portfolios')
legend('MATLAB financial toolbox', 'NaiveMV algorithm', 'NaiveMV algorithm using CVX')
hold off     

    
