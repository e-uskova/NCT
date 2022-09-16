// Переопределение ann_logsig_activ

function y=logsig(x)
    y = 1 ./ (1 + exp(-x))
endfunction
