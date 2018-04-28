function OpfeatureWeight = GreedyForward(featureWeight,featureSet,object)

N1= size(featureWeight,1);
%find features that are not selected yet
addFeatIndex=find(featureWeight==0);
exitsFeatIndex=find(featureWeight~=0);
% variable define
N2=length(addFeatIndex);
PerformM=zeros(1,N2);
weight=zeros(N1,N2);
%% begain selecting iteration
for i=1:N2
    % find index of features we do not need to compute this time
    otherIndex=addFeatIndex;
    otherIndex(i)=[];
    %otherIndex
    thisIndex=addFeatIndex(i);
    % find optimal weight
    cvx_begin quiet
        variable newFeatureWeight(N1)
        minimise(norm(object - featureSet * newFeatureWeight, 2))
        subject to
            sum(newFeatureWeight)==1
            newFeatureWeight(otherIndex) == 0
       
    cvx_end
    %claculate performance metrics
    PerformM(thisIndex)=abs(norm(object - featureSet * newFeatureWeight, 2));
    %save this weight
    weight(:,thisIndex)=newFeatureWeight;
end
%% 
PerformM(exitsFeatIndex)=1;

% find the best weight
% lower is better
optimal=find(PerformM==min(PerformM));

OpfeatureWeight=weight(:,optimal);

end
