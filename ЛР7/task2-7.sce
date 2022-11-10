// ЛР 7 Всё здесь (2-7)

clear

rand("seed", 42)
grand("setsd", 42)

x = rand(2,100) * 6;

//plot(x(1,:), x(2,:), '.')

W = ann_SOM(x, [6 6]);
//clf
//W = ann_SOM_visualize2d(x, [6 6]);
//W = ann_SOM_visualize2d(x,[2 2],200,100,3,'ann_som_gridtop','ann_som_linkdist');

//clf
border = 0 // 6 / 7 / 2 // чтобы точки были в центрах квадратов
[cx, cy] = meshgrid(linspace(0 + border, 6 - border, 6))
centers = []
for i=1:size(cx, 1)
    centers = [centers [cx(i, :); cy(i, :)]]
end
//disp(centers)

[y,classes] = ann_SOM_run(W,centers)
disp(classes)

/* Карта классов
//colors = ['scilabblue3','scilabgreen3','scilabcyan3','scilabred3','scilabmagenta3','scilabbrown3','scilabpink3','blue','green','yellow']
//
//for i=1:size(centers,2)
//    plot(centers(1, i), centers(2, i), '+', "Color", colors(modulo(classes(i),10)+1))
//end
*/

/* LVQ
T = []
[W,b] = ann_LVQ1(x,T,36)
[y,classes] = ann_LVQ_run(W,P)
/*






