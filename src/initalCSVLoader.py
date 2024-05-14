'''
This Python script loads the values off the initial .csv file from Excel into the PostgreSQL database.
'''

import psycopg2
import configparser as cp
import os

config = cp.RawConfigParser()

data_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'data'))
bonds_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Bonds.csv')
items_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Items.csv')
investments_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Investments.csv')

payouts_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Payouts.csv')
trades_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Trades.csv')

thisfolder = os.path.dirname(os.path.abspath(__file__))
initfile = os.path.join(thisfolder, 'config.ini')

config.read(initfile)
params = dict(config.items('db'))


conn = psycopg2.connect(**params)

# Bonds Injection
if conn: 
    print('Connection to Postgres database ' + params['dbname'] + ' was successful!')
    cur = conn.cursor()  
    with open(bonds_file_path, 'r') as f:
        next(f)
        cur.copy_expert("""COPY Bonds FROM STDIN WITH (FORMAT CSV);""", f)
        print('done')
    conn.commit()
    conn.close()

# Bonds Injection
if conn: 
    print('Connection to Postgres database ' + params['dbname'] + ' was successful!')
    cur = conn.cursor()  
    with open(bonds_file_path, 'r') as f:
        next(f)
        cur.copy_expert("""COPY Bonds FROM STDIN WITH (FORMAT CSV);""", f)
        print('done')
    conn.commit()
    conn.close()