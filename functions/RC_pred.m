function Xpred=RC_pred(Xin,A,Win,b,alph,Wout,R)

k=size(Xin,2);
n=size(Wout,1);
m=size(A,1);

Xpred=nan(n,k);

for i = 1:k
    R = (1-alph)*R+alph*tanh(A*R+Win*Xin(:,i)+b);
    Xpred(:,i) = Wout*R;
end


end