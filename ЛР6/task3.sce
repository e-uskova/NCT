// Задание 3

clear;

exec("ann_FFBP_gdx1.sce");
exec("ann_FFBP_lm1.sce");

rand("seed", 42)
grand("setsd", 42)

function z=f(x, y)
    z = 4 * x .* y - cos((exp(-y)-exp(x))./(exp(-x)+exp(y))).^2
endfunction

Q=300; //Общее число элементов множества данных
Q_train=floor(0.8*Q); //число эл-тов обучающего мно-ва 80% от Q
Q_test=Q-Q_train
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
S = 20 // 10 default
N = [R S 1]
af = ['ann_tansig_activ' 'ann_purelin_activ']
lr = 0.05 // 0.01 default
itermax = 100 // 1000 default
mse_min = 1e-5
gd_min = 1e-5
mu = 0.001
mumax = 100000000
theta = 10
lr_inc = 1.05
lr_dec = 0.75
mse_diff_max = 0.01
Mr = 0.9

[W_gdx, out_mse_gdx] = ann_FFBP_gdx1(P_train,T_train,N,af,lr,lr_inc,lr_dec,Mr,itermax,mse_min,gd_min);
[W_lm, out_mse_lm] = ann_FFBP_lm1(P_train,T_train,N,af,mu,mumax,theta,itermax,mse_min,gd_min);

for i=size(out_mse_lm,1)+1:itermax
    out_mse_lm(i) = 0
end

/*
clf
plot([out_mse_gdx out_mse_lm])
xtitle("Кривые обучения MLP с помощью разных алгоритмов", "Эпоха", "СКО")
legend("gdx", "lm")
*/


y_test_gdx = ann_FFBP_run(P_test,W_gdx,af); // сеть, обученная алг-м BP_gdx
y_test_lm = ann_FFBP_run(P_test,W_lm,af); // сеть, обученная алг-м BP_lm
// вычисление СКО на тестовых данных
mse_gdx=((T_test-y_test_gdx)*(T_test-y_test_gdx)')/Q_test
printf("mse_gdx: %f\n", mse_gdx)
mse_lm=((T_test-y_test_lm)*(T_test-y_test_lm)')/Q_test
printf("mse_lm: %f\n", mse_lm)

clf

subplot(121)
plot([T_test; y_test_gdx]')
xtitle("gdx")
legend("y=f(x, y)", "gdx")

subplot(122)
plot([T_test; y_test_lm]')
xtitle("lm")
legend("y=f(x, y)", "lm")
/**/




