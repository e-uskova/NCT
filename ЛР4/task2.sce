// Задание 2

// АЛЭ

clear
rand("seed", 42)

exec ann_ADALINE1.sce;
exec ann_ADALINE1_online.sce;

P = [1 2 -1 -2 -1 -2 1  2; 
     1 2  1  2  0 -1 0 -1]
T = [1 1 -1 -1 -1 -1 1 1; 
     1 1 1 1 -1 -1 -1 -1]
// 1 1 - 1ый класс, 0 1 - 2ой, 0 0 - 3ий, 1 0 - 4ый.

Z = [P; 1 1 1 1 1 1 1 1]
// корреляционная матрица
Q = size(Z, 2)
R = zeros(3, 3)
for q=1:Q
    R = R + Z(:,q) * Z(:,q)'
end
R = 1 / Q * R
disp(R)

// собственные числа гессиана
A = 2 * R
evals=spec(A)
disp(evals)

// максимальное устойчивое значение (alpha < 1 / lambda_max)
alpha_max = 1 / max(evals)
disp(alpha_max)

// Программа

/**/
clf
// отрисовка входных данных
scatter(P(1,1:2), P(2,1:2), , "blue", 0)
scatter(P(1,3:4), P(2,3:4), , "red", 0)
scatter(P(1,5:6), P(2,5:6), , "scilabgreen2", 0)
scatter(P(1,7:8), P(2,7:8), , "purple", 0)
zoom_rect([-3 -2 3 3])
xgrid
xtitle("Входные данные", "p1", "p2")

maxiter = 50
alpha = 0.19
[w1,b1,mse1] = ann_ADALINE1(P,T,alpha,maxiter,'zeros');
[w2,b2,mse2] = ann_ADALINE1_online(P,T,alpha,maxiter,'zeros');

disp(w1)
disp(b1)

/* графики обучения
clf
x_axis=1:maxiter;
plot(x_axis,mse1(x_axis),'r',x_axis,mse2(x_axis),'g');
xtitle('Средний квадрат ошибки', 'Эпоха','СКО');
legend('batch','online')
xgrid()
*/

// границы решения
/*
x = (-3:0.1:3)
y1 = (-b2(1)-w2(1, 1)*x)/(w2(1, 2)+0.000001)
y2 = (-b2(2)-w2(2, 1)*x)/w2(2, 2)
plot(x, y1, x, y2)
*/
