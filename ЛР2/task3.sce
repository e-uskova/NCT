// Задание 3
// Построить графики активационных функций и их производных

clear

exec logsig.sce;
exec poslin.sce;
exec d_logsig.sce;
exec d_poslin.sce;

x = (-2:0.01:2)
y_logsig = ann_logsig_activ(x)
y_poslin = poslin(x)

clf
subplot(121)
plot2d(x, y_logsig, rect=[-2 0 2 1], style=17)
plot2d(x, y_poslin, rect=[-2 0 2 1], style=23)
xgrid
xtitle("Функции активации", "x", "y")
legend("logsig", "poslin", 4)

y_d_logsig = d_logsig(x)
y_d_poslin = d_poslin(x)

subplot(122)
plot2d(x, y_d_logsig, style=17)
plot2d(x, y_d_poslin, style=23)
xgrid
xtitle("Производные функций активации", "x", "y")
legend("d_logsig", "d_poslin", 4)

