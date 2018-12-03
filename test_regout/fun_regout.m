function newa = fun_regout(a, b)

betas = fun_calbeta(a, b);

newa = a - b * betas;

end

