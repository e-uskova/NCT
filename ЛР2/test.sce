// test

x = -2:0.01:2

//d_a1 = ann_d_logsig_activ(x)

function y=d_logsig(x)
    y = ann_logsig_activ(x) .* (1 - ann_logsig_activ(x))
endfunction

//d_a2 = d_logsig(x)

clf
subplot(121)
plot(ann_logsig_activ(x), ann_d_logsig_activ)
subplot(122)
plot(x, d_logsig)
