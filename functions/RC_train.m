function [Wout,rr]=RC_train(Xin,Xout,A,Win,b,alph,lamd)

k=size(Xin,2);
m=size(A,1);

R=nan(m,k);
rr = randn(m,1);

for i = 1:k
    rr = (1-alph)*rr+alph*tanh(A*rr+Win*Xin(:,i)+b);
    R(:,i) = rr;
end

Wout=((R*R'+lamd*eye(m))\(R*Xout'))';

end