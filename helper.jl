using JuMP
using DataFrames, Ipopt
using MultiObjectiveAlgorithms
using Plots
using Statistics
using StatsPlots

using Printf
const MOA = MultiObjectiveAlgorithms



df_prices = DataFrames.DataFrame(
    [
70.23	199.47	146.38	153.56	161.58	24.54	413.02	223.36	178.38	55.24
76.43	214.81	158.65	163.00	171.08	25.67	427.22	226.90	180.65	55.02
64.08	207.15	161.54	124.28	154.46	24.46	390.93	228.63	176.91	57.78
68.29	228.07	160.71	120.21	145.83	23.37	391.81	231.43	171.14	56.68
70.29	217.86	159.92	106.21	134.15	21.35	357.96	226.54	168.46	56.26
76.67	221.60	157.23	134.95	159.46	23.27	392.61	243.01	164.10	57.80
77.18	215.18	145.35	126.77	154.27	21.75	376.59	232.78	159.27	55.58
71.49	203.39	148.16	113.00	135.79	18.88	340.38	214.07	154.67	50.46
70.66	243.95	157.79	102.44	150.67	19.88	369.55	252.96	151.91	54.30
77.23	258.44	161.44	96.54	145.45	21.21	390.10	253.08	164.81	57.71
76.61	238.63	161.25	84.00	127.88	20.41	365.94	245.86	169.64	58.12
68.39	229.33	149.17	103.13	142.01	22.35	390.74	249.47	179.41	56.03
65.09	210.48	139.90	94.23	145.08	21.30	380.91	246.22	169.78	54.38
71.10	221.59	142.51	103.29	162.55	20.61	393.53	262.37	183.22	56.68
70.68	219.74	150.50	105.45	167.26	21.08	401.35	277.52	184.80	59.07
67.76	202.25	142.56	120.58	174.72	20.26	403.20	267.53	182.32	54.93
68.88	205.42	153.33	130.36	191.46	20.79	427.74	280.01	178.27	55.45
68.04	216.65	155.19	133.68	193.91	21.61	443.38	276.58	182.35	57.46
62.01	237.18	149.77	138.01	185.44	20.85	436.17	265.22	180.02	55.51
53.55	250.68	145.32	127.12	169.23	19.27	414.02	249.85	171.45	51.94
54.49	238.50	138.41	133.09	168.79	18.61	406.46	248.64	184.09	52.82
54.69	251.50	144.31	146.09	187.75	20.58	443.59	267.30	188.75	54.65
57.24	270.76	147.42	151.94	190.55	22.29	461.97	282.90	191.17	55.54
55.25	295.43	149.45	155.20	182.50	21.55	471.23	279.28	188.45	56.07
52.01	257.42	151.78	176.76	178.89	21.60	495.82	278.86	189.31	56.57
60.77	269.37	149.91	180.38	169.93	22.05	510.45	270.54	205.72	57.67
63.68	259.54	137.02	175.00	168.79	20.71	491.39	261.99	211.87	58.69
76.09	289.77	138.99	176.44	190.52	21.62	516.25	248.41	215.30	59.79
67.34	298.12	139.63	193.25	209.00	21.77	532.74	244.52	215.01	60.47
73.11	317.23	150.80	186.98	220.38	23.21	540.93	256.31	226.55	63.90
77.06	318.52	158.45	178.50	227.24	24.50	553.57	278.77	231.29	69.39
81.43	309.58	155.99	186.33	231.48	25.07	563.47	294.08	243.06	68.80
76.34	307.61	153.88	186.40	224.44	24.19	560.15	283.75	253.51	62.96
75.78	271.78	149.21	207.89	235.78	24.95	593.56	287.53	245.59	61.78
69.52	252.42	140.32	219.39	249.06	22.73	577.33	281.59	242.13	60.48
69.40	276.42	147.63	237.68	234.72	23.45	594.83	282.12	258.56	61.66
68.05	298.35	160.12	212.28	240.53	24.09	587.28	301.30	263.27	69.17
69.31	304.17	162.20	190.26	221.17	23.39	552.90	305.25	288.14	69.57
65.39	284.03	152.88	184.42	211.58	23.42	549.75	314.17	303.77	70.99
69.07	281.35	151.81	205.01	199.98	24.08	584.30	308.47	303.60	70.55
67.87	275.00	150.68	219.39	204.55	23.94	612.52	287.16	304.83	69.23
70.04	290.65	162.51	234.11	206.94	23.88	628.48	296.60	302.96	66.90
71.02	283.37	174.77	229.00	231.44	24.97	641.37	309.91	318.07	67.99
74.98	280.20	184.25	219.57	254.15	24.96	662.38	300.37	355.47	65.36
80.85	296.32	187.68	244.22	269.86	24.83	680.05	296.65	368.12	68.42
85.71	343.01	205.61	233.22	278.32	25.27	681.38	309.96	387.88	72.61
80.28	327.31	206.95	230.82	271.61	24.57	679.91	303.81	396.31	69.42
87.90	341.88	227.25	239.30	259.24	25.67	691.97	315.00	444.95	74.81

    ],
    [:NEE, :AMGN, :JNJ, :AMZN, :AAPL, :REET, :SPY, :MCD, :GLD, :KO],
)

