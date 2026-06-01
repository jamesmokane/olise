@echo off

REM Backup the database
copy hermes.sql backup\hermes.sql
copy hermes.db backup\hermes.db

REM Backup the python scripts
copy analyticoptionprices.py backup\analyticoptionprices.py.sql
copy Excel_db_access.py backup\Excel_db_access.py.db
copy hermes_db_test.py backup\hermes_db_test.py.db
copy regression_tests.py backup\regression_tests.py.db

REM Backup the Excel spreadsheet
copy Portfolio_Manager.xlsm backup\Portfolio_Manager.xlsm



