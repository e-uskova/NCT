// Задание 3
// Отобразить входные точки, обучить персептрон, отобразить границы решения,
// протестировать решение для входных данных и доп. точек из областей

clear
rand("seed", 42)


P = [1 2 -1 -2 -1 -2 1  2; 
     1 2  1  2  0 -1 0 -1]
T = [1 1 0 0 0 0 1 1; 
     1 1 1 1 0 0 0 0]
// 1 1 - 1ый класс, 0 1 - 2ой, 0 0 - 3ий, 1 0 - 4ый.

/*
clf
// отрисовка входных данных
scatter(P(1,1:2), P(2,1:2), , "blue", 0)
scatter(P(1,3:4), P(2,3:4), , "red", 0)
scatter(P(1,5:6), P(2,5:6), , "scilabgreen2", 0)
scatter(P(1,7:8), P(2,7:8), , "purple", 0)
zoom_rect([-3 -2 3 3])
xgrid
xtitle("Персептрон", "p1", "p2")
*/

// обучение персептрона
[w, b] = ann_PERCEPTRON(P, T);
disp(w)
disp(b)

function c = get_class_color(A)
    // функция для соотнесения цвета классу
    if A == [1; 1] then
        c = "blue"
    elseif A == [0; 1] then
        c = "red"
    elseif A == [0; 0] then
        c = "scilabgreen2"
    elseif A == [1; 0] then
        c = "purple"
    else
        c = "black"
    end
endfunction

// запуск сети на обучающем наборе
res = ann_PERCEPTRON_run(P, w, b);
disp(res)

clf
// отрисовка обучающих точек
for j=1:size(P,2)
    scatter(P(1,j), P(2,j), , get_class_color(res(:, j)), 0)
end

// тестовые точки
test = [6 * rand(1, 5) - 3; 5 * rand(1, 5) - 2]
disp(test)

// запуск сети на тестовом наборе
res_test = ann_PERCEPTRON_run(test, w, b);

// отрисовка тестовых точек
for j=1:size(test,2)
    scatter(test(1,j), test(2,j), , get_class_color(res_test(:, j)))
end

xtitle("Классификация", "p1", "p2")
zoom_rect([-3 -2 3 3])
xgrid

// границы решения
x = (-3:0.1:3)
y1 = (-b(1)-w(1, 1)*x)/w(1, 2)
y2 = (-b(2)-w(2, 1)*x)/w(2, 2)
plot(x, y1, x, y2)

// границы классов
/*
yr1 = (-0.5 * x + 0.5)
yr2 = (-0.75 * x + 0.5)
plot(x, yr1, '--k', x, yr2, '--k')

yb1 = (0.5 * x + 0.5)
yb2 = (0.75 * x + 0.5)
plot(x, yb1, '--k', x, yb2, '--k')

plot([-3 3], [1 1], '--k', [-3 3], [0 0], '--k')
plot([-1 -1], [-2 3], '--k', [1 1], [-2 3], '--k')


plot([-3 -1 -2 -3], [2 1 2 2.75], 'r')
plot([-3 -1 -2 -3], [-1 0 -1 -1.75], 'g')
plot([3 1 2 3], [2 1 2 2.75], 'b')
plot([3 1 2 3], [-1 0 -1 -1.75], 'm')


// Возможные решения
subplot(131)
plot([-3 3], [0.5 0.5], [0 0], [-2 3])
scatter(P(1,1:2), P(2,1:2), , "blue", 0)
scatter(P(1,3:4), P(2,3:4), , "red", 0)
scatter(P(1,5:6), P(2,5:6), , "green", 0)
scatter(P(1,7:8), P(2,7:8), , "purple", 0)
xgrid
xtitle("Возможное решение 1", "p1", "p2")

subplot(132)
plot([-3 3], [0.5 0.5], [-2 2], [-2 3])
scatter(P(1,1:2), P(2,1:2), , "blue", 0)
scatter(P(1,3:4), P(2,3:4), , "red", 0)
scatter(P(1,5:6), P(2,5:6), , "green", 0)
scatter(P(1,7:8), P(2,7:8), , "purple", 0)
xgrid
xtitle("Возможное решение 2", "p1", "p2")

subplot(133)
plot([-3 3], [1 -0.2], [-1 0], [3 -2])
scatter(P(1,1:2), P(2,1:2), , "blue", 0)
scatter(P(1,3:4), P(2,3:4), , "red", 0)
scatter(P(1,5:6), P(2,5:6), , "green", 0)
scatter(P(1,7:8), P(2,7:8), , "purple", 0)
xgrid
xtitle("Возможное решение 3", "p1", "p2")
*/



