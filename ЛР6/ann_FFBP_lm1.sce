function [W, out_mse, S]=ann_FFBP_lm1(P, T, N, af, mu, mumax, theta, itermax, mse_min, gd_min)
///Обучение нейросети прямого распространения на основе алгоритма Левенберга-Марквардта.
// Примеры вызова:
// W = ann_FFBP_lm(P,T,N)
// W = ann_FFBP_lm(P,T,N,af,mu,mumax,theta,itermax,mse_min,gd_min)
// Параметры
// P : Обучающий вход
// T : Обучающие целевые значения
// N : Вектор, задающий число нейронов каждого слоя, включая входной и выходной слои
// af : Список имен активационных функций от 1-го до выходного слоев
// mu : значение “мю” ЛМ алгоритма
// mumax : максимально возможное “мю”
// theta : множитель “тета” для “мю”
// itermax : Максимальное число эпох обучения
// mse_min : Минимальная ошибка (Значение целевой функции)
// gd_min : Минимальное значение градиента
// W : Выходные веса и смещения
//
//1. ================Обработка списка аргументов функции========================
 rhs=argn(2);
// Проверка ошибки списка аргументов
 if rhs < 3; error("Expect at least 3 arguments, P, T and N");end
// Выбор значений аргументов по умолчанию
 if rhs < 4; af = ['ann_tansig_activ','ann_purelin_activ']; end
 if rhs < 5; mu = 0.001; end
 if rhs < 6; mumax = 100000000; end
 if rhs < 7; theta = 10; end
 if rhs < 8; itermax = 1000; end
 if rhs < 9; mse_min = 1e-5; end
 if rhs < 10; gd_min = 1e-5; end
 if af == []; af = ['ann_tansig_activ','ann_purelin_activ']; end
 if mu == []; mu = 0.001; end
 if mumax == []; mumax = 100000000; end
 if theta == []; theta = 10; end
 if itermax == []; itermax = 1000; end
 if mse_min == []; mse_min = 1e-5; end
 if gd_min == []; gd_min = 1e-5; end
