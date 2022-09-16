// Задание 3
// Построить графики активационных функций и их производных

//exec("poslin.sce")

x = (-2:0.01:2)
y_logsig = ann_logsig_activ(x)
y_poslin = poslin(x)

clf
subplot(121)
plot2d(x, y_logsig, rect=[-2 0 2 1], style=17)
plot2d(x, y_poslin, rect=[-2 0 2 1], style=23)
xgrid
xtitle("Activation functions", "x", "y")
legend("logsig", "poslin", 4)

// производные
function y = d_poslin(x)
    y = zeros(x)
    for i=1:length(y)
        if x(i) >= 0 then
            y(i) = 1
        end
    end
endfunction

function y=d_logsig(x)
    y = ann_logsig_activ(x) .* (1 - ann_logsig_activ(x))
endfunction

y_d_logsig = d_logsig(x)
y_d_poslin = d_poslin(x)

subplot(122)
plot2d(x, y_d_logsig, style=17)
plot2d(x, y_d_poslin, style=23)
xgrid
xtitle("Derivative of activation functions", "x", "y")
legend("d_logsig", "d_poslin", 4)

