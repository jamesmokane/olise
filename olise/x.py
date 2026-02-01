import numpy as np
import math
import sys
import x1wings as xw

def ncr(n,r):
	f = math.factorial
	return f(n) // f(r) // f(n-r)

def parse_args():
	args_dict = {}
	for arg in sys.argv[1:]:
		if "=" in arg:
			name, value = arg.split("=", 1)
			args_dict[name] = value
	return args_dict

@xw.func
def simple_test_fun(int not_used):
    return "Hello"

@xw.func
def BinomialTree(K, S, T, vol, r, principal, N):
	dT = T/N
	u = np.exp(vol*np.sqrt(dT))
	d = 1 / u 
	p = (np.exp(r*dT) - d) / (u - d)
	q = 1 - p 

	#print("u=" + str(u))
	#print("d=" + str(d))
	#print("p=" + str(p))
	#print("q=" + str(q))

	table = np.zeros((N+1,N+1))
	table[0,0] = S
	for j in range (0,N):
		for i in range(0,j+1):
			#print("calculating (r,c)=(" + str(i) + "," + str(j) + "), val=" + str(table[i,j]))
			table[i,j+1] = u * table[i,j]
			table[i+1, j+1] = d * table[i,j]

	expected_payout = [0] * (N+1)
	for i in range(0, N+1):
		payout = max(table[i, N] - K, 0)
		expected_payout[i] = payout * ncr(N,i) * p**(N-i) * q**i
        
	FV = 0.0
	for i in range(0, N+1):
		FV = FV + expected_payout[i]
	FV = FV * principal
	print("FV = " + str(FV))
	PV = np.exp(-r*T) * FV
	print("PV = " + str(PV))
	return PV

#params = parse_args()
#BinomialTree(float(params["K"]), float(params["S"]), float(params["T"]), float(params["vol"]), float(params["r"]), float(params["principal"]), int(params["N"]))
