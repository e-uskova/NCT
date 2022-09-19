// Производная функции активации poslin

function y = d_poslin(x)
    y = zeros(x)
    for i=1:length(y)
        if x(i) >= 0 then
            y(i) = 1
        end
    end
endfunction