df_dividends = DataFrames.DataFrame(
    [
0.43	1.94	1.06	0.00	0.22	0.00	0.00	1.38	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.42	1.94	1.13	0.00	0.23	0.13	1.37	0.00	0.00	0.44
0.00	0.00	0.00	0.00	0.00	0.14	1.58	1.38	0.00	0.44
0.43	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	1.94	1.13	0.00	0.23	0.00	0.00	1.38	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.28	1.60	0.00	0.00	0.44
0.40	0.00	0.00	0.00	0.00	0.00	0.00	1.52	0.00	0.00
0.00	1.94	1.13	0.00	0.23	0.00	0.00	0.00	0.00	0.44
0.00	0.00	0.00	0.00	0.00	0.00	1.78	0.00	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.47	2.13	1.13	0.00	0.23	0.00	0.00	1.52	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.47	2.13	1.19	0.00	0.24	0.15	1.51	0.00	0.00	0.46
0.00	0.00	0.00	0.00	0.00	0.13	1.64	1.52	0.00	0.46
0.47	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	2.13	1.19	0.00	0.24	0.00	0.00	1.52	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	1.58	0.00	0.00	0.46
0.47	0.00	0.00	0.00	0.00	0.26	0.00	0.00	0.00	0.00
0.00	2.13	1.19	0.00	0.24	0.00	0.00	1.67	0.00	0.46
0.00	0.00	0.00	0.00	0.00	0.24	1.91	0.00	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.52	2.25	1.19	0.00	0.24	0.00	0.00	1.67	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.52	2.25	1.24	0.00	0.25	0.13	1.59	0.00	0.00	0.49
0.00	0.00	0.00	0.00	0.00	0.07	1.76	1.67	0.00	0.49
0.52	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	2.25	1.24	0.00	0.25	0.00	0.00	1.67	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.25	1.75	0.00	0.00	0.49
0.57	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	2.25	1.24	0.00	0.25	0.00	0.00	1.77	0.00	0.49
0.00	0.00	0.00	0.00	0.00	0.41	1.97	0.00	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.57	2.38	1.24	0.00	0.25	0.00	0.00	1.77	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.57	2.38	1.30	0.00	0.26	0.13	1.70	0.00	0.00	0.51
0.00	0.00	0.00	0.00	0.00	0.17	1.76	1.77	0.00	0.51
0.57	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	2.38	1.30	0.00	0.26	0.00	0.00	1.77	0.00	0.00
0.00	0.00	0.00	0.00	0.00	0.23	1.83	0.00	0.00	0.51
0.57	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
0.00	2.38	1.30	0.00	0.26	0.00	0.00	1.86	0.00	0.51
0.00	0.00	0.00	0.00	0.00	0.38	1.99	0.00	0.00	0.00

    ],
    [:NEE, :AMGN, :JNJ, :AMZN, :AAPL, :REET, :SPY, :MCD, :GLD, :KO],
)

function format_portfolio(tickers, weights_percent, weights_cash)
    clean_cash = [v < 1e-5 ? "0.00" : @sprintf("%.2f", v) for v in weights_cash]
    clean_percent = [v < 1e-5 ? 0.0 : round(v, digits = 2) for v in weights_percent]
    
    return DataFrame(
        Ticker = tickers,
        Weight_Percent = clean_percent,
        Cash_Allocation = clean_cash
    )
end

C = 76679.38

ri_month = (diff(Matrix(df_prices); dims = 1) + Matrix(df_dividends)) ./ Matrix(df_prices[1:(end-1), :])
mi_month = vec(Statistics.mean(ri_month; dims = 1))
Q = Statistics.cov(ri_month)

# JuMP formulation
model_maxSR = Model(Ipopt.Optimizer)
set_silent(model_maxSR)

@variable(model_maxSR, w[1:10] >= 0)
@constraint(model_maxSR, sum(w) == 1)

