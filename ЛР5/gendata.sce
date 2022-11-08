function [P, T, y, x]=gendata(Q, kd)
    //формирование множеств случайных точек для 2-классов,
    // разделяемых кривой y=f(x)
    //Q - число точек в каждом множестве
    //kd - коэффициент, задающий величину отступа от границы
    //задание области определения функции - координата x
    xmin=0;
    xmax=1;
    //поиск ymax и ymin
    stepx=abs(xmax-xmin)/Q;
    x=xmin:stepx:xmax;
    y=f(x); // функция, заданная вариантом. Определяется отдельно!
    ymin=min(y);
    ymax=max(y);
    //диапазон изменения значений функции
    range=abs(ymax-ymin);
    //задание расстояния между классами: d=kd*|(ymax-ymin)|
    d=kd*range;
    //формирование случ. мн-ва точек datax вдоль x
    datax=grand(1,Q,'unf',xmin,xmax);
    // формирование обучающего множества {P,T}
    P=[];
    T=[];
    bord = []
    for j=1:1:Q
        //значение границы border для случайной точки datax(1,j)
        border=f(datax(1,j));
        //вычисление ординаты "y" 2-х случайных точек, 
        //отстоящих от border на расстояние d
        y_class1=grand(1,1,'unf',border+d,border+range);
        y_class2=grand(1,1,'unf',border-range,border-d);
        //формирование x,y координат 2-х j-тых точек 
        //классов 1 и 2 в виде вектора
        j_class1=[datax(1,j); y_class1];
        j_class2=[datax(1,j); y_class2];
        //добавление полученных j-тых точек во множество входных примеров
        P=[P j_class1 j_class2];
        // формирование соответсвующих целевых выходных значений MLP
        t_class1=1;
        t_class2=0;
        T=[T t_class1 t_class2];
    end
endfunction
