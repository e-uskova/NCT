// Задание 3

clear;

function z=f(x, y)
    z = 4 * x .* y - cos((exp(-y)-exp(x))./(exp(-x)+exp(y))).^2
endfunction

Q=300; //Общее число элементов множества данных
Q_train=floor(0.8*Q); //число эл-тов обучающего мно-ва 80% от Q
x=grand(1,Q,'unf',0,1); //формирование случайных координат x,y
y=grand(1,Q,'unf',0,1);
x_train=x(1:Q_train); //формирование обучающего подмно-ва
y_train=y(1:Q_train);
P_train=[x_train;y_train];
T_train=f(x_train,y_train);
x_test=x(Q_train+1:$);//формирование тестового подмно-ва
y_test=y(Q_train+1:$);
P_test=[x_test;y_test];
T_test=f(x_test,y_test);

R = size(P_train, 1)
S = 10 // 10 30 40 50 // 10 default
N = [R S 1]
af = ['ann_logsig_activ' 'ann_purelin_activ']
lr = 0.01 // 0.05, 0.025, 0.01, 0.005 // 0.01 default
itermax = 1000 // 1000 default
mse_min = 1e-5
gd_min = 1e-5

W = ann_FFBP_gd(P_train, T_train, N, af, lr, itermax, mse_min, gd_min)
