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

%% weight for two portfolio
rng('default')
Weights2 = rand(100, 2);
Total2 = sum(Weights2, 2);     % Add the weights
Total2 = Total2(:,ones(2,1));  % Make size-compatible matrix
Weights2 = Weights2./Total2;    % Normalize so sum = 1
%% AC portfolios

portopt(Returns3, Covariances3,20)

[PortRisk3, PortReturn3] = portstats(Returns3, Covariances3, ...
                         Weights2);

plot (PortRisk3, PortReturn3, '.b')

%% weight for two portfolio
rng('default')
Weights2 = rand(100, 2);
Total2 = sum(Weights2, 2);     % Add the weights
Total2 = Total2(:,ones(2,1));  % Make size-compatible matrix
Weights2 = Weights2./Total2;    % Normalize so sum = 1
%% BC portfolios


portopt(Returns1, Covariances1,20)

[PortRisk1, PortReturn1] = portstats(Returns1, Covariances1, ...
                         Weights2);

plot (PortRisk1, PortReturn1, '.y')
legend('efficient frontier of assets A B C','random portfolios of assets A B C','efficient frontier of assets A B','random portfolios of assets A B','efficient frontier of assets A C','random portfolios of assets A C','efficient frontier of assets B C','random portfolios of assets B C')
hold off 