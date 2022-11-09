// Задание 3

clear;

exec("ann_FFBP_gd1.sce");
exec("ann_FFBP_gda1.sce");
exec("ann_FFBP_gdm1.sce");
exec("ann_FFBP_gdx1.sce");

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
itermax = 800 // 1000 default
mse_min = 1e-5
gd_min = 1e-5

/*
S=[5, 10, 15, 20];
for i=1:length(S)
    N=[2 S(i) 1];
    [W_gd, out_mse_gd] = ann_FFBP_gd1(P_train,T_train,N,af,lr,itermax);
    mse_gd_hist(i,:)=out_mse_gd;
end;

clf
plot(mse_gd_hist')
xtitle("Кривые обучения MLP при разных S", "Эпоха", "СКО")
legend("5", "10", "15", "20")
*/

[W_gd, out_mse_gd] = ann_FFBP_gd1(P_train,T_train,N,af,lr,itermax,mse_min,gd_min);
lr_inc = 1.05
lr_dec = 0.75
mse_diff_max = 0.01
[W_gda,out_mse_gda] = ann_FFBP_gda1(P_train,T_train,N,af,lr,lr_inc,lr_dec,itermax,mse_min,gd_min,mse_diff_max );
Mr = 0.9
[W_gdm, out_mse_gdm]=ann_FFBP_gdm1(P_train,T_train,N,af,lr,Mr,itermax,mse_min,gd_min);
[W_gdx, out_mse_gdx] = ann_FFBP_gdx1(P_train,T_train,N,af,lr,lr_inc,lr_dec,Mr,itermax,mse_min,gd_min);


clf
//plot(out_mse_gd')
//plot(out_mse_gda')
//plot(out_mse_gdm')
//plot(out_mse_gdx')
plot([out_mse_gd out_mse_gda out_mse_gdm out_mse_gdx])
xtitle("Кривые обучения MLP с помощью разных алгоритмов", "Эпоха", "СКО")
legend("gd", "gda", "gdm", "gdx")

/*
y_test_gd = ann_FFBP_run(P_test,W_gd,af); // сеть, обученная алг-м BP_gd
y_test_gda = ann_FFBP_run(P_test,W_gda,af); // сеть, обученная алг-м BP_gda
y_test_gdm = ann_FFBP_run(P_test,W_gdm,af); // сеть, обученная алг-м BP_gdm
y_test_gdx = ann_FFBP_run(P_test,W_gdx,af); // сеть, обученная алг-м BP_gdx
// вычисление СКО на тестовых данных
mse_gd=((T_test-y_test_gd)*(T_test-y_test_gd)')/Q_test
printf("mse_gd: %f\n", mse_gd)
mse_gda=((T_test-y_test_gda)*(T_test-y_test_gda)')/Q_test
printf("mse_gda: %f\n", mse_gda)
mse_gdm=((T_test-y_test_gdm)*(T_test-y_test_gdm)')/Q_test
printf("mse_gdm: %f\n", mse_gdm)
mse_gdx=((T_test-y_test_gdx)*(T_test-y_test_gdx)')/Q_test
printf("mse_gdx: %f\n", mse_gdx)

clf
subplot(221)
plot([y_test; y_test_gd]')
xtitle("gd")
legend("y=f(x, y)", "gd")

subplot(222)
plot([y_test; y_test_gda]')
xtitle("gda")
legend("y=f(x, y)", "gda")

subplot(223)
plot([y_test; y_test_gdm]')
xtitle("gdm")
legend("y=f(x, y)", "gdm")

subplot(224)
plot([y_test; y_test_gdx]')
xtitle("gdx")
legend("y=f(x, y)", "gdx")
*/




