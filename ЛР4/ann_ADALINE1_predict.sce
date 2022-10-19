function [w,b,y,ee,mse,W] = ann_ADALINE1_predict(X,T,alpha,itermax,D,initfunc)
// Обучение адаптивного линейного предсказателя с линией задержки
// в последовательном режиме
// Примеры вызовов
// [w,b] = ann_ADALINE__predict (P,T, alpha)
// [w,b] = ann_ADALINE__predict (P,T,alpha,itermax, D, initfunc)
//Параметры:
// X: входные значения предсказателя
// P : Матрица обучающих примеров (RxQ)
// T : Матрица целевых выходных значений (SxQ)
// alpha: Скорость обучения (по умолчанию – 0.01)
// itermaxs : Максимальное число итераций – эпох (по умолчанию – 100)
// D – число элементов задержки (по умолчанию – 1)
// initfunc : Функция инициализации значений w и b: 'rand', 'zeros', или 'ones'
// По умолчанию используется ‘rand’.
// w : веса сети (SxR))
// b : смещения (Sx1)
// y : Выход предсказанияt
// ee : Ошибка между T и y
// 1.===== Обработка списка входных аргументов функции ======
rhs=argn(2); // argn(2) – возвращает число аргументов функции
if rhs < 2; error("Должно быть минимум 2 аргумента: P и T"); end
if rhs < 3; alpha = 0.01; end
if rhs < 4; itermax = 100; end
if rhs < 5; D = 1; end
if rhs < 6; w = 20*rand(size(T,1),D); b = rand(size(T,1),1); end
//Инициализация весов и смещений
if rhs == 6 then
 select initfunc
 case 'rand' then
 w = rand(size(T,1),D);
 b = rand(size(T,1),1);
 case 'zeros' then
 w = zeros(size(T,1),D);
 b = zeros(size(T,1),1);
 case 'ones' then
 w = ones(size(T,1),D);
 b = ones(size(T,1),1);
 else
 error("Неверное значение входного аргумента 5");
 end
end
if itermax == []; itermax = 100; end
if alpha == []; alpha = 0.01; end
if D == []; D = 1; end
// Формирование выходов линии задержки: реформатирование X в матрицу P
P = [];
for cnt = 1:D // для каждого выхода линии задержки
 //формируем строки матрицы P из отсчетов X
 // очередная строка P – сдвинутая на один отсчет копия предыдущей строки
 P = [P; X(cnt:$-D+cnt-1)];
 end
//формируем вектор целевых значений
T = T(1:$-D+1);
//2. ====== Реализация правил обучения ==========================
mse=zeros(1,itermax); // создаем вектор СКО
W=[w]; //матрица, каждая строка которой – вектор весов на очередном шаге
itercnt = 0; // Счетчик итераций - эпох
while itercnt < itermax
 for cnt = 1:size(P,2) // Цикл по всем обучающим примерам из P (1 эпоха)
 n = w*P(:,cnt)+b; // Сетевая функция АЛЭ
 a = ann_purelin_activ(n);
 e = T(:,cnt) - a; // Ошибка
 y(cnt) = a; // Запоминаем выход АЛЭ
 ee(cnt) = e; // Запоминаем ошибку
 //Реализуем правило обучения Уидроу-Хоффа
 //для каждого примера P(:,cnt) вычисляем обновление w и b
 w = (w + 2*alpha*e*P(:,cnt)');
 b = b + 2*alpha*e;
 // Вычисляем и запоминаем квадраты текущих ошибок
 e_all(cnt) = e.^2;
 W=[W; w];
 end
 itercnt = itercnt + 1;
 mse(itercnt)=mean(e_all); // вычисляем СКО на шаге и запоминаем
 //disp('Epoch: ' + string(itercnt) + ' MSE: ' + string(mean(e_all)));
end
endfunction
