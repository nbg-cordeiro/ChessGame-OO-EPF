from .base_controller import BaseController
from .user_controller import UserController
from .game_controller import GameController  

def init_controllers(app):

    BaseController(app)
    UserController(app)
    GameController(app) 