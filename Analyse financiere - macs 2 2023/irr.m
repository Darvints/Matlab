function r = irr(cashflow)
    r = 0.1; % initial guess
    for j = 1:100
        r = r - npv(r, cashflow) / max([dnpv(r, cashflow), 0.00001]);
        r = max([r, -0.99999]); % introduce lower bound to r
    end
end
