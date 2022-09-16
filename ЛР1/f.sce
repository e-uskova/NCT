// Определение функции f(x)=x*sin(x)+(e^(-x)-e^x)/(e^(-x)+e^x)

function res=f(x)
    res = x.*sin(x)+(%e.^(-x)-%e.^x)/(%e.^(-x)+%e.^x)
endfunction
