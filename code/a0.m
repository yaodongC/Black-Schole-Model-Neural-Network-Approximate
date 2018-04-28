clear all
Returns      = [0.1 0.1];


Covariances = [ 0.005 0
                0 0.005];

portopt(Returns, Covariances,20)
rng('default')
Weights = rand(100, 2);
Total = sum(Weights, 1);     % Add the weights
Total = Total(:,ones(3,1));  % Make size-compatible matrix
Weights = Weights./Total;    % Normalize so sum = 1
[PortRisk, PortReturn] = portstats(Returns, Covariances, ...
                         Weights);
 
hold on
plot (PortRisk, PortReturn, '.r')
title('Mean-Variance Efficient Frontier and Random Portfolios')
hold off        
