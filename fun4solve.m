function  p=fun4solve(vars4solve)

campos = fieldnames(vars4solve);

% Unzip de vars4fsolve
for icampo = 1 : length(campos)
    eval( sprintf('%s = vars4solve.%s;',campos{icampo},campos{icampo}) )
end

p=1;


end

