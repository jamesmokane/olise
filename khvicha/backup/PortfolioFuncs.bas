Attribute VB_Name = "PortfolioFuncs"
' Create a new set of trade valuations based on the current market data.
' (1) Refresh the trades view for the portfolio.
' (2) Value the trades - insert new trade_valuations into the DB for each trade <- DB update,
'     and refresh the valuation view
Public Sub revalue()
    ActiveWorkbook.RefreshAll
    DoEvents
    Dim underlying As String
    Dim S As Double, port_rate As Double, port_vol As Double
    
    ' Get entered market data
    S = Range("port_S").Value
    port_rate = Range("port_rate").Value
    port_vol = Range("port_vol").Value
    
    Dim ok As Boolean
    Dim portfolio_ID As Integer, valuation_ID As Integer
    portfolio_ID = 1
    valuation_ID = 1
    ok = refresh_trades(portfolio_ID)
    If ok = True Then ok = value_portfolio(portfolio_ID, S, port_rate, port_vol)
    If ok = True Then ok = refresh_valuation(valuation_ID)
    If ok Then MsgBox "Revaluation complete" Else MsgBox "Revaluation failed"
    ActiveWorkbook.RefreshAll
    DoEvents
End Sub

' Refresh the trade and valuation view.
' No recalculation.
Public Sub refresh()
    ActiveWorkbook.RefreshAll
    DoEvents
    Dim underlying As String
    Dim S As Double, port_rate As Double, port_vol As Double
     
    Dim ok As Boolean
    Dim portfolio_ID As Integer, valuation_ID As Integer
    portfolio_ID = 1
    valuation_ID = 1
    ok = refresh_trades(portfolio_ID) And refresh_valuation(valuation_ID)
    If ok Then MsgBox "Refresh complete" Else MsgBox "Refresh failed"
    ActiveWorkbook.RefreshAll
    DoEvents
End Sub





