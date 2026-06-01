import numpy as np
import math
import sys
import xlwings as xw
from scipy.stats import norm

@xw.func
def BS_call_greeks(K, S, T, r, vol, principal):
	sqrt_T = math.sqrt(T)
	vol_sqrt_T = vol*math.sqrt(T)
	
	d1 = (math.log(S/K) + (r + 0.5 * vol**2)*T)/vol_sqrt_T
	d2 = d1 - vol_sqrt_T	
	PV = S*norm.cdf(d1) - K* math.exp(-r*T)*norm.cdf(d2)
	PV = PV * principal
	
	delta = norm.cdf(d1) * principal
	
	gamma = norm.pdf(d1)/(S*vol_sqrt_T) * principal
	
	rho = K*T*math.exp(-r*T)*norm.cdf(d2) * principal
	
	vega = S*sqrt_T*norm.pdf(d1) * principal
	
	theta = -(S*norm.pdf(d1)*vol)/(2*sqrt_T) - r*K*math.exp(-r*T)*norm.cdf(d2)
	theta = theta * principal
    	
	return PV, delta, gamma, rho, vega, theta
	


