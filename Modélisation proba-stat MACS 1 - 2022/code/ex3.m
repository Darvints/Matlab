#exercice3

X = [1 2 3 4 5 6 7 8 9 10 11 12 ; 3.5 3.5 3.3 4.4 4.4 4.2 5.1 5.3 5.5 5.5 6.2 5.7];
x = X(1,:);
y = X(2,:);

a = cov(x,y)/ var(x);
b = sum(y)/12 - a * sum(x)/12;

r = cov(x,y)/sqrt(var(x) * var(y));

plot(x,y,'--',x,a*x+b,'o');
title('poids selon âge');
xlabel('âge');
ylabel('poids');
legend('poids selon âge de léchantillon','poids selon âge du modéle');

y_tild = a*x+b;

err = abs(y_tild-y);

plot(x , err,'+');
title('erreur entre léchantillonage et la prédiction');
xlabel('âge');
ylabel('erreur');
