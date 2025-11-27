import json
from bottle import Bottle, request, response
from .base_controller import BaseController
from models.Game import Game 

class GameController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        
        self.game = Game()
        
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/game', method='GET', callback=self.index)
        
        self.app.route('/move', method='POST', callback=self.move_piece)
        
        self.app.route('/reset', method='POST', callback=self.reset_game)

    def index(self):

        board_matrix = self.game.board.to_matrix()
        return self.render('tabuleiro', board=board_matrix)

    def move_piece(self):
        
        data = request.json
        start_pos = data.get('start')
        end_pos = data.get('end')
        
        print(f"Tentativa de movimento: {start_pos} -> {end_pos}")

        resultado = self.game.try_move(start_pos, end_pos)
        
        response.content_type = 'application/json'
        
        return json.dumps(resultado)

    def reset_game(self):
        self.game = Game()
        return {"status": "ok"}