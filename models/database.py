import sqlite3
import os

# --- Configuração de Caminhos ---

# 1. Pega a pasta onde este arquivo está (models)
current_dir = os.path.dirname(os.path.abspath(__file__))

# 2. Pega a raiz do projeto (uma pasta acima de models)
project_root = os.path.dirname(current_dir)

# 3. Define a pasta de dados
data_dir = os.path.join(project_root, 'data')

# 4. Garante que a pasta 'data' existe (cria se não existir)
os.makedirs(data_dir, exist_ok=True)

# 5. Define o caminho final do banco de dados dentro de 'data'
DB_NAME = os.path.join(data_dir, 'chess_system.db')

def get_connection():
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_connection()
    cursor = conn.cursor()
    
    # Tabela de Usuários
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            birthdate TEXT NOT NULL
        )
    ''')

    # Tabela de Jogos
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

# Inicializa ao importar
init_db()