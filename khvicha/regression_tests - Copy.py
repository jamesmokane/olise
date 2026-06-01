import numpy as np
from analyticoptionprices import BS_call_greeks

error_count	= 0
epsilon = 0.00000001
test_number = 0

def inc_error_count():
	global error_count
	error_count = error_count + 1

def assert_within_tolerance(desc, a, b):
	if(abs(a - b) > epsilon):
		inc_error_count()
		print("Test " + str(test_number) + ": " +desc + " failed. Expected " + str(b) + ", got " + str(a))

#
# See regression_tests__greeks_calculation.xlsx for sources of greek values.
#

c = BS_call_greeks(2500, 2500, 1, 0.05, 0.20, 1)
if(len(c) != 6):
	inc_error_count()
	print("BS_call_greeks failed. Expected tuple of length 6, got " + str(len(c)))
else:
	PV = c[0]
	delta = c[1]
	gamma = c[2]
	rho = c[3]
	vega = c[4]
	theta = c[5]
	epsilon = 0.0001
	test_number += 1
	assert_within_tolerance("PV", PV, np.float64(261.2644))
	assert_within_tolerance("delta", delta, np.float64(0.6368))
	assert_within_tolerance("gamma", gamma, np.float64(0.0008))
	assert_within_tolerance("rho", rho, np.float64(1330.8121))
	assert_within_tolerance("vega", vega, np.float64(938.1009))
	assert_within_tolerance("theta", theta, np.float64(-160.3507))
	


c = BS_call_greeks(60, 50, 1, 0.0375, 0.20, 1)
if(len(c) != 6):
	inc_error_count()
	print("BS_call_greeks failed. Expected tuple of length 6, got " + str(len(c)))
else:
	PV = c[0]
	delta = c[1]
	gamma = c[2]
	rho = c[3]
	vega = c[4]
	theta = c[5]
	epsilon = 0.00000001
	test_number += 1
	assert_within_tolerance("PV", PV, np.float64(1.4701448308486285))
	assert_within_tolerance("delta", delta, np.float64(0.2662784011367616))
	assert_within_tolerance("gamma", gamma, np.float64(0.03283438829406933))
	assert_within_tolerance("rho", rho, np.float64(11.843775225989452))
	assert_within_tolerance("vega", vega, np.float64(13.31392005683808))
	assert_within_tolerance("theta", theta, np.float64(0.8872504347092038))
	
if(error_count == 0):
	print ("All tests passed");