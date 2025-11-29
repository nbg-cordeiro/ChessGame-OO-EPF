import json
from bottle import Bottle, request, response, redirect
from .base_controller import BaseController
from models.Game import Game
from models.game_data import GameModel # Import adicionado
from services.user_service import UserService 

class GameController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        
        self.game = Game()
        self.game_model = GameModel() # Instancia o Model
        self.user_service = UserService()
        
        self.current_game_id = None # Controla qual jogo está sendo jogado
        
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
        
        # Reseta o jogo local
        self.game = Game()
        self.current_game_id = None 

        if modo == 'ranked':
            id_p1 = request.forms.get('player1_id')
            id_p2 = request.forms.get('player2_id')
            
            try:
                # Converte e busca jogadores
                jogador1 = self.user_service.get_by_id(int(id_p1))
                jogador2 = self.user_service.get_by_id(int(id_p2))
                
                if not jogador1 or not jogador2:
                    return f"ERRO: ID inválido! O jogador {id_p1} ou {id_p2} não existe. Cadastre antes de jogar."
                
                # --- CRIA O JOGO NO BANCO ---
                new_game_data = self.game_model.create_new_game(int(id_p1), int(id_p2))
                self.current_game_id = new_game_data.id
                
                print(f"Iniciando Jogo Rankeado (ID {self.current_game_id}): {jogador1.name} vs {jogador2.name}")
                
            except ValueError:
                return "ERRO: Os IDs precisam ser números."
                
        else:
            print("Iniciando Jogo Casual")

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
        
        if resultado.get('valid') and self.current_game_id:
            game_data = self.game_model.get_by_id(self.current_game_id)
            
            if game_data:
                move_str = f"{start_pos}-{end_pos}"
                game_data.moves.append(move_str)
                
                if resultado.get('mate'):
                    game_data.status = "over"
                    winner_color = 'white' if resultado['turn'] == 'black' else 'black'
                    game_data.winner = game_data.player1 if winner_color == 'white' else game_data.player2
                
                elif resultado.get('afogamento') or resultado.get('empate'):
                    game_data.status = "draw"
                    game_data.winner = None

                self.game_model.save_game(game_data)

        response.content_type = 'application/json'
        return json.dumps(resultado)

    def reset_game(self):
        self.game = Game()
        self.current_game_id = None
        return {"status": "ok"}