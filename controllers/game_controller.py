import json
from bottle import Bottle, request, response, redirect
from .base_controller import BaseController
from models.Game import Game

from services.user_service import UserService 

class GameController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        
        self.game = Game()
        
        
        self.user_service = UserService()
        
        self.setup_routes()

    def setup_routes(self):

    
        self.app.route('/', method='GET', callback=self.menu)
        self.app.route('/menu', method='GET', callback=self.menu)
        
        self.app.route('/game/setup', method='GET', callback=self.setup_page)
        
        self.app.route('/game/start', method='POST', callback=self.start_game)
        
    
        self.app.route('/game', method='GET', callback=self.index)
        self.app.route('/move', method='POST', callback=self.move_piece)
        self.app.route('/reset', method='POST', callback=self.reset_game)


    def menu(self):
        return self.render('menu')

    def setup_page(self):
        return self.render('setup')

    def start_game(self):
        modo = request.forms.get('mode')
        
        if modo == 'ranked':
            id_p1 = request.forms.get('player1_id')
            id_p2 = request.forms.get('player2_id')
            
            try:

                jogador1 = self.user_service.get_by_id(int(id_p1))
                jogador2 = self.user_service.get_by_id(int(id_p2))
                
                if not jogador1 or not jogador2:
                    return f"ERRO: ID inválido! O jogador {id_p1} ou {id_p2} não existe. Cadastre antes de jogar."
                
                print(f"Iniciando Jogo Rankeado: {jogador1.name} (Brancas) vs {jogador2.name} (Pretas)")
                
            except ValueError:
                return "ERRO: Os IDs precisam ser números."
                
        else:
            print("Iniciando Jogo Casual")

        self.game = Game()
        
        return redirect('/game')

    #tabuleiro

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