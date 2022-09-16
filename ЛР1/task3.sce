// Задание 3
// Вычислить значения функции, построить график

N = 30
x = linspace(0, 1, N)

res = f(x)

disp(x)
disp(res)

plot2d(x, res)
xgrid
xtitle("Функция f(x)", "x", "f(x)")
