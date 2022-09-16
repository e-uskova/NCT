// Задание 4
// Реализовать две сети для двух видов активационных функций
// Структура сети 100-8-1, а.ф-ии: logsig, poslin

// количество нейронов в слоях
s1 = 100
s2 = 8
s3 = 1

// размер входного вектора
R = 5 
// количество входных векторов
N = 10

rand("seed", 42)

// генерация входа
P = rand(R, N)

function a=init_nn_layer_logsig(P, S)
    // инициализация слоя
    W = rand(S, size(P, 1))
    b = zeros(S, 1)
    a = logsig(W * P + repmat(b, 1, size(P, 2)))
endfunction

function a=init_nn_layer_poslin(P, S)
    // инициализация слоя
    W = rand(S, size(P, 1))
    b = zeros(S, 1)
    a = poslin(W * P + repmat(b, 1, size(P, 2)))
endfunction

a1 = init_nn_layer_poslin(P, s1)
a2 = init_nn_layer_poslin(a2, s2)
a3 = init_nn_layer_poslin(a3, s3)
