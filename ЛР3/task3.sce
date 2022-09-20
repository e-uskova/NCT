// Задание 3
// Отобразить входные точки, обучить персептрон, отобразить границы решения,
// протестировать решение для входных данных и доп. точек из областей

clear

P = [1 2 -1 -2 -1 -2 1 2; 1 2 1 2 0 -1 0 -1]
T = [1 1 1 1 0 0 0 0; 1 1 0 0 0 0 1 1]' 
// первый ноль - ниже, второй - слева
// 1 1 - 1ый класс, 1 0 - 2ой, 0 0 - 3ий, 0 1 - 4ый.

clf
// отрисовка входных данных
scatter(P(1,1:2), P(2,1:2), , "blue", 0)
scatter(P(1,3:4), P(2,3:4), , "red", 0)
scatter(P(1,5:6), P(2,5:6), , "green", 0)
scatter(P(1,7:8), P(2,7:8), , "magenta", 0)
zoom_rect([-3 -2 3 3])
xgrid
xtitle("Входные данные", "p1", "p2")

// обучение персептрона
[w, b] = ann_PERCEPTRON(P, T');
disp(w)
disp(b)

res = ann_PERCEPTRON_run(P, w, b);

disp(res)

test = [2.5 0.3 -3 -0.5 -0.3; 0.8 -1.5 0.7 0.2 2.5]

function c = get_class_color(A)
    colors = ["blue", "red", "green", "magenta"]
    if A == [1; 1] then
        c = colors(1)
    elseif A == [1; 0] then
        c = colors(2)
    elseif A == [0; 0] then
        c = colors(3)
    elseif A == [0; 1] then
        c = colors(4)
    end
endfunction

res = ann_PERCEPTRON_run(test, w, b);

disp(res)

//clf
for j=1:size(test,2)
    scatter(test(1,j), test(2,j), , get_class_color(res(:, j)))
end

zoom_rect([-3 -2 3 3])
xgrid

x = (-3:0.1:3)
y1 = (-b(1)-w(1, 1)*x)/w(1, 2)
plot2d(x, y1)

y2 = (-b(2)-w(2, 1)*x)/w(2, 2)
plot2d(x, y2)
