import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import time

# Author: James O'Kane, 2026

#Option data
K = 2500
# Market data
S_0 : float = 2500              # spot
r : float  = 0.05               # rate
sigma : float = 0.2             # volatility
# Model data
T : float = 1                   # monte-carlo time horizon (years) [= expiry of option]
no_of_timesteps : int = 250     # twice a business day (roughly)
no_of_simulations : int = 100000

def draw_graph(S):
	price_path = pd.DataFrame(S)
	fig, ax = plt.subplots()
	ax.plot(price_path.iloc[:, :1000]);
	ax.set_title("Monte Carlo Simulation")
	ax.set_xlabel("Time steps")	
	plt.show()
	
# European call option payout
def Euro_call_payout(K: float, S: float) -> float:
	return max(S - K, 0)

# S is the 2D array of spots	
def value_call_option(K: float, T: float, r: float, sigma: float, S_0: float, S: np.ndarray) -> float:
	np.random.seed(1000000) #w should be the same as the last simulation run.
	S[0] = S_0
	for i in range(0, no_of_timesteps-1):
		w = np.random.standard_normal(no_of_simulations)
		S[i+1] = S[i] * np.exp((r - (sigma**2)/2)*dt - sigma*np.sqrt(dt)*w)

	Sum_PVs : float = 0.0
	for sim in range(0, no_of_simulations):
		Sum_PVs = Sum_PVs + Euro_call_payout(K, S[no_of_timesteps-1, sim])
		#print(f"{sim} -> Sum(PV)={Sum_PVs}")
	return np.exp(-r*T) * (Sum_PVs/no_of_simulations)
	


print(f"No of simulations={no_of_simulations}")
print(f"No of time steps={no_of_timesteps}")
valuation_start = time.perf_counter()

# define dt
dt = T/no_of_timesteps      # length of time interval

# simulate 'n' asset price path with 't' timesteps
S = np.zeros((no_of_timesteps, no_of_simulations))

#value the call option.
PV = value_call_option(K, T, r, sigma, S_0, S)
print(f"Est. PV = {PV}")

#draw_graph(S)

duration = time.perf_counter() - valuation_start
print(f"Time taken so far is {duration:.6f} seconds")

# Greeks ################################

# Delta
PV_shifted = value_call_option(K, T, r, sigma, S_0+0.01, S)
delta = (PV_shifted - PV)/0.01
print(f"Delta = {delta}")

# Gamma.
PV_shifted_minus = value_call_option(K, T, r, sigma, S_0-0.01, S)
gamma = (PV_shifted_minus - 2*PV + PV_shifted)/0.001
print(f"Gamma = {gamma}")

#Vega
PV_shifted = value_call_option(K, T, r, sigma+0.001, S_0, S)
vega = (PV_shifted - PV)/0.001
print(f"Vega = {vega}")

# Theta.
PV_shifted = value_call_option(K, T-0.001, r, sigma, S_0, S)
theta = (PV_shifted - PV)/0.001
print(f"Theta = {theta}")

#Rho
PV_shifted = value_call_option(K, T, r+0.001, sigma, S_0, S)
rho = (PV_shifted - PV)/0.001
print(f"Rho = {rho}")

duration = time.perf_counter() - valuation_start
print(f"Total time taken is {duration:.6f} seconds")

# Theta 2.0
Sum_PVs = 0.0
for sim in range(0, no_of_simulations):
	Sum_PVs = Sum_PVs + Euro_call_payout(K, S[no_of_timesteps-2, sim])
PV_minus = np.exp(-r*(T-dt)) * (Sum_PVs/no_of_simulations)
theta = (PV - PV_minus)/dt
print(f"Theta = {theta}")