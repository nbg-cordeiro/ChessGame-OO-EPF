from models.user import UserModel, User
from models.game_data import GameModel, GameData
from models.database import get_connection, init_db

def limpar_banco():
    """Apaga todos os dados para começar do zero (opcional)"""
    print("🧹 Limpando banco de dados antigo...")
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM games")
    cursor.execute("DELETE FROM users")
    # Reseta o contador de IDs (para começar do 1 novamente)
    cursor.execute("DELETE FROM sqlite_sequence WHERE name='users'")
    cursor.execute("DELETE FROM sqlite_sequence WHERE name='games'")
    conn.commit()
    conn.close()

def criar_usuarios():
    print("👥 Criando usuários de teste...")
    model = UserModel()
    
    # Lista de usuários fictícios
    users = [
        User(id=0, name="Magnus Carlsen", email="magnus@chess.com", birthdate="1990-11-30"),
        User(id=0, name="Garry Kasparov", email="garry@chess.com", birthdate="1963-04-13"),
        User(id=0, name="Hikaru Nakamura", email="hikaru@chess.com", birthdate="1987-12-09"),
        User(id=0, name="O Gambito da Rainha", email="beth@netflix.com", birthdate="2000-01-01")
    ]

    for u in users:
        model.add_user(u)
        print(f"   -> Usuário criado: {u.name}")

def criar_jogos():
    print("♟️  Criando jogos de teste...")
    model = GameModel()

    # Jogo 1: Magnus (1) vs Hikaru (3) - Finalizado (Magnus ganhou)
    # IDs são 1 e 3 porque o banco gera na ordem de inserção acima
    moves_jogo1 = ["e2-e4", "e7-e5", "g1-f3", "b8-c6"] # Movimentos fictícios
    
    jogo1 = GameData(
        id=0, 
        player1=1, 
        player2=3, 
        moves=moves_jogo1, 
        status="over", 
        winner=1
    )
    model.save_game(jogo1)
    print("   -> Jogo Finalizado criado (Magnus venceu Hikaru)")

    # Jogo 2: Garry (2) vs Beth (4) - Em andamento (Active)
    moves_jogo2 = ["d2-d4", "d7-d5"]
    
    jogo2 = GameData(
        id=0, 
        player1=2, 
        player2=4, 
        moves=moves_jogo2, 
        status="active", 
        winner=None
    )
    model.save_game(jogo2)
    print("   -> Jogo em Andamento criado (Garry vs Beth)")

if __name__ == "__main__":
    # Garante que as tabelas existem
    init_db()
    
    # Executa a limpeza e inserção
    limpar_banco()
    criar_usuarios()
    criar_jogos()
    
    print("\n✅ Sucesso! O banco de dados foi populado.")