clear all
Returns       = [0.1 0.20 0.15];
Returns1      = [0.1 0.2];
Returns2      = [0.2 0.15];
Returns3      = [0.1 0.15];

Covariances = [ 0.005  -0.010  0.004
                -0.010  0.040   -0.002
                0.004  -0.002   0.023 ];
Covariances1 =  [0.005 -0.01; -0.01 0.04];
Covariances2 =  [0.04 -0.002; -0.002 0.023];
Covariances3 =  [0.005 0.004;  0.004 0.023];     
%% three asset model
portopt(Returns, Covariances,20)
rng('default')
Weights = rand(100, 3);
Total = sum(Weights, 2);     % Add the weights
Total = Total(:,ones(3,1));  % Make size-compatible matrix
Weights = Weights./Total;    % Normalize so sum = 1
[PortRisk, PortReturn] = portstats(Returns, Covariances, ...
                         Weights);
hold on
plot (PortRisk, PortReturn, '.r')
title('Mean-Variance Efficient Frontier and Random Portfolios')

%% weight for two portfolio
rng('default')
Weights2 = rand(100, 2);
Total2 = sum(Weights2, 2);     % Add the weights
Total2 = Total2(:,ones(2,1));  % Make size-compatible matrix
Weights2 = Weights2./Total2;    % Normalize so sum = 1
%% AB portfolios


portopt(Returns2, Covariances2,20)

[PortRisk2, PortReturn2] = portstats(Returns2, Covariances2, ...
                         Weights2);

plot (PortRisk2, PortReturn2, '.g')
title('Mean-Variance Efficient Frontier and Random Portfolios')
%% weight for two portfolio
rng('default')
Weights2 = rand(100, 2);
Total2 = sum(Weights2, 2);     % Add the weights
Total2 = Total2(:,ones(2,1));  % Make size-compatible matrix
Weights2 = Weights2./Total2;    % Normalize so sum = 1
