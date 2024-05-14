'''
This Python script loads the values off the initial .csv file from Excel into the PostgreSQL database.
'''

import psycopg2
import configparser as cp
import os

config = cp.RawConfigParser()

data_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'data')) #TODO os.file path will need to be functional on Linux + Windows + MacOS
csv_file_path = os.path.join(data_path, 'MUP_IHP_RY23_P03_V10_DY21_PRVSVC.csv') #TODO Fix file name

thisfolder = os.path.dirname(os.path.abspath(__file__))
initfile = os.path.join(thisfolder, 'config.ini')

config.read(initfile)
params = dict(config.items('db'))

conn = psycopg2.connect(**params)
if conn: 
    print('Connection to Postgres database ' + params['dbname'] + ' was successful!')
    cur = conn.cursor()  
    with open(csv_file_path, 'r') as f:
        next(f)
        cur.copy_expert("""COPY Temp_vals FROM STDIN WITH (FORMAT CSV);""", f)
        print('done')
    conn.commit()
    conn.close()
