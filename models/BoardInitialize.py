from models.pawn import Pawn
from models.bishop import Bishop
from models.rook import Rook
from models.knight import Knight
from models.queen import Queen
from models.king import King

class Board:

    def __init__(self):
        
        self.initializeBoard()

    def initializeBoard(self):

        self.game = [
                    [Rook('black'),Knight('black'),Bishop('black'),Queen('black'),King('black'),Bishop('black'),Knight('black'),Rook('black')],
                    [Pawn('black'),Pawn('black'),Pawn('black'),Pawn('black'),Pawn('black'),Pawn('black'),Pawn('black'),Pawn('black')],
                    [None,None,None,None,None,None,None,None],
                    [None,None,None,None,None,None,None,None],
                    [None,None,None,None,None,None,None,None],                   
                    [None,None,None,None,None,None,None,None],
                    [Pawn('white'),Pawn('white'),Pawn('white'),Pawn('white'),Pawn('white'),Pawn('white'),Pawn('white'),Pawn('white')],
                    [Rook('white'),Knight('white'),Bishop('white'),Queen('white'),King('white'),Bishop('white'),Knight('white'),Rook('white')]
                    ]


    def displayBoard(self):

            print("   a  b  c  d  e  f  g  h")
            symbols = {
                "Pawn": "P",
                "Rook": "R",
                "Knight": "N",
                "Bishop": "B",
                "Queen": "Q",
                "King": "K"
            }

            for i, row in enumerate(self.game):
                print(8 - i, end=" ")
                for piece in row:
                    if piece is None:
                        print(" . ", end="")
                    else:
                        symbol = symbols[piece.__class__.__name__]
                        if piece.color == "black":
                            symbol = symbol.lower()
                        print(f" {symbol} ", end="")
                print("", 8 - i)
            print("   a  b  c  d  e  f  g  h")

    def to_matrix(self):
        """Converte o tabuleiro de Objetos para Dicionários (JSON)"""
        matrix_visual = []
        
        for row in self.game:
            new_row = []
            for piece in row:
                if piece is None:
                    new_row.append(None)
                else:
                    piece_info = {
                        "type": piece.__class__.__name__,  
                        "color": piece.color             
                    }
                    new_row.append(piece_info)
            matrix_visual.append(new_row)
            
        return matrix_visual
