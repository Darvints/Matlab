#exercice4

X = [0.2 0.2 0.4 0.4 0.6 0.6 0.8 0.8 1.0 1.0;2.9 3.0 3.5 3.6 4.0 4.2 4.7 4.9 5.3 5.4];
x = X(1,:);
y = X(2,:);
plot(x,y);
title('densité selon quantité d antibiotique');
xlabel('antibiotique');
ylabel('densité');
a = (4.15-2.335)/0.6;
eq = a*x +2.335;
plot(x,y,'--',x,eq);
title('densité selon quantité d antibiotique');
xlabel('antibiotique');
ylabel('densité');

v_x_ech = 0.0889;
v_y_ech = 0.8206;
err_mod = 0.0645;
mse = sum((eq-y).^2)/8;
sxx = sum((x - sum(x)/10).^2);
beta_0 = sqrt(mse*(0.1+((sum(x)/10)^2)/sxx));
beta_1 = sqrt(mse/sxx);

pente_tild = sum((y-2.335)./x)/length(x);
I_min = pente_tild - 1.96*(sqrt(v_x_ech)/sqrt(length(x)));

I_a = (a * 0.9)+2.335 - 1.96*(sqrt(var(y))/sqrt(length(x)));
I_b = (a * 0.9)+2.335 + 1.96*(sqrt(var(y))/sqrt(length(x)));
int = [I_a I_b];

X_2 = [0.2 0.4 0.6 0.8 1.0; 2.95 3.55 4.1 4.8 5.35];
