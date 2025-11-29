import json
import random #temporario(daniel)
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
        self.user_service = UserService()
        self.setup_routes()
        self.p1_id = None 
        self.p2_id = None 
        self.is_ranked = False
        # Memória temporária da partida atual
        self.temp_game = {
            'active': False,
            'p1': None,
            'p2': None,
            'moves': []
        }
        


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
        return self.render('setup')

    def start_game(self):
        modo = request.forms.get('mode')
        
        # Reinicia jogo e limpa memória temporária
        self.game = Game()
        self.temp_game = {'active': False, 'p1': None, 'p2': None, 'moves': []}

        if modo == 'ranked':
            id_p1 = request.forms.get('player1_id')
            id_p2 = request.forms.get('player2_id')
            
            try:
                p1_int = int(id_p1)
                p2_int = int(id_p2)
                
                jogador1 = self.user_service.get_by_id(p1_int)
                jogador2 = self.user_service.get_by_id(p2_int)
                
                if not jogador1 or not jogador2:
                    return f"ERRO: ID inválido! O jogador {id_p1} ou {id_p2} não existe."
                
                # Ativa modo rankeado na memória
                self.temp_game['active'] = True
                self.temp_game['p1'] = p1_int
                self.temp_game['p2'] = p2_int
                
                print(f"Iniciando Rankeada (Memória): {jogador1.name} vs {jogador2.name}")
                
            except ValueError:
                return "ERRO: Os IDs precisam ser números."
        else:
            print("Iniciando Jogo Casual")
        
        return redirect('/game')

    def show_ranking(self):
        try:
            todos_usuarios = self.user_service.get_all()
            tabela_classificacao = []
            for usuario in todos_usuarios:
            
                pontos = getattr(usuario, 'score', random.randint(0, 100)) 
                tabela_classificacao.append({
                    'name': usuario.name, 
                    'score': pontos
                })
            tabela_classificacao.sort(key=lambda jogador: jogador['score'], reverse=True)
            return self.render('ranking', players=tabela_classificacao)
            
        except Exception as erro:
            print(f"Erro ao gerar ranking: {erro}")
            return f"Não foi possível carregar o ranking: {str(erro)}"
        
    #tabuleiro

    def index(self):
        nome_p1 = "Jogador 1 (Brancas)"
        nome_p2 = "Jogador 2 (Pretas)"

        if self.is_ranked:
            u1 = self.user_service.get_by_id(self.p1_id)
            u2 = self.user_service.get_by_id(self.p2_id)
            
            if u1: nome_p1 = f"{u1.name} (Ranking: {u1.score})"
            if u2: nome_p2 = f"{u2.name} (Ranking: {u2.score})"

        board_matrix = self.game.board.to_matrix()
        
        return self.render('tabuleiro', 
                           board=board_matrix, 
                           player1=nome_p1, 
                           player2=nome_p2)
        
    def move_piece(self):
        data = request.json
        start_pos = data.get('start')
        end_pos = data.get('end')
        
        print(f"Tentativa de movimento: {start_pos} -> {end_pos}")

        resultado = self.game.try_move(start_pos, end_pos)
        
        if resultado['valid'] and self.temp_game['active']:
            # 1. Guarda movimento na memória
            self.temp_game['moves'].append(f"{start_pos}-{end_pos}")

            # 2. Verifica se o jogo acabou para salvar
            game_over = False
            winner = None
            status = 'over'

            if resultado.get('mate'):
                game_over = True
                # Quem jogou (vez anterior) venceu
                winner_color = 'white' if resultado['turn'] == 'black' else 'black'
                winner = self.temp_game['p1'] if winner_color == 'white' else self.temp_game['p2']
            
            elif resultado.get('afogamento') or resultado.get('empate'):
                game_over = True
                status = 'draw'
                winner = None

            if game_over:
                print("Fim de jogo! Salvando no disco...")
                self.game_model.save_finished_game(
                    self.temp_game['p1'],
                    self.temp_game['p2'],
                    self.temp_game['moves'],
                    winner,
                    status
                )
                self.temp_game['active'] = False # Para de gravar

        response.content_type = 'application/json'
        return json.dumps(resultado)

    def reset_game(self):
        self.game = Game()
        self.temp_game = {'active': False, 'p1': None, 'p2': None, 'moves': []}
        return {"status": "ok"}