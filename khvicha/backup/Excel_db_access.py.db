import xlwings as xw
import pyodbc
import pandas as pd
from datetime import datetime
#from analyticoptionprices import BS_call_greeks as greeks
import analyticoptionprices as greeks

# Needs to be expanded to take into consideration discounting of initial and final cashflows.		
@xw.func
def value_trade(as_of_time : str, S, rate, vol, trade):
	wb = xw.Book.caller()
	sheet = wb.sheets['Position'] 
	
	notional = trade["notional"];
	strike = trade["strike"];
	trade_type = trade["trade_type"];
	expiry_date = trade["expiry_date"];
	
	# T calculation
	d1 = datetime.fromisoformat(as_of_time)
	d2 = datetime.strptime(expiry_date, "%Y-%m-%d")	
	diff = d2 - d1
		
	if(T <= 0):
		return (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)  # expired option.				
	if(trade_type.lower() == "call"):
		val = greeks.BS_call_greeks(strike, S, T, rate, vol, notional)
		return val
	else:
		# Not recognised.
		raise ValueError(f"Unrecognised trade type {trade_type}")

@xw.func	
def value_portfolio(portfolio_ID, as_of_time: str, S, rate, vol):
    wb = xw.Book.caller()
    sheet = wb.sheets['Position'] 
    #sheet.range('Q5').value = "value_portfolio called"
    try:
        conn = pyodbc.connect('DSN=Hermes')	
        cursor = conn.cursor()		
		
	    # Get a new validation ID
        # (a) Insert new valuation header record.
        command = "INSERT INTO valuations (portfolio_ID, valuation_time, S, rate, vol) VALUES (?,?,?,?,?)"	
        iso_time = datetime.now().isoformat()
        conn.execute(command, [portfolio_ID, iso_time, S, rate, vol])
	    # (b) Read the new valuation ID.
        query = "SELECT max(ID) FROM valuations WHERE portfolio_ID=?"
        cursor.execute(query, [portfolio_ID])
        new_valuation_ID = cursor.fetchall()[0][0];
        sheet.range('Q6').value = "new valuation ID=" + str(new_valuation_ID)
		
	    # Cycle through the trades and value each
        query = "SELECT trade_ID, leg, notional, trade_type, premium, trade_date, expiry_date, strike, barrier1, barrier2, settlement_date, delivery_date, model FROM trades WHERE portfolio_ID=?"
        cursor.execute(query, [portfolio_ID])
        columns = [column[0] for column in cursor.description]	
        sheet.range('Q7').value = "trades retrieved"
				
        rows = cursor.fetchall()
        cursor.close()
        for row in rows:
            trade = dict(zip(columns, row))
            
            val = value_trade(as_of_time, S, rate, vol, trade)
            command = "INSERT INTO trade_valuations (valuation_ID, trade_ID, leg, model, PV, delta, gamma, rho, vega, theta) VALUES (?,?,?,?,?,?,?,?,?,?)"			
            conn.execute(command, [new_valuation_ID, trade["trade_ID"], trade["leg"], "std", val[0], val[1], val[2], val[3], val[4], val[5]])
		
        conn.commit()
        conn.close()    
        return new_valuation_ID
    except Exception as e:
        sheet.range('Q8').value = f"Exception: {e} {as_of_time}"
        conn.rollback()
        conn.close() 
        return -1

if __name__ == '__main__':
    xw.serve()