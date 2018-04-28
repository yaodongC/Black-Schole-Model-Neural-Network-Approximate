function [ out_port, j, perf, internal_port  ] = greedy( in_port, stocks_tr, FTSE_tr )
% greedy(zeros(30,1), stocks_tr, FTSE_tr)
NAssets = size(stocks_tr,2);
Zero_ind = find(in_port == 0)
NoneZero=find(in_port ~= 0)
perf=zeros(1,length(Zero_ind));

for i = 1:length(Zero_ind)
    I = Zero_ind(i)
    ind = Zero_ind;
    ind(i) = [];
    ind
    cvx_begin quiet
        variable port(NAssets) %nonnegative
        minimise(norm(FTSE_tr - stocks_tr * port, 2))
        subject to
            port(ind) == 0;
            sum(port) == 1;
    cvx_end

    perf(I) = abs(norm(FTSE_tr - stocks_tr * port, 2))
    internal_port(I,:) = port
end
perf(1,NoneZero)=1
j = find(perf == min(perf))
out_port = internal_port(j,:)

