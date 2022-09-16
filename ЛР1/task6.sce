// Задание 6
// Сгенерировать матрицу случайных чисел, построить гистограмму, вычислить параметры

n = 4
m1 = n + 10
m2 = 100 * n
Av = 5
Sd = 0.25

grand("setsd", 42)
A = grand(m1, m2, "nor", Av, Sd)

A_mean = mean(A)
A_variance = variance(A)
A_Sd = stdev(A)
A_median = median(A)

printf("Среднее: %f\n", A_mean)
printf("Дисперсия: %f\n", A_variance)
printf("Стандартное отклонение: %f\n", A_Sd)
printf("Медиана: %f\n", A_median)

clf
histplot(20, A, normalization=%f, leg="Normal Av=5 Sd=0.25", style=17)
xgrid
