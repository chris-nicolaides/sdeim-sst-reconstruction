function Wr = generate_Wr(Nr, Wr_density)

Wr = sprand(Nr, Nr, Wr_density);
Wr = full(Wr);
Wr(Wr ~= 0) = Wr(Wr ~= 0) - 0.5;
Wr = 0.9*Wr/max(abs(eig(Wr)));

end