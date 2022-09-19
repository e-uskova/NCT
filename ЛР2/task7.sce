// Задание 7
// То же, что в 6, только производные

clear;

exec logsig.sce;
exec poslin.sce;
exec d_logsig.sce;
exec d_poslin.sce;

// количество нейронов в слоях
s1 = 100
s2 = 8
s3 = 1

// размер входного вектора
R = 5 
// минимальная частота входного сигнала
F = 0.04 

//формирование матрицы p входных сигналов
t = (0:0.1:2/F)
fi = 2 * %pi * F .* t
P = sin(fi)
for i=2:R
 P = [P; sin(fi*i)];
end

grand("setsd", 42)

function a=ff_logsig(W, P, b)
    // прямое распространение
    a = logsig(W * P + repmat(b, 1, size(P, 2)))
endfunction

function a=ff_poslin(W, P, b)
    // прямое распространение
    a = poslin(W * P + repmat(b, 1, size(P, 2)))
endfunction

function a=init_nn_layer(P, S)
    // инициализация весов и смещений
    R = size(P, 1)
//    W = grand(S,R,'unf',-10,10)    
    scale = 1/sqrt(R);
    W = grand(S,R,'unf',-scale,scale)
    b = zeros(S, 1)
    
//    a = ff_logsig(W, P, b)
    a = ff_poslin(W, P, b)
endfunction

a1 = init_nn_layer(P, s1)
a2 = init_nn_layer(a1, s2)
a3 = init_nn_layer(a2, s3)

//d_a1 = d_logsig(a1)
//d_a2 = d_logsig(a2)
//d_a3 = d_logsig(a3)

d_a1 = d_poslin(a1)
d_a2 = d_poslin(a2)
d_a3 = d_poslin(a3)

clf(1)
figure(1)

subplot(221)
// активность 1-ого нейрона скрытого слоя
plot(t, d_a2(1,:))
xgrid
xtitle("Производные для нейрона скрытого слоя")

subplot(222)
// активность нейрона выходного слоя
plot(t, d_a3(1,:))
xgrid
xtitle("Производные для нейрона выходного слоя")

subplot(223)
// гистограмма общей активности нейронов скрытого слоя
histplot(20, d_a2, style=17)
xgrid
xtitle("Производные для нейронов скрытого слоя")

subplot(224)
// гистограмма общей активности нейрона выходного слоя
histplot(20, d_a3, style=17)
xgrid
xtitle("Производные для выходного слоя")

// статистики скрытого слоя
hl_mean = mean(d_a2)
hl_sd = stdev(d_a2)

printf("Среднее значение производных скрытого слоя: %f\n", hl_mean)
printf("Стандартное отклонение производных скрытого слоя: %f\n", hl_sd)

// статистики выходного слоя
ol_mean = mean(d_a3)
ol_sd = stdev(d_a3)

printf("Среднее значение производных выходного слоя: %f\n", ol_mean)
printf("Стандартное отклонение производных выходного слоя: %f\n", ol_sd)


/*
clear;

exec logsig.sce;
exec d_logsig.sce;

F = 0.04 // минимальная частота входного сигнала
R=5; //число входов слоя
S=3; // число нейронов слоя

//формирование матрицы p входных сигналов
t = (0:0.1:2/F)
fi = 2 * %pi * F .* t
p = sin(fi)
for i=2:R
 p=[p; sin(fi*i)];
end

grand("setsd", 42)

//инициализация весов и смещений
scale=1/sqrt(R);
w=grand(S,R,'unf',-scale,scale)
b=zeros(S,1);

//моделирование слоя c tansig нелинейностью
a=logsig(w*p+repmat(b,1,size(p,2)));

//вычисление производных tansig нелинейности
d_a=d_logsig(a);

//вычисление статистик
mean_a=mean(a)
stdev_a=stdev(a)
mean_d_a=mean(d_a)
stdev_d_a=stdev(d_a)

//построение графиков активностей, производных и гистограмм
clf(1);
figure(1);
subplot(2,2,1)
plot(t,a(1,:),t,a(2,:), t,a(3,:));
title('Активность нейронов слоя')
subplot(2,2,2)
plot(t,d_a(1,:),t,d_a(2,:), t,d_a(3,:));
title('Производные функции активации слоя')
subplot(2,2,3)
histplot(20,a);
title('Гистограмма активности нейронов слоя')
subplot(2,2,4)
histplot(20,d_a);
title('Гистограмма производных функции активации')
*/
