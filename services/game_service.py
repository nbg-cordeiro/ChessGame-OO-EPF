from models.game_data import GameModel
from models.Game import Game

class GameService:
    def __init__(self):
        self.model = GameModel()

    def make_move(self, game_id, start, end):
        game_data = self.model.get_by_id(game_id)
        chess = Game()
        
        for move in game_data.moves:
            chess.try_move(move['from'], move['to'])

        if chess.try_move(start, end):
            game_data.moves.append({'from': start, 'to': end})
            self.model.save_game(game_data)
            return True
        
        return False
    
    def get_games_by_player(self, player_name):
        """Busca histórico de partidas pelo nome do jogador"""
        all_games = self.model.get_all()
        
        my_games = [
            g for g in all_games 
            if g.player1 == player_name or g.player2 == player_name
        ]
        return my_games