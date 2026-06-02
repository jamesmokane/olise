# Betting on Monte-carlo

So far I've concentrated on analytic pricing formulas and binomial tree pricing. These were covered in University and it has been interesting to implement them.
But they have limitations. Not all instruments have analytic solutions, and varying the interest rate and volatility over the lifetime of an option can lead to binomial trees that do not recombine.

This project using Monte-carlo methods to value a simple European call option with constant interest rate and volatility.
I used the same option as before: K=2500, T=1(year)
as well as the same market data: S=2500, r=0.5, vol=0.2
The analytic value of the option is 261.2646

Monte-carlo was very slow in comparison. The table below shows the effect of the number of simulations on the accuracy of pricing.


500 timesteps.
| Number of simulations | PV | Difference | Time (sec) |
|:----------------------|:---|:-----------|:-----|
| 10,000 | 258.5538 | 2.7108 | 0.146 |
| 100,000 | 261.0809 | 0.1837 | 1.72 |
| 1,000,000 | 260.8728 | 0.3918 | 22.13 |

The number of timesteps also made a difference.
 
 100,000 simulations.
| Number of timesteps | PV | Difference | Time (sec) |
|:----------------------|:---|:-----------|:-----|
| 250 | 260.1231 | 1.1415 | 0.86 |
| 500 | 261.0809 | 0.1837 | 1.72 |

Variance reduction techniques were also implemented but had no discernible effect on PV calculations so have no been included in the results.

The following values were obtained for the Greeks:
| Greek | value | Analytic value |
|:------|:-------|:-------|
| Delta | 0.6384 | 0.6368 |
| Gamma | 0.0001 | 0.0008 |
| Vega | 936.371 | 938.100 |
| Theta | 13.054 | -160.351 |
| Rho | 1333.5969 | 1330.8121 |
 
Not all the greeks matched well. There were significant differences between the analytic gamma and theta and the equivalent Monte-carlo values.

The gamma value is a second order calculation so there is no real surprise that gamma value contained more error that the delta.

Theta was a bit of a surprise and more investigation is needed to determine why.

The Central Limit Theorem says that the standard error (SE) of a Monte-carlo simulation is given by

<div style="text-align: center;"> SE = (std. dev. of payoffs)/sqrt(M) </div>

where M is the number of simulations