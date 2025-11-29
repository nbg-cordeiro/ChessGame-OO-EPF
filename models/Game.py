import copy
from models.BoardInitialize import Board
from models.piece import Piece
from models.pawn import Pawn
from models.queen import Queen
from models.rook import Rook
from models.knight import Knight
from models.bishop import Bishop
from models.king import King
class Game:

    def __init__(self):
        
        self.board = Board()    
        self.turn = 'white'
        self.jogadas = 0
        self.ultimaJogada = None
        

    def getPiece(self, position):

        col = ord(position[0]) - ord('a')
        row = 8 - int(position[1])
        return self.board.game[row][col]

    def setPiece(self, position, piece):

        col = ord(position[0]) - ord('a')
        row = 8 - int(position[1])
        self.board.game[row][col] = piece

    def isKingInCheck(self, board, color):
        
        enemy_color = "black" if color == "white" else "white"

        for row in range(8):
            for col in range(8):
                attacker = board.game[row][col]
                if attacker is not None and attacker.color == enemy_color:
                    pos = chr(col + ord('a')) + str(8 - row)
                    if attacker.isCheck(pos, board, color):
                        return True
        
        return False
    
    def try_move(self, start, end):
        """Tenta realizar uma jogada e retorna JSON baseado nas boas práticas do Bottle"""

        # 1. Validar formato
        if len(start) != 2 or len(end) != 2:
            return {"valid": False, "error": "Invalid input format"}

        piece = self.getPiece(start)

        if piece is None:
            return {"valid": False, "error": "No piece at start position"}

        if piece.color != self.turn:
            return {"valid": False, "error": "Not your piece"}

        target_piece = self.getPiece(end)

        # --- 2. EN PASSANT ---
        if isinstance(piece, Pawn):
            if self.enPassant(piece, start, end):

                # Simula en passant em um tabuleiro temporário para checar cheque
                temp_board = copy.deepcopy(self.board)
                lastMove = self.ultimaJogada
                startInim = lastMove["start"]
                endInim = lastMove["end"]

                colEndInim = ord(endInim[0]) - ord('a')
                LinhaEndInimigo = 8 - int(endInim[1])

                temp_board.game[LinhaEndInimigo][colEndInim] = None
                self.setPieceOn(temp_board, end, piece)
                self.setPieceOn(temp_board, start, None)

                if self.isKingInCheck(temp_board, self.turn):
                    return {"valid": False, "error": "Illegal move: King would be in check"}

                # Executa en passant real
                self.board.game[LinhaEndInimigo][colEndInim] = None
                self.setPiece(end, piece)
                self.setPiece(start, None)

                # Registrar última jogada
                self.ultimaJogada = {
                    "piece": piece,
                    "start": start,
                    "end": end
                }

                # Troca de turno
                enemy_color = "black" if self.turn == "white" else "white"
                self.turn = enemy_color

                return {
                    "valid": True,
                    "check": self.isKingInCheck(self.board, enemy_color),
                    "turn": self.turn,
                    "board": self.board.to_matrix() if hasattr(self.board, "to_matrix") else None,
                    "mate": self.is_checkmate(self.turn),
                    "empate": self.is_draw(),
                    "afogamento": self.afogamento(self.turn),
                }

        # --- 3. Simular jogada normal ---
        temp_board = copy.deepcopy(self.board)
        self.setPieceOn(temp_board, end, piece)
        self.setPieceOn(temp_board, start, None)

        if self.isKingInCheck(temp_board, self.turn):
            return {"valid": False, "error": "Illegal move: King would be in check"}

        # --- 4. Executar movimento normal ---
        if not piece.makeMoves(start, end, self.board):
            return {"valid": False, "error": "Invalid move for this piece"}

        # Registrar última jogada
        self.ultimaJogada = {
            "piece": piece,
            "start": start,
            "end": end
        }

        # Reinicia ou incrementa contador de 50 jogadas
        if isinstance(piece, Pawn) or target_piece is not None:
            self.jogadas = 0
        else:
            self.jogadas += 1

        # --- 5. Checar se deu cheque no inimigo ---
        enemy_color = "black" if self.turn == "white" else "white"
        in_check = self.isKingInCheck(self.board, enemy_color)

        # --- 6. Trocar turno ---
        self.turn = enemy_color

        # Checar mate, empate e afogamento
        is_mate = self.is_checkmate(self.turn)
        empate = self.is_draw()
        afogamento = self.afogamento(self.turn)

        # --- 7. Retornar resultado ---
        return {
            "valid": True,
            "check": in_check,
            "turn": self.turn,
            "board": self.board.to_matrix() if hasattr(self.board, "to_matrix") else None,
            "mate": is_mate,
            "empate": empate,
            "afogamento": afogamento,
        }


    # método auxiliar para mexer peças no board temporário
    def setPieceOn(self, board, position, piece):

        col = ord(position[0]) - ord('a')
        row = 8 - int(position[1])
        board.game[row][col] = piece


    #metodos para mate (daniel)
    
    def idx_to_notation(self, row, col):

        return chr(col + ord('a')) + str(8 - row)

    def is_checkmate(self, color):
        if not self.isKingInCheck(self.board, color):
            return False

        for r_start in range(8):
            for c_start in range(8):
                piece = self.board.game[r_start][c_start]
                
    
                if piece is not None and piece.color == color:
                    start_pos = self.idx_to_notation(r_start, c_start)
                    
                    for r_end in range(8):
                        for c_end in range(8):
                            end_pos = self.idx_to_notation(r_end, c_end)
                            
                            if start_pos == end_pos: continue
                            
            
                            temp_board = copy.deepcopy(self.board)
                            
    
                            temp_piece = temp_board.game[r_start][c_start]

                            valid_geom = False
                            try:
                                valid_geom = temp_piece.makeMoves(start_pos, end_pos, temp_board)
                            except:
                                valid_geom = False
                            
                            if valid_geom:
               
                                if not self.isKingInCheck(temp_board, color):
                          
                                    return False
                                    
        return True
    
    def afogamento(self, color):

        #Se o rei ta em cheque, NÃO é afogamento
        if self.isKingInCheck(self.board, color):
            return False

        #Tentar achar qualquer jogada legal
        for r_start in range(8):
            for c_start in range(8):
                piece = self.board.game[r_start][c_start]

                if piece is not None and piece.color == color:
                    start_pos = self.idx_to_notation(r_start, c_start)

                    for r_end in range(8):
                        for c_end in range(8):
                            end_pos = self.idx_to_notation(r_end, c_end)

                            if start_pos == end_pos:
                                continue

                            temp_board = copy.deepcopy(self.board)
                            temp_piece = temp_board.game[r_start][c_start]

                            valid_geom = False
                            try:
                                valid_geom = temp_piece.makeMoves(start_pos, end_pos, temp_board)
                            except:
                                valid_geom = False

                            if valid_geom:
                                # Se a jogada existe E não deixa o rei em cheque → não é afogamento
                                if not self.isKingInCheck(temp_board, color):
                                    return False

        #Sem cheque + sem jogadas legais = AFOGAMENTO
        return True
    
    def is_draw(self):
    # Deu 50 jogadas
    
        if self.jogadas >= 50:
            return True

        # só tem rei
        pieces = []

        for row in self.board.game:
            for p in row:
                if p is not None:
                    pieces.append(p)

        # Apenas dois reis no tabuleiro
        if len(pieces) == 2:
            if isinstance(pieces[0], King) and isinstance(pieces[1], King):
                return True

        return False
    
    def enPassant(self, piece, start, end):

        if not isinstance(piece, Pawn):

            return False

        if self.ultimaJogada is None:

            return False

        lastMove = self.ultimaJogada
        pecaInimiga = lastMove["piece"]

        # vendo se a ultima jogada foi um peao super legal 67 ego + aura + phonk
        if not isinstance(pecaInimiga, Pawn):
            return False

        if pecaInimiga.color == piece.color:
            return False

        startInim = lastMove["start"]
        endInim = lastMove["end"]

        colStartInim = ord(startInim[0]) - ord('a')
        LinhaStartInimigo = 8 - int(startInim[1])

        colEndInim = ord(endInim[0]) - ord('a')
        LinhaEndInimigo = 8 - int(endInim[1])

        # inimigo tem que ter andado 2 casas
        if abs(LinhaStartInimigo - LinhaEndInimigo) != 2:
            return False

        colunaMeuPeaoStart = ord(start[0]) - ord('a')
        linhaMeuPeaoStart = 8 - int(start[1])

        colunaMeuPeaoEnd = ord(end[0]) - ord('a')
        linhaMeuPeaoEnd = 8 - int(end[1])

        # meu peão tem que andar na diagonal
        if abs(colunaMeuPeaoStart - colunaMeuPeaoEnd) != 1:
            return False

        # direção certa (branco sobe, preto desce)
        if piece.color == "white":
            if linhaMeuPeaoEnd != linhaMeuPeaoStart - 1:
                return False
        else:
            if linhaMeuPeaoEnd != linhaMeuPeaoStart + 1:
                return False

        # meu peão deve terminar na linha final do inimigo
        if linhaMeuPeaoStart != LinhaEndInimigo:
            return False

        # precisa estar ao lado do inimigo
        if abs(colunaMeuPeaoStart - colEndInim) != 1:
            return False

        # faz o en passant
        self.board.game[LinhaEndInimigo][colEndInim] = None

        # move meu peão
        self.setPiece(end, piece)
        self.setPiece(start, None)

        return True
