#exercice2

X = [44 65 71 75 87;40 60 59 65 77];
scatter (X(1,:) , X(2,:));
title('taille du f�mur en fonction de lhum�rus (en cm)');
xtitle('taille de lhum�rus(en cm)');
ytitle('taille du f�mur (en cm)');
x = X(1,:);
y = X(2,:);

var(x);
var(y);
cov(x,y);
a = (cov(x,y))/(var(x));
b = (sum(y)/5) - a * (sum(x)/5);
hold on 

plot (x , a * x + b , 'r');
legend('','r�gression selon la m�thode du moindre carr�');
hold off
g_test = a * 68.4 - b;

r = cov(x,y) / sqrt(var(x) * var(y)); 