portfolio_return = mi_month' * 12 * w
portfolio_risk = sqrt(w' * Q * w * 12)
S_R = (portfolio_return-0.04)/portfolio_risk + 1e-9

@objective(model_maxSR, Max, S_R)
optimize!(model_maxSR)

SR_return_percent = value(portfolio_return) * 100
SR_risk_percent = value(portfolio_risk) * 100
SR_return_cash = value(portfolio_return) * C
SR_risk_cash = value(portfolio_risk) * C
sharpe_ratio_val = value(S_R)

tickers_list = ["NEE", "AMGN", "JNJ", "AMZN", "AAPL", "REET", "SPY", "MCD", "GLD", "KO"]
portfolio_df = format_portfolio(tickers_list, value.(w) * 100, value.(w) * C)

println("-"^45)
println("ОПТИМАЛЬНИЙ ПОРТФЕЛЬ")
println(" "^45)
@printf("Очікувана доходність: %.2f%% (%.2f \$)\n", SR_return_percent, SR_return_cash)
@printf("Ризик (волатильність): %.2f%% (%.2f \$)\n", SR_risk_percent, SR_risk_cash)
@printf("Коефіцієнт Шарпа:      %.4f\n", sharpe_ratio_val)
println(" "^45)
println(portfolio_df)

# Multiobjective portfolio optimization
model = Model(() -> MOA.Optimizer(Ipopt.Optimizer))
set_silent(model)
set_optimizer_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())
set_optimizer_attribute(model, MOA.SolutionLimit(), 36)

@variable(model, x[1:10] >= 0)
@constraint(model, sum(x) == C)

@expression(model, portfolio1_risk, sqrt(x' * Q * x * 12))
@expression(model, portfolio1_return, mi_month' * 12 * x)

@objective(model, Min, [portfolio1_risk, -portfolio1_return])
optimize!(model)

objective_space = Plots.hline(
    [SR_return_cash];
    label = "Single-objective solution",
    linecolor = :red,
)
Plots.vline!(objective_space, 
    [SR_risk_cash]; label = "", 
    linecolor = :red,
)
risks = [value(portfolio1_risk; result = i) for i in 1:result_count(model)]
returns = [value(portfolio1_return; result = i) for i in 1:result_count(model)]

x_min, x_max = minimum(risks) * 0.95, maximum(risks) * 1.05
y_min, y_max = minimum(returns) * 0.95, maximum(returns) * 1.05

Plots.scatter!(
    objective_space,
    risks,
    returns;
    xlims = (x_min, x_max),
    ylims = (y_min, y_max),
    xlabel = "Risk (\$)",
    ylabel = "Return (\$)",
    label = "Efficient Frontier",
    title = "Efficient Frontier",
    
    markercolor = :white,
    markersize = 12,          
    markerstrokewidth = 1.5,   
    markerstrokecolor = :black,
    
    legend = :bottomright,
    formatter = :plain,        
    xrotation = 15             
)

for i in 1:result_count(model)
    y = objective_value(model; result = i)
    Plots.annotate!(objective_space, y[1], -y[2], 
        text(string(i), 7, :black, :center) 
    )
end

decision_space = StatsPlots.groupedbar(
    vcat([value.(x; result = i)' for i in 1:result_count(model)]...);
    bar_position = :stack,
    label = ["NEE" "AMGN" "JNJ" "AMZN" "AAPL" "REET" "SPY" "MCD" "GLD" "KO"],
    xlabel = "Solution #",
    ylabel = "Investment (\$)",
    title = "Decision space",
    legend = :outerright,
    formatter = :plain   
)
p = Plots.plot(objective_space, decision_space; layout = (2, 1), size = (850, 850))
display(p)

#choice
target_solution = 1  

choice_objectives = objective_value(model; result = target_solution)
choice_risk_cash = choice_objectives[1]
choice_return_cash = -choice_objectives[2]

choice_weights_cash = value.(x; result = target_solution)
choice_weights_percent = (choice_weights_cash ./ C) * 100
choice_risk_percent = (choice_risk_cash / C) * 100
choice_return_percent = (choice_return_cash / C) * 100
choice_sharpe = (choice_return_percent/100 - 0.04) / (choice_risk_percent/100)

choice_portfolio_df = format_portfolio(tickers_list, choice_weights_percent, choice_weights_cash)

println("-"^45)
@printf("РІШЕННЯ №%d З ЕФЕКТИВНОЇ МЕЖІ\n", target_solution)
println(" "^45)
@printf("Очікувана доходність: %.2f%% (%.2f \$)\n", choice_return_percent, choice_return_cash)
@printf("Ризик (волатильність): %.2f%% (%.2f \$)\n", choice_risk_percent, choice_risk_cash)
@printf("Коефіцієнт Шарпа:      %.4f\n", choice_sharpe)
println(" "^45)
println(choice_portfolio_df)