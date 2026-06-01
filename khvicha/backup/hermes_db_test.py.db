import pyodbc

dsn_name = 'Hermes'

try:
    # 1. Attempt the connection
    conn = pyodbc.connect(f'DSN={dsn_name};')
    cursor = conn.cursor()
    print(f"Connected successfully to {dsn_name}")

    # 2. Identify the database version (Standard SQLite check)
    cursor.execute("SELECT sqlite_version();")
    version = cursor.fetchone()
    print(f"SQLite Version: {version[0]}")

    # 3. List tables (To make sure the data can be seen)
    print("\nTables found in database:")
    for row in cursor.tables():
        print(f"- {row.table_name}")

    conn.close()

except pyodbc.Error as e:
    print("Connection failed.")
    print(e)