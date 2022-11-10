function [W, out_mse]=ann_FFBP_gd1(P, T, N, af, lr, itermax, mse_min, gd_min)
// Обучение на основе блочного алгоритма нисходящего градиента с обратным распространением.
//
// Примеры вызова:
// W = ann_FFBP_gd(P,T,N)
// W = ann_FFBP_gd(P,T,N,af,lr,itermax,mse_min,gd_min)
//
// Параметры
// P : Обучающий вход
// T : Обучающие целевые значения
// N : Вектор, задающий число нейронов каждого слоя, включая входной и выходной слои
// af : Список имен активационных функций от 1-го до выходного слоев
// lr : скорость обучения
// itermax : Максимальное число эпох обучения
// mse_min : Минимальная ошибка (Значение целевой функции)
// gd_min : Минимальное значение градиента
// W : Выходные веса и смещения
//1. ================Обработка списка аргументов функции========================
rhs=argn(2);
// Проверка ошибки списка аргументов
if rhs < 3; error("Expect at least 3 arguments, P, T and N");end
// Выбор значений аргументов по умолчанию
if rhs < 4; af = ['ann_tansig_activ','ann_purelin_activ']; end
if rhs < 5; lr = 0.01; end
if rhs < 6; itermax = 1000; end
if rhs < 7; mse_min = 1e-5; end
if rhs < 8; gd_min = 1e-5; end
if af == []; af = ['ann_tansig_activ','ann_purelin_activ']; end
if lr == []; lr = 0.01; end
if itermax == []; itermax = 1000; end
if mse_min == []; mse_min = 1e-5; end
if gd_min == []; gd_min = 1e-5; end
// Проверка ошибки списка активационных функций
if size(N,2)-1~= size(af,2) then
 error('Numbers of activation functions must match numbers of layers (N-1)');
end
//2.=======================Инициализация====================
// Инициализация сети и формирование списка имен производных активационных функций
format(8);
W= ann_ffbp_init(N);
itercnt = 0;
af_d = strsubst(af,'ann_','ann_d_');
mse = %inf;
gd = %inf;
//Инициализация GUI отображения прогресса обучения
handles = ann_training_process();
handles.itermax.string = string(itermax);
handles.msemin.string = string(mse_min);
handles.gdmax.string = 'inf';
handles.gdmin.string = string(gd_min);
// Задание числа слоев и списков промежуточных переменных
layers = size(N,2)-1; // слои считаются от 1-го скрытого слоя до выходного слояr
n = list(0);
a = list(0);
m = list(0);
s = list(0);
// 3. ===================Реализация цикла эпох обучения==========================
while mse > mse_min & itercnt < itermax & gd > gd_min
 // Прямое распространение – моделирование (аналогично функции ann_FFBP_run (формула 5.1))
 n(1) = W(1)(:,1:$-1)*P + repmat(W(1)(:,$),1,size(T,2));
 a(1) = evstr(af(1)+'(n('+string(1)+'))');
 for cnt = 2:layers
 n(cnt) = W(cnt)(:,1:$-1)*a(cnt-1) + repmat(W(cnt)(:,$),1,size(T,2));
 a(cnt) = evstr(af(cnt)+'(n('+string(cnt)+'))');

 end
 // Вычисление ошибки
 e = T - a($);
 // Обратное распространение значений чувствительности
 m(layers) = evstr(af_d(layers)+'(a('+string(layers)+'))'); // Вычисление производных актив. функций последнего слоя
 s(layers) = (-2*m(layers).*e); // Вычисление чувствительности выходного слоя (формула 5.12)
 for cnt = layers-1:-1:1 //Вычисляем производные актив. функций слоев и распространяем обратно чувствительности.
 m(cnt) = evstr(af_d(cnt)+'(a('+string(cnt)+'))');
 s(cnt) = m(cnt).*(W(cnt+1)(:,1:$-1)'*s(cnt+1)); //(формула 5.12)
 end

 // Обновление весов сети (формула 5.15)
 W(1)(:,1:$-1) = W(1)(:,1:$-1) - (lr*s(1)*P')./size(P,2); // Обновление весов 1-го скрытого слоя
 W(1)(:,$) = W(1)(:,$) - lr*mean(s(1),2); // Обновление смещений 1-го скрытого слоя
 for cnt = 2:layers // Обновление весов и смещений следующих слоев
 W(cnt)(:,1:$-1) = W(cnt)(:,1:$-1) - (lr*s(cnt)*a(cnt-1)')./size(P,2);
 W(cnt)(:,$) = W(cnt)(:,$) - lr*mean(s(cnt),2);
 end

 // Вычисление критериев остановки алгоритма
 mse = mean(e.^2); // СКО
 itercnt = itercnt + 1; //Число эпох
 out_mse(itercnt)=mse;
 gd = mean(s(1).^2); // Средний квадрат значения градиента целевой функции
  // программирование GUI отображения прогресса обучения
 if itercnt == 1 then
 mse_max = mse;
 handles.msemax.string = string(mse_max);
 gd_max = gd;
 handles.gdmax.string = string(gd_max);
 mse_span = log(mse) - log(mse_min);
 iter_span = itermax;
 gd_span = log(gd) - log(gd_min);
 end

 // для версии выше Scilab 5.5
 handles.iter.value = round((itercnt/iter_span)*100);
 handles.mse.value = -(log(mse)-log(mse_max))/mse_span * 100;// round(((log(mse) - log(mse_min))/mse_span)*100);
 handles.gd.value = -(log(gd)-log(gd_max))/gd_span * 100; //round(((log(gd) - log(gd_min))/gd_span)*100);

 handles.itercurrent.string = string(itercnt);
 handles.msecurrent.string = string(mse);
 handles.gdcurrent.string = string(gd);
end
endfunction
