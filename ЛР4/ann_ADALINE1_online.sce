function [w, b, mse2]=ann_ADALINE1_online(P, T, alpha, itermax, initfunc)
// Обучение слоя адаптивных линейных нейронов в последовательном режиме
// Примеры вызовов
// [w,b] = ann_ADALINE_online(P,T)
// [w,b] = ann_ADALINE_online (P,T,alpha,itermax,initfunc)
//Параметры:
// P : Матрица обучающих примеров (RxQ)
// T : Матрица целевых выходных значений (SxQ)
// alpha : Скорость обучения (по умолчанию =0.01)
// itermaxs : Максимальное число итераций – эпох (по умолчанию – 100)
// initfunc : Функция инициализации значений w и b: 'rand', 'zeros', или 'ones'
// По умолчанию используется ‘rand’.
// w : веса сети (SxR))
// b : смещения (Sx1)
// 1.===== Обработка списка входных аргументов функции ======
rhs=argn(2); // argn(2) – возвращает число аргументов функции
if rhs < 2; error("Должно быть минимум 2 аргумента: P и T"); end
if rhs < 3; alpha = 0.01; end
if rhs < 4; itermax = 100; end
if rhs < 5; w = rand(size(T,1),size(P,1)); b = rand(size(T,1),1); end
//Инициализация весов и смещений
if rhs == 5 then
 select initfunc
 case 'rand' then
 w = rand(size(T,1),size(P,1));
 b = rand(size(T,1),1);
 case 'zeros' then
 w = zeros(size(T,1),size(P,1));
 b = zeros(size(T,1),1);
 case 'ones' then
 w = ones(size(T,1),size(P,1));
 b = ones(size(T,1),1);
 else
 error("Неверное значение входного аргумента 5");
 end
end
if itermax == []; itermax = 100; end
if alpha == []; alpha = 0.01; end
//2. ====== Реализация правил обучения ==========================
itercnt = 0; // Счетчик итераций - эпох
mse2=zeros(1,itermax);
while itercnt < itermax
 for cnt = 1:size(P,2) // Цикл по всем обучающим примерам - 1 эпоха
 // Вычисляем вектор текущей ошибки сети e для одного примера P(:,cnt)
 e = T(:,cnt) - ann_purelin_activ(w*P(:,cnt)+b);
 //Реализуем правило обучения Уидроу-Хоффа
 //для каждого примера P(:,cnt) вычисляем обновление w и b
 w = (w + 2*alpha*e*P(:,cnt)');
 b = b + 2*alpha*e;
 // Вычисляем и запоминаем квадраты текущих ошибок
 e_all(:,cnt) = e.^2;
 end
 itercnt = itercnt + 1;
  mse2(itercnt)=mean(e_all);
 //disp('Epoch: ' + string(itercnt) + ' MSE: ' + string(mean(e_all)));
end
endfunction
