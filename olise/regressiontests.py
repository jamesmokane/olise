from option_prices import BinomialTree 


PV = BinomialTree(60, 50, 10, 0.2, 0.05, 100000, 9)
print(PV)
if abs(PV - 1844081.3345277142) > 0.00000001:
    print("Failure")
else:
    print("Passed")
    