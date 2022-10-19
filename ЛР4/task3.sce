// Задание 3

// 

clear
exec("ann_ADALINE1_predict.sce");
exec("ann_ADALINE1.sce");
rand("seed", 42)

//Значения параметров генератора L, F, Fc выбирайте из таблицы 4.1;
//Параметры:
L=20;
F=0.01;
Fc=F*8;
//Генератор полигармонического входного сигнала;
td=1/(20*F);
t=0:td:2/F;
fi=(2*%pi*F).*t;
Y=0;
for i=1:L
 Y=Y+(Fc)/(Fc+2*%pi*F*i)*sin(fi*i);
end
T=Y;

/*
clf
plot(t, T)
*/

// Получение значений вектора p
T=Y;
D=2;
P = [];
for cnt = 1:D // для каждого выхода линии задержки
 //формируем строки матрицы P из отсчетов Y
 // очередная строка P – сдвинутая на один отсчет копия предыдущей строки
 P = [P; Y(cnt:$-D+cnt-1)];
end
//формируем вектор целевых значений c длиной, равной длине строки из P
T = T(1:$-D+1); 

// Теперь, используя формулы (4.26)-(4.27), можно вычислить значения R,h и c
Q = size(P, 2)
R = zeros(2, 2)
for q=1:Q
    R = R + P(:,q) * P(:,q)'
end
R = 1 / Q * R
printf('R: ')
disp(R)

h = zeros(2, 1)
for q=1:Q-1
    h = h + P(:,q) * P(1,q+1)
end
h = 1 / Q * h
printf('h: ')
disp(h)

c = 1 / Q * sum(P .^ 2)
printf('c: ')
disp(c)

// собственные числа и собственные векторы гессиана
A = 2 * R
[evals, diagevals]=spec(A)
printf('evals: ')
disp(evals)
printf('diagevals: ')
disp(diagevals)

// максимальное устойчивое значение (alpha < 1 / lambda_max)
alpha_max = 1 / max(evals)
printf('alpha_max: ')
disp(alpha_max)

// точка минимума
x_star = inv(R) * h
printf('x_star: ')
disp(x_star)

function z=f(w1, w2, c, h, R)
 x=[w1;w2];
 z=c-2*x'*h+x'*R*x;
endfunction


itermax = 100
alpha = .75
D = 2
[w,b,y_res,ee,mse,W]=ann_ADALINE1_predict(Y, T, alpha, itermax, D)
//printf("ee:")
//disp(size(mse))


x=linspace(-20,20,100);
y=linspace(-20,20,100);
z=feval(x,y,f); //вычисляем значения высот целевой функции f на сетке x,y
clf(1);
figure(1);

subplot(1,3,1);
plot(t, Y, t'(3:$), y_res)
xtitle("Входной и предсказанный процесс","t","y");
legend("входной", "предсказанный")
xgrid;

//surf(x,y,z'); //строим 3D поверхность

subplot(1,3,2);
plot(linspace(1,itermax), mse)
xtitle("Кривая обучения","iter","err");
xgrid;

subplot(1,3,3);

contour2d(x,y,z,30); //отображаем линии контуров равных уровней
xset("fpf"," "); //подавляем отображение значений на линиях контуров
//xtitle("Контуры равных уровней квадратичной функции","w1","w2");
xtitle("Траектория движения вектора параметров","w1","w2");
xgrid;

plot(x_star(1),x_star(2),'*b'); //отображаем точку решения минимума СКО (4.15)

plot2d(W(:,1),W(:,2),5); // кривая обучения



/*
itermax = 100
alpha = .2
D = 2

[w1,b1,mse1, W] = ann_ADALINE1((1:$-1),T,alpha,itermax,'zeros');
disp(size(W))

clf
contour2d(x,y,z,30); //отображаем линии контуров равных уровней
xset("fpf"," "); //подавляем отображение значений на линиях контуров
//xtitle("Контуры равных уровней квадратичной функции","w1","w2");
xtitle("Траектория движения вектора параметров","w1","w2");
xgrid;

plot(x_star(1),x_star(2),'*b'); //отображаем точку решения минимума СКО (4.15)

plot2d(W(:,1),W(:,2),5); // кривая обучения
*/

