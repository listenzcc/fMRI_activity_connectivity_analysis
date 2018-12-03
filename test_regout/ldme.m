close all
clear
clc

n = 200;

b = randn(n, 1);
a1 = mod([1:n]', 15) + 3.3*b;
a2 = mod([1:n]', 10) + 2.7*b;
a = [a1, a2];

fun_calbeta(a, b)
g = [];
for e = a
    s = spm_glm(e, b);
    g = [g, s.w];
end
g

newa = fun_regout(a, b);
figure,
plot(a)
hold on
plot(newa, 'linewidth', 2)
hold off