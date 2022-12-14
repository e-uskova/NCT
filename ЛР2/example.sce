//задание исходных данных
F=0.01 //минимальная частота входного сигнала
R=5; //число входов слоя
S=3; // число нейронов слоя
//формирование матрицы p входных сигналов
t=0:0.1:2/F;
fi=(2*%pi*F).*t;
p=[sin(fi)];
for i=2:R
 p=[p; sin(fi*i)];
end
//инициализация весов и смещений
scale=1/sqrt(R);
w=grand(S,R,'unf',-scale,scale)
b=zeros(S,1);
//моделирование слоя c tansig нелинейностью
a=ann_tansig_activ(w*p+repmat(b,1,size(p,2)));
//вычисление производных tansig нелинейности
d_a=ann_d_tansig_activ(a);
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
