%%
%in_port=zeros(N,1);
in_port=out_port;
stocks_tr=stock3ReturnTr;
FTSE_tr= FTSE100ReturnTr;
Zero_ind = find(in_port == 0);
for i = 1:length(Zero_ind)
    I = Zero_ind(i)
    ind = Zero_ind
    ind(i) = []
    cvx_begin
        variable port(N) nonnegative
        minimise(norm(FTSE_tr - stocks_tr * port, 2))
        subject to
            port(ind) == 0;
            sum(port) == 1;
    cvx_end
    perf(I) = norm(FTSE_tr - stocks_tr * port, 2)
    internal_port(I,:) = port
end
j = find(perf == max(perf))
out_port = internal_port(j,:)