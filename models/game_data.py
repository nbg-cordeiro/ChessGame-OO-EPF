import json
import os
from dataclasses import dataclass

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
FILE_PATH = os.path.join(DATA_DIR, 'games.json')

@dataclass
class GameData:
    """Esta classe representa apenas os DADOS do jogo, não as regras."""
    id: int
    player1: int
    player2: int
    moves: list
    status: str
    winner: str = None

    def to_dict(self):
        return {
            'id': self.id,
            'player1': self.player1,
            'player2': self.player2,
            'moves': self.moves,
            'status': self.status,
            'winner': self.winner
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            id=data['id'],
            player1=data['player1'],
            player2=data['player2'],
            moves=data['moves'],
            status=data['status'],
            winner=data.get('winner')
        )

class GameModel:
    """Responsável apenas por ler e escrever no JSON"""
    
    def get_all(self):
        if not os.path.exists(FILE_PATH):
            return []
        try:
            with open(FILE_PATH, 'r') as f:
                data = json.load(f)
                return [GameData.from_dict(item) for item in data]
        except:
            return []

    def save_all(self, games_list):
        os.makedirs(DATA_DIR, exist_ok=True)
        
        with open(FILE_PATH, 'w') as f:
            json.dump([g.to_dict() for g in games_list], f, indent=4)

    def get_by_id(self, game_id):
        games = self.get_all()
        return next((g for g in games if g.id == game_id), None)

    def create_new_game(self, player1_id, player2_id):
        """Gera ID automático e salva o novo jogo"""
        games = self.get_all()
        
        # Lógica do ID Auto-Incremento
        if not games:
            new_id = 1
        else:
            new_id = max(g.id for g in games) + 1
            
        new_game = GameData(
            id=new_id,
            player1=player1_id,
            player2=player2_id,
            moves=[],
            status="active"
        )
        
        games.append(new_game)
        self.save_all(games)
        return new_game

    def save_game(self, game_data):
        """Salva ou Atualiza um jogo existente"""
        games = self.get_all()
        
        found = False
        for i, g in enumerate(games):
            if g.id == game_data.id:
                games[i] = game_data
                found = True
                break
        
        if not found:
            games.append(game_data)
            
        self.save_all(games)