//2.=======================Инициализация====================
// Инициализация сети и формирование списка имен производных активационных функций
 format(8);warning('off');
 W = ann_ffbp_init(N,[-1 1]); // Каждый элемент W – матрица весов одного из слоев
 itercnt = 0;
 af_d = strsubst(af,'ann_','ann_d_');
 mse = %inf;
 gd = %inf;
 A = ann_ffbp_init(N,[0 0]);
 tempW = A;
 train_N = size(P,2); // Размер обучающего множества
 // Инициалиазация GUI окна прогресса
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
 while mse > mse_min & itercnt < itermax & mu <= mumax & gd > gd_min
 mucnt = 0;
 // Прямое распространение – моделирование (аналогично функции ann_FFBP_run (формула 5.1))
 n(1) = W(1)(:,1:$-1)*P + repmat(W(1)(:,$),1,size(P,2)); // Вычисляем и запоминаем сетевые выходы 1го слоя
 a(1) = evstr(af(1)+'(n('+string(1)+'))'); // Вычисляем и запоминаем активности на выходе 1го слоя
 for cnt = 2:layers
 n(cnt) = W(cnt)(:,1:$-1)*a(cnt-1) + repmat(W(cnt)(:,$),1,size(P,2)); // Вычисляем и запоминаем сетевые выходы
 a(cnt) = evstr(af(cnt)+'(n('+string(cnt)+'))'); // Вычисляем и запоминаем активности на выходе каждого слоя
 end
 // Вычисление ошибки
 e = T - a($);
 [r,c] = size(a(layers)); //запоминаем размерность выходного слоя

 m(layers) = evstr(af_d(layers)+'(a('+string(layers)+'))'); //Вычисление производных актив. функций выходного слоя (6.20)
 // s(layers) = -(m(layers).*.eye(N($),N($)));
 s(layers) = -(m(layers).*.ones(1,r)).*(ones(1,c).*.eye(r,r)); // Чувствительности выходного слоя –формула (6.21)

 for cnt = layers-1:-1:1 //Цикл для вычисления производных слоев и обратного распространения чувствительностей
 Wpre = W(cnt+1)(:,1:$-1); //Извлекаем из W и запоминаем веса следующего слоя
 a(cnt) = a(cnt).*.ones(1,N($));//Формируем матрицу активности слоя
 m(cnt) = evstr(af_d(cnt)+'(a('+string(cnt)+'))'); //Матрица производных F’(n) слоя
 s(cnt) = m(cnt).*(Wpre'*s(cnt+1)); // Матрица чувствительности слоя – формула (6.22)
 end

 // Вычисление элементов Якобиана – формула (6.18) и формирование матрицы Якоби
 Jj = [];
 jac = ann_calcjac(kron(P,ones(1,N($))),s(1)); // Для первого слоя
 Jj = [Jj jac s(1)'];
 for cnt = 2:layers
 jac = ann_calcjac(a(cnt-1),s(cnt)); // Для последующих слоев
 Jj=[Jj jac s(cnt)']; // добавление элементов в матрицу Якоби
 end

 mse = (mean(e.^2))
 mse2 = %inf;
 J = Jj;
 J2 = (J' * J); // Формула (6.13)
 Je = J'*e(:); // часть формулы (6.14)
 //Обновление параметров
 while mse2 >= mse & mu <= mumax // пока новый СКО не станет меньше текущего СKO
 dx = -(J2 + (eye(J2)*mu)) \ (Je); // Вычисление обновления (формула 6.14)
 szpre = 0;
 for cnt = 1:layers //Цикл для послойного обновления параметров
 sz = N(cnt)*N(cnt+1) + N(cnt+1); // Число параметров текущего слоя
 dx_part = dx(szpre+1:szpre+sz) //Выделение части обновлений для текущего слоя
 A(cnt) = [matrix(dx_part(1:$-N(cnt+1)),N(cnt+1),N(cnt)) dx_part($-N(cnt+1)+1:$)]; // Реформатирование
 tempW(cnt) = W(cnt) + A(cnt); // обновление параметров слоя
 szpre = szpre + sz; // Начало индексов следующего слоя
 end
 //Вычисление выхода при новых значениях параметров
 y = ann_FFBP_run(P,tempW,af);
 e2 = T - y; // Вычисление новой ошибки
 mse2 = (mean(e2.^2)); //Вычисление нового СКО
 if mse2 >= mse //Если СКО увеличился, то увеличить mu
 mu = mu*theta;
 end
 end
 mu = mu/theta; // Т.к. новый СКО меньше текущего, то уменьшить mu
 if (mu < 1e-20)
 mu = 1e-20;
 // break
 end
 W= tempW; //Сохранить обновленные значения параметров
 //Критерий остановки
 mse = mean(e.^2);
 itercnt = itercnt + 1;
 out_mse(itercnt)=mse;
 //средний градиент
 gd = 2*sqrt(Je'*Je)/train_N;
 // Отображение GUI прогресса обучения
 if itercnt == 1 then
 mse_max = mse;
 handles.msemax.string = string(mse_max);
 gd_max = gd;
 handles.gdmax.string = string(gd_max);
 mse_span = log(mse) - log(mse_min);
 iter_span = itermax;
 gd_span = log(gd) - log(gd_min);
end
 // Scilab 5.5 и выше
 handles.iter.value = round((itercnt/iter_span)*100);
 handles.mse.value = -(log(mse)-log(mse_max))/mse_span * 100;// round(((log(mse) - log(mse_min))/mse_span)*100);
 handles.gd.value = -(log(gd)-log(gd_max))/gd_span * 100; //round(((log(gd) - log(gd_min))/gd_span)*100);
 handles.itercurrent.string = string(itercnt);
 handles.msecurrent.string = string(mse);
 handles.gdcurrent.string = string(gd);
 end
endfunction
