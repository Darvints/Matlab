function v = npv(r, cashflow)
    v = sum(cashflow ./ (1 + r) .^ (0:numel(cashflow)-1));
end