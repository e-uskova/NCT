function [w, b, mse1]=ann_ADALINE1(P, T, alpha, itermax, initfunc)
// Обучение слоя адаптивных линейных нейронов в блочном режиме
// Длина блока Q равна числу обучающих примеров
// Примеры вызовов
// [w,b] = ann_ADALINE(P,T)
// [w,b] = ann_ADALINE(P,T,alpha,itermax,initfunc)
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
mse1=zeros(1,itermax);
while itercnt < itermax
 // Вычисляем вектор выхода сети a и вектор ошибки сети e
 // сразу для всего блока данных P (1 эпоха)
 n = w*P + repmat(b,1,size(P,2));
 a = ann_purelin_activ(n);
 e = T - a;
 //Реализуем блочное правило обучения Уидроу-Хоффа
 // вычисляется среднее обновление для w и b в пределах блока
 w = w + (2*alpha*e*P')./size(P,2);
 b = b + 2*alpha*mean(e,2);
 // Вычисляем вектор ошибки при обновленных w и b
 n = w*P + repmat(b,1,size(P,2));
 a = ann_purelin_activ(n);
 e = T - a;
 // Вычисляем значения СКО
 mse = mean(e.^2);
 itercnt = itercnt + 1;
  mse1(itercnt) = mean(e.^2);
 //disp('Эпоха: ' + string(itercnt) + ' СКО: ' + string(mean(mse)));
end
endfunction
