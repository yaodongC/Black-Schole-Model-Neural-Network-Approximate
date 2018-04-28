function [PRisk, PRoR, PWts] = NaiveCVXMV(ERet, ECov, NPts)
ERet = ERet(:); % makes sure it is a column vector
NAssets = length(ERet); % get number of assets
% vector of lower bounds on weights
V0 = zeros(NAssets, 1);
% row vector of ones
V1 = ones(1, NAssets);
% set medium scale option
options = optimset('LargeScale', 'off');
% Find the maximum expected return
cvx_begin
    variable MaxReturnWeights(NAssets) nonnegative
    maximise(MaxReturnWeights' * ERet)
    subject to
        MaxReturnWeights' * ones(NAssets,1) == 1;
cvx_end
MaxReturn = MaxReturnWeights' * ERet;
cvx_begin
MaxReturn = MaxReturnWeights' * ERet;
% Find the minimum variance return

    variable MinVarWeights(NAssets) nonnegative
    minimise(MinVarWeights' * ECov * MinVarWeights) 
    subject to
        MinVarWeights' * ones(NAssets,1) == 1
cvx_end

MinVarReturn = MinVarWeights' * ERet;
MinVarStd = sqrt(MinVarWeights' * ECov * MinVarWeights);
% check if there is only one efficient portfolio
if MaxReturn > MinVarReturn
RTarget = linspace(MinVarReturn, MaxReturn, NPts);
NumFrontPoints = NPts;
else
RTarget = MaxReturn;
NumFrontPoints = 1;
end
% Store first portfolio
PRoR = zeros(NumFrontPoints, 1);
PRisk = zeros(NumFrontPoints, 1);
PWts = zeros(NumFrontPoints, NAssets);
PRoR(1) = MinVarReturn;
PRisk(1) = MinVarStd;
PWts(1,:) = MinVarWeights(:)';
% trace frontier by changing target return
VConstr = ERet';
A = [V1 ; VConstr ];
B = [1 ; 0];
for point = 2:NumFrontPoints
B(2) = RTarget(point);
Weights = quadprog(ECov,V0,[],[],A,B,V0,[],[],options);
PRoR(point) = dot(Weights, ERet);
PRisk(point) = sqrt(Weights'*ECov*Weights);
PWts(point, :) = Weights(:)';
end