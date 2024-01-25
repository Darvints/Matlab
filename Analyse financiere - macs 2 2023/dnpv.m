function v = dnpv(r, cashflow)
    v = -sum((0:numel(cashflow)-1) .* cashflow ./ (1 + r) .^ (1:numel(cashflow)));
end