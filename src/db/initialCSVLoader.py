'''
This Python script loads the values off the initial .csv file from Excel into the PostgreSQL database.
'''

import psycopg2
import configparser as cp
import os

config = cp.RawConfigParser()
data_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'data'))

# data filepaths
bonds_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Bonds.csv')
items_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Items.csv')
investors_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Investors.csv')
investments_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Investments.csv')
payouts_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Payouts.csv')
trades_file_path = os.path.join(data_path, 'RS_Flip_Log_Normalized_Trades.csv')
this_folder = os.path.dirname(os.path.abspath(__file__))
init_file = os.path.join(this_folder, 'config.ini')

config.read(init_file)
params = dict(config.items('db'))


conn = psycopg2.connect(**params)

# copying from csv to SQL tables
if conn:
    print('Connection to Postgres database ' + params['dbname'] + ' was successful!')
    cur = conn.cursor()  

    # Bonds copy from csv to SQL
    with open(bonds_file_path, 'r') as f:
        next(f)
        cur.copy_expert("""
                        COPY Bonds(date,price)
                        FROM STDIN WITH (FORMAT CSV);
                        """, f)
        print('done bonds copy')

    # Items copy from csv to SQL
    with open(items_file_path, 'r') as f:
        next(f)
        cur.copy_expert("""
                        COPY Items
                        FROM STDIN WITH (FORMAT CSV);
                        """, f)
        print('done items copy')

    # Investors copy from csv to SQL
    with open(investors_file_path, 'r') as f:
        next(f)
        cur.copy_expert("""
                        COPY Investors
                        FROM STDIN WITH (FORMAT CSV);
                        """, f)
        print('done investors copy')

    # Investments copy from csv to SQL
    with open(investments_file_path, 'r') as f:
        next(f)
        cur.copy_expert("""
                        COPY Investments
                        FROM STDIN WITH (FORMAT CSV);
                        """, f)
        print('done investments copy')

    # Payouts copy from csv to SQL
    with open(payouts_file_path, 'r') as f:
        next(f)
        cur.copy_expert("""
                        COPY Payouts
                        FROM STDIN WITH (FORMAT CSV);
                        """, f)
        print('done payouts copy')

    # Trades copy from csv to SQL
    with open(trades_file_path, 'r') as f:
        next(f)
        cur.copy_expert("""
                        COPY Trades(date, item_name, buy_amount, sell_amount, quantity, test_trade_id, comment)
                        FROM STDIN WITH (FORMAT CSV);
                        """, f)
        print('done trades copy')

    conn.commit()
    conn.close()
