x = (0:0.1:20)
d = sin(x) + 0.3 * rand(1, length(x), "normal")
clf
plot2d(x, d)
