// Функция активации poslin (она же ReLU - положительная линейная)

function a=poslin(n)
    a = n
    for i=1:length(n)
        if a(i) < 0 then
            a(i) = 0
        end
    end
endfunction
