// test

clear;

F = 0.04
t=0:0.1:2/F;
fi=(2*%pi*F).*t;
p=[sin(fi)];

clf
plot(t, p)
