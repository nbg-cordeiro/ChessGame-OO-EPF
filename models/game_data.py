import json
from dataclasses import dataclass
from . import database

@dataclass
class GameData:
    id: int
    player1: int
    player2: int
    moves: list
    status: str
    winner: int = None # Mudei para int/None para bater com o banco

    def to_dict(self):
        return {
            'id': self.id,
            'player1': self.player1,
            'player2': self.player2,
            'moves': self.moves,
            'status': self.status,
            'winner': self.winner
        }

class GameModel:
    def __init__(self):
        pass

    def _row_to_game(self, row):
        """Método auxiliar para converter linha do banco em objeto GameData"""
        return GameData(
            id=row['id'],
            player1=row['player1'],
            player2=row['player2'],
            moves=json.loads(row['moves']), # Converte Texto -> Lista
            status=row['status'],
            winner=row['winner']
        )

    def get_all(self):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM games")
        rows = cursor.fetchall()
        conn.close()
        return [self._row_to_game(row) for row in rows]

    def get_by_id(self, game_id):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM games WHERE id = ?", (game_id,))
        row = cursor.fetchone()
        conn.close()
        
        if row:
            return self._row_to_game(row)
        return None

    def save_game(self, game_data: GameData):
        conn = database.get_connection()
        cursor = conn.cursor()
        
        moves_json = json.dumps(game_data.moves) # Converte Lista -> Texto
        
        # Verifica se o jogo já existe
        cursor.execute("SELECT id FROM games WHERE id = ?", (game_data.id,))
        exists = cursor.fetchone()

        if exists:
            cursor.execute('''
                UPDATE games SET player1=?, player2=?, moves=?, status=?, winner=? WHERE id=?
            ''', (game_data.player1, game_data.player2, moves_json, game_data.status, game_data.winner, game_data.id))
        else:
            cursor.execute('''
                INSERT INTO games (player1, player2, moves, status, winner) VALUES (?, ?, ?, ?, ?)
            ''', (game_data.player1, game_data.player2, moves_json, game_data.status, game_data.winner))
            
        conn.commit()
        conn.close()

    def save_finished_game(self, player1_id, player2_id, moves, winner_id, status):
        # Cria um objeto e reutiliza o save_game ou insere direto
        # Para simplificar, inserindo direto:
        conn = database.get_connection()
        cursor = conn.cursor()
        
        moves_json = json.dumps(moves)
        
        cursor.execute('''
            INSERT INTO games (player1, player2, moves, status, winner) VALUES (?, ?, ?, ?, ?)
        ''', (player1_id, player2_id, moves_json, status, winner_id))
        
        conn.commit()
        conn.close()