import sqlite3
import os

current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
data_dir = os.path.join(project_root, 'data')
os.makedirs(data_dir, exist_ok=True)

DB_NAME = os.path.join(data_dir, 'chess_system.db')

def get_connection():
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            birthdate TEXT NOT NULL,
            score INTEGER DEFAULT 0  -- <--- LINHA NOVA!
        )
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS games (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            player1 INTEGER,
            player2 INTEGER,
            moves TEXT,
            status TEXT,
            winner INTEGER,
            FOREIGN KEY(player1) REFERENCES users(id),
            FOREIGN KEY(player2) REFERENCES users(id)
        )
    ''')
    
    conn.commit()
    conn.close()
    print(f"✅ Banco de dados conectado em: {DB_NAME}")

init_db()