import sqlite3
import pandas as pd

DB_FILE = "../data/sessions.db"
DATASET_FILE = "../data/user_sessions.csv"

def create_connection(db_file=DB_FILE):
    return sqlite3.connect(db_file)

def load_data_to_db():
    conn = create_connection(DB_FILE)
    df = pd.read_csv(DATASET_FILE, parse_dates=["timestamp"])
    df.to_sql("user_session", conn, if_exists="replace", index=False)
    conn.close()
    return "Data loaded!"


load_data_to_db()