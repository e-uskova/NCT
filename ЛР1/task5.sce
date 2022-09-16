// Задание 5
// Вычислить 3 значения функции, построить график

function res = f(x, y)
    res = 4 * x .* y - cos((%e .^ (-y) - %e .^ x) ./ (%e .^ (-x) + %e .^ y)) .^ 2
endfunction

x = [0.1 0.7 0.8]
y = [0.3 0.7 0.2]

res = f(x, y)

disp(x)
disp(y)
disp(res)

clf()
fplot3d(0:0.1:1, 0:0.1:1, f)
xtitle("Функция f(x, y)")
xgrid

// scatter3d(x, y, res, 30, "r", marker=0)
