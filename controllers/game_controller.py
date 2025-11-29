import json
import random 
from bottle import Bottle, request, response, redirect
from .base_controller import BaseController
from models.Game import Game
from models.game_data import GameModel
from services.user_service import UserService 

class GameController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.game = Game()
        self.user_service = UserService()
        self.game_model = GameModel()
        self.p1_id = None 
        self.p2_id = None 
        self.is_ranked = False 
        self.temp_game = {
            'active': False,
            'p1': None,
            'p2': None,
            'moves': []
        }
        
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/', method='GET', callback=self.menu)
        self.app.route('/menu', method='GET', callback=self.menu)
        self.app.route('/game/setup', method='GET', callback=self.setup_page)
        self.app.route('/game/start', method='POST', callback=self.start_game)
        self.app.route('/game', method='GET', callback=self.index)
        self.app.route('/move', method='POST', callback=self.move_piece)
        self.app.route('/reset', method='POST', callback=self.reset_game)
        self.app.route('/ranking', method='GET', callback=self.show_ranking)

    def menu(self):
        return self.render('menu')


    def setup_page(self):
        return self.render('setup', error=None)

    def start_game(self):
        modo = request.forms.get('mode')
        self.user_service = UserService() 
        self.game = Game()
        self.temp_game = {'active': False, 'p1': None, 'p2': None, 'moves': []}
        self.p1_id = None
        self.p2_id = None
        self.is_ranked = False 

        if modo == 'ranked':
            try:
                val_p1 = request.forms.get('player1_id')
                val_p2 = request.forms.get('player2_id')

                if not val_p1 or not val_p2:
                    return self.render('setup', error="Por favor, preencha os dois IDs.")

                id_p1 = int(val_p1)
                id_p2 = int(val_p2)
                
                u1 = self.user_service.get_by_id(id_p1)
                u2 = self.user_service.get_by_id(id_p2)
                
                if not u1 or not u2:
                    
                    return self.render('setup', error="Jogador não encontrado. Verifique os IDs.")
                
                self.p1_id = id_p1
                self.p2_id = id_p2
                self.is_ranked = True 
                
                self.temp_game['active'] = True
                self.temp_game['p1'] = id_p1
                self.temp_game['p2'] = id_p2
                
                print(f"✅ Rankeado Iniciado: {u1.name} vs {u2.name}")
                
            except ValueError:
                return self.render('setup', error="Os IDs devem ser apenas números.")
        else:
            print("🎲 Jogo Casual Iniciado")
        
        return redirect('/game')

 
    def index(self):
        nome_p1 = "Jogador 1 (Brancas)"
        nome_p2 = "Jogador 2 (Pretas)"

        if self.is_ranked:
            u1 = self.user_service.get_by_id(self.p1_id)
            u2 = self.user_service.get_by_id(self.p2_id)
            
            if u1: 
                pts = getattr(u1, 'score', 0)
                nome_p1 = f"{u1.name} ({pts} pts)"
            
            if u2: 
                pts = getattr(u2, 'score', 0)
                nome_p2 = f"{u2.name} ({pts} pts)"

        board_matrix = self.game.board.to_matrix()
        
        return self.render('tabuleiro', 
                           board=board_matrix, 
                           player1=nome_p1, 
                           player2=nome_p2)

    def move_piece(self):
        data = request.json
        start_pos = data.get('start')
        end_pos = data.get('end')
        
        print(f"Move: {start_pos} -> {end_pos}")

        resultado = self.game.try_move(start_pos, end_pos)
        
        if resultado['valid'] and self.temp_game['active']:
            self.temp_game['moves'].append(f"{start_pos}-{end_pos}")
            
            game_over = False
            winner_id = None
            status = 'over'

            if resultado.get('mate'):
                game_over = True
                winner_color = 'white' if resultado['turn'] == 'black' else 'black'
                
                if winner_color == 'white':
                    winner_id = self.temp_game['p1']
                    loser_id = self.temp_game['p2']
                else:
                    winner_id = self.temp_game['p2']
                    loser_id = self.temp_game['p1']
                
                try:
                    if hasattr(self.user_service, 'registrar_resultado'):
                        self.user_service.registrar_resultado(winner_id, loser_id)
                        print(f"🏆 Pontos computados: Vencedor ID {winner_id}")
                except Exception as e:
                    print(f"Erro ao salvar pontos: {e}")
            
            elif resultado.get('afogamento') or resultado.get('empate'):
                game_over = True
                status = 'draw'
                winner_id = None

            if game_over:
                print("Salvando partida no histórico...")
                try:
                    self.game_model.save_finished_game(
                        self.temp_game['p1'], self.temp_game['p2'],
                        self.temp_game['moves'], winner_id, status
                    )
                except Exception as e:
                    print(f"Erro ao salvar histórico: {e}")
                
                self.temp_game['active'] = False 

        response.content_type = 'application/json'
        return json.dumps(resultado)

    def reset_game(self):
        self.game = Game()
        self.temp_game['moves'] = []
        self.temp_game['active'] = self.is_ranked 
        return {"status": "ok"}

    def show_ranking(self):
        try:
            todos_usuarios = self.user_service.get_all()
            tabela_classificacao = []
            for usuario in todos_usuarios:
                pontos = getattr(usuario, 'score', 0)
                tabela_classificacao.append({'name': usuario.name, 'score': pontos})
            
            tabela_classificacao.sort(key=lambda x: x['score'], reverse=True)
            return self.render('ranking', players=tabela_classificacao)
        except Exception as e:
            return f"Erro ranking: {str(e)}"