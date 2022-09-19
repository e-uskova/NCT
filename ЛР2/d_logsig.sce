// Производная функции активации logsig

exec logsig.sce;

function y=d_logsig(x)
    y = logsig(x) .* (1 - logsig(x))
endfunction
