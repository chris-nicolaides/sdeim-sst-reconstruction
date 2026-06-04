function f = error_plot(T_ortho,T_qdeim,T_sdeim_opt,T_sdeim_RC,T_sdeim_lstm,T_test)
%ERROR_PLOT plots relative errors as a function of time
% 
% INPUTS:
% T_ortho: best-fit reconstruction
% T_qdeim: qdeim reconstruction
% T_sdeim_opt: optimal s-deim reconstruction
% T_sdeim_RC: RC s-deim reconstruction
% T_sdeim_lstm: lstm s-deim reconstruction
% T_test: True SST field (test data)
%
% OUTPUTS: 
% f: error plot

ortho_err_total = vecnorm(T_ortho - T_test)./vecnorm(T_test);
deim_err_total = vecnorm(T_qdeim - T_test)./vecnorm(T_test);
sdeim_opt_err_total = vecnorm(T_sdeim_opt - T_test)./vecnorm(T_test);
sdeim_RC_err_total = vecnorm(T_sdeim_RC - T_test)./vecnorm(T_test);
sdeim_lstm_err_total = vecnorm(T_sdeim_lstm - T_test)./vecnorm(T_test);


f = figure;
hold on
xlabel('Weeks', 'Interpreter','latex')
ylabel('Error', 'Interpreter','latex')
title("Reconstruction Errors Over Weeks", 'Interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex')
ylim([0 1])
xlim([0 57])
plot(1:57, deim_err_total, 'LineWidth', 2, 'Color', [0 0.5 0])
plot(1:57, sdeim_RC_err_total,'red', 'LineWidth', 2)
plot(1:57, sdeim_lstm_err_total, 'blue', 'LineWidth', 2)
plot(1:57, sdeim_opt_err_total, ':' ,'LineWidth', 2, 'Color', [0.5 0.5 0.5])
plot(1:57, ortho_err_total,'k--', 'LineWidth', 2)
fontsize(18, "points")
legend("Q-DEIM", "SDEIM w/ RC",  "SDEIM w/ LSTM", "S-DEIM, Opt", "Best Fit", 'Position', [0.55 0.6 0.1 0.1], 'Interpreter', 'latex', "Fontsize", 12)
box on
end