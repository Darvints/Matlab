% Initialisation des paramtres
mu_risky = 0.06;
sigma_risky = 0.2;
mu_riskless = 0.03;
sigma_riskless = 0.05;
T = 40;
dt = 1;
t = 0:dt:T;
nScenarios = 10000;
initialWealth = 40000;
income = initialWealth;
growth_rate = 0.03;
combustion_rate = 0.10;
contribution_rate = 1 - combustion_rate;

% Simulation des trajectoires de prix
S_risky = cumprod(exp((mu_risky - 0.5*sigma_risky^2)*dt + sigma_risky*sqrt(dt)*randn(T/dt + 1, nScenarios)));
S_riskless = cumprod(exp((mu_riskless - 0.5*sigma_riskless^2)*dt + sigma_riskless*sqrt(dt)*randn(T/dt + 1, nScenarios)));

% Buy & Hold Strategy
allocation_risky_BH = 0.6;
allocation_riskless_BH = 1 - allocation_risky_BH;
portfolioValue_BH = zeros(length(t), nScenarios);
portfolioValue_BH(1,:) = initialWealth;

for i=2:length(t)
    income = income * (1 + growth_rate); 
    contribution = income * contribution_rate;
    portfolioValue_BH(i,:) = (portfolioValue_BH(i-1,:) + contribution).*(allocation_risky_BH.*S_risky(i,:)+allocation_riskless_BH.*S_riskless(i,:));
end

% Life-Cycle Strategy
portfolioValue_LC = zeros(length(t), nScenarios);
portfolioValue_LC(1,:) = initialWealth;

for i=2:length(t)
    if t(i) <= 20 % de 25 � 45 ans
        allocation_risky_LC = 0.8;
        allocation_riskless_LC = 0.2;
    elseif t(i) <= 30 % de 45 � 55 ans
        allocation_risky_LC = 0.8 - 0.03*(t(i)-20);
        allocation_riskless_LC = 0.2 + 0.03*(t(i)-20);
    else % de 55 � 65 ans
        allocation_risky_LC = 0.5 - 0.035*(t(i)-30);
        allocation_riskless_LC = 0.5 + 0.035*(t(i)-30);
    end
    income = income * (1 + growth_rate);
    contribution = income * contribution_rate;
    portfolioValue_LC(i,:) = (portfolioValue_LC(i-1,:) + contribution).*(allocation_risky_LC.*S_risky(i,:)+allocation_riskless_LC.*S_riskless(i,:));
end

% CPPI Strategy
m_riskless=20;
m_risky=5;
F0 = initialWealth; % you should decide the exact value
Ft = F0; % you should decide about the dynamics of the floor
portfolioValue_CPPI = zeros(length(t), nScenarios);
portfolioValue_CPPI(1,:) = initialWealth;

for i=2:length(t)
    % here we assume the floor Ft to be a fixed fraction of the initial portfolio value, this should be adapted
    Ft = F0*0.8; 
    cushion = max(0, portfolioValue_CPPI(i-1,:)-Ft);
    allocation_risky_CPPI = min(1, max(0, m_risky.*cushion./portfolioValue_CPPI(i-1,:)));
    allocation_riskless_CPPI = 1 - allocation_risky_CPPI;
    income = income * (1 + growth_rate);
    contribution = income * contribution_rate;
    portfolioValue_CPPI(i,:) = (portfolioValue_CPPI(i-1,:) + contribution).*(allocation_risky_CPPI.*S_risky(i,:)+allocation_riskless_CPPI.*S_riskless(i,:));
end

% Calculate statistics for each strategy
strategies = {'Buy & Hold', 'Life Cycle', 'CPPI'};
portfolio_values = {portfolioValue_BH, portfolioValue_LC, portfolioValue_CPPI};

for j=1:length(strategies)
    meanPortfolioValue = mean(portfolio_values{j}(end, :));
    medianPortfolioValue = median(portfolio_values{j}(end, :));
    VaR_95 = quantile(portfolio_values{j}(end, :), 0.05);
    VaR_99 = quantile(portfolio_values{j}(end, :), 0.01);
    CVaR_95 = mean(portfolio_values{j}(end, portfolio_values{j}(end, :) <= VaR_95));
    CVaR_99 = mean(portfolio_values{j}(end, portfolio_values{j}(end, :) <= VaR_99));
    
    % Print statistics
    disp(['Strategy: ', strategies{j}])
    disp(['Mean portfolio value: ', num2str(meanPortfolioValue)])
    disp(['Median portfolio value: ', num2str(medianPortfolioValue)])
    disp(['VaR 95%: ', num2str(VaR_95)])
    disp(['VaR 99%: ', num2str(VaR_99)])
    disp(['CVaR 95%: ', num2str(CVaR_95)])
    disp(['CVaR 99%: ', num2str(CVaR_99)])
    disp('--------------------------')
end

% Calculate IRR for each scenario and each strategy
irr_values = cell(1, length(strategies));

for j=1:length(strategies)
    irr_values{j} = zeros(1, nScenarios);
    for i=1:nScenarios
        cashFlow = [-initialWealth, diff(portfolio_values{j}(:,i)')];
        irr_values{j}(i) = irr(cashFlow);
    end
    
    % Calculate and print statistics
    meanIrr = mean(irr_values{j});
    medianIrr = median(irr_values{j});
    VaR_95_Irr = quantile(irr_values{j}, 0.05);
    VaR_99_Irr = quantile(irr_values{j}, 0.01);
    CVaR_95_Irr = mean(irr_values{j}(irr_values{j} <= VaR_95_Irr));
    CVaR_99_Irr = mean(irr_values{j}(irr_values{j} <= VaR_99_Irr));

    disp(['Strategy: ', strategies{j}])
    disp(['Mean IRR: ', num2str(meanIrr)])
    disp(['Median IRR: ', num2str(medianIrr)])
    disp(['VaR 95% IRR: ', num2str(VaR_95_Irr)])
    disp(['VaR 99% IRR: ', num2str(VaR_99_Irr)])
    disp(['CVaR 95% IRR: ', num2str(CVaR_95_Irr)])
    disp(['CVaR 99% IRR: ', num2str(CVaR_99_Irr)])
    disp('--------------------------')
end




