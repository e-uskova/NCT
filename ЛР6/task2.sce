// Задание 2

//clear
exec("gendata.sce");
exec("ann_FFBP_gd1.sce");
exec("ann_FFBP_lm1.sce");

rand("seed", 42)
grand("setsd", 42)

function y = f(x)
    y = x .* sin(x) + (exp(-x) - exp(x))./(exp(-x) + exp(x))
endfunction

Q = 200
kd = 0.03
[P, T, y, x] = gendata(Q, kd)

/*
clf
//отображение множества точек 2-х классов и разделяющей границы
drawlater(); // прорисовка отображения будет позже
plot(P(1,T==1),P(2,T==1),'o'); //отображать точки 1-го класса знаком 'o'
plot(P(1,T==0),P(2,T==0),'g*'); //отображать точки 2-го класса знаком '*'
plot(x,y,'r'); // отображать границу красным цветом
drawnow(); // включаем прорисовку
xtitle('Классы и граница');
*/

R = size(P, 1)
//S = 50 // 10 30 40 50 // 10 default
//N = [R S 1]
af = ['ann_logsig_activ' 'ann_purelin_activ']
lr = 0.01 // 0.05, 0.025, 0.01, 0.005 // 0.01 default
itermax = 100 // 1000 default
mse_min = 1e-5
gd_min = 1e-5
mu = 0.001
mumax = 100000000
theta = 10

/*
W_gd = ann_FFBP_gd(P, T, N, af, lr, itermax, mse_min, gd_min)
W_lm = ann_FFBP_lm(P,T,N,af,mu,mumax,theta,itermax,mse_min,gd_min)
*/

//Обучаем при разных S
S=[10 20 30 40]

//MSE_gd=[];
//W_all_gd=cell(); // клеточный массив для хранения всех весов
//for k=1:length(S)
//    N=[2 S(k) 1];
//    [W_gd,out_mse_gd] = ann_FFBP_gd1(P,T,N,af,lr,itermax);
//    MSE_gd=[MSE_gd;out_mse_gd'];
//    W_all_gd{k}= W_gd;
//end;
//
//MSE_lm=[];
//W_all_lm=cell(); // клеточный массив для хранения всех весов
//for k=1:length(S)
//    N=[2 S(k) 1];
//    [W_lm,out_mse_lm] = ann_FFBP_lm1(P,T,N,af,mu,mumax,theta,itermax,mse_min,gd_min);
//    MSE_lm=[MSE_lm;out_mse_lm'];
//    W_all_lm{k}= W_lm;
//end;

/*
clf
subplot(121)
plot(MSE_gd')
xtitle("Кривые обучения BP_gd при разных S")
legend("10", "20", "30", "40")

subplot(122)
plot(MSE_lm')
xtitle("Кривые обучения BP_lm при разных S")
legend("10", "20", "30", "40")
*/

[P_test,T_test,y_test,x_test]=gendata(Q,kd)

num = 1
//a_test_gd = ann_FFBP_run(P_test,W_all_gd{num},af);
//y_bin_test_gd=round(a_test_gd); //делаем выход бинарным
////вычисляем вероятность правильной классификации
//n_correct_gd=sum(T_test == y_bin_test_gd);
//rate_gd=n_correct_gd/length(T_test);
//
//disp(rate_gd)

a_test_lm = ann_FFBP_run(P_test,W_all_lm{num},af);
y_bin_test_lm=round(a_test_lm); //делаем выход бинарным
//вычисляем вероятность правильной классификации
n_correct_lm=sum(T_test == y_bin_test_lm);
rate_lm=n_correct_lm/length(T_test);

disp(rate_lm)



clf
//subplot(121)
//plot(P(1, y_bin_test_gd ==1),P(2, y_bin_test_gd ==1),'o'); //отображать точки 1-го класса'
//plot(P(1, y_bin_test_gd ==0),P(2, y_bin_test_gd ==0),'g*'); //отображать точки 2-го класса'
//plot(x_test,y_test,'m'); // отображать границу малиновым цветом
//xtitle("Результаты классификации тестирующего множества (gd)")
//
//subplot(122)
plot(P(1, y_bin_test_lm ==1),P(2, y_bin_test_lm ==1),'o'); //отображать точки 1-го класса'
plot(P(1, y_bin_test_lm ==0),P(2, y_bin_test_lm ==0),'g*'); //отображать точки 2-го класса'
plot(x_test,y_test,'m'); // отображать границу малиновым цветом
xtitle("Результаты классификации тестирующего множества")// (lm)")


