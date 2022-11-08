// Задание 2

clear
exec("gendata.sce");
//exec("logsig.sce");

rand("seed", 42)
grand("setsd", 42)

function y = f(x)
    y = x .* sin(x) + (exp(-x) - exp(x))./(exp(-x) + exp(x))
endfunction

Q = 200
kd = 0.03
[P, T, y, x] = gendata(Q, kd)


clf
/*
//отображение множества точек 2-х классов и разделяющей границы
drawlater(); // прорисовка отображения будет позже
plot(P(1,T==1),P(2,T==1),'o'); //отображать точки 1-го класса знаком 'o'
plot(P(1,T==0),P(2,T==0),'g*'); //отображать точки 2-го класса знаком '*'
plot(x,y,'r'); // отображать границу красным цветом
drawnow(); // включаем прорисовку
xtitle('Классы и граница');
*/

R = size(P, 1)
S = 50 // 10 30 40 50 // 10 default
N = [R S 1]
af = ['ann_logsig_activ' 'ann_purelin_activ']
lr = 0.05 // 0.05, 0.025, 0.01, 0.005 // 0.01 default
itermax = 1000 // 1000 default
mse_min = 1e-5
gd_min = 1e-5

W = ann_FFBP_gd(P, T, N, af, lr, itermax, mse_min, gd_min)

[P_test,T_test,y_test,x_test]=gendata(Q,kd)

a_test = ann_FFBP_run(P_test,W,af);
y_bin_test=round(a_test); //делаем выход бинарным
//вычисляем вероятность правильной классификации
n_correct=sum(T_test == y_bin_test);
rate=n_correct/length(T_test);

disp(rate)

clf
 plot(P(1, y_bin_test ==1),P(2, y_bin_test ==1),'o'); //отображать точки 1-го класса'
plot(P(1, y_bin_test ==0),P(2, y_bin_test ==0),'g*'); //отображать точки 2-го класса'
 plot(x_test,y_test,'m'); // отображать границу малиновым цветом
xtitle("Результаты классификации тестирующего множества")








