from bottle import request
from models.user import UserModel, User

class UserService:
    def __init__(self):
        self.user_model = UserModel()


    def get_all(self):
        users = self.user_model.get_all()
        return users


    def save(self):
        # Não calculamos mais ID. Passamos 0 ou None.
        name = request.forms.get('name')
        email = request.forms.get('email')
        birthdate = request.forms.get('birthdate')

        # id=0 indica que é um novo usuário
        user = User(id=0, name=name, email=email, birthdate=birthdate)
        self.user_model.add_user(user)


    def get_by_id(self, user_id):
        return self.user_model.get_by_id(user_id)


    def edit_user(self, user):
        name = request.forms.get('name')
        email = request.forms.get('email')
        birthdate = request.forms.get('birthdate')

        user.name = name
        user.email = email
        user.birthdate = birthdate

        self.user_model.update_user(user)


    def delete_user(self, user_id):
        self.user_model.delete_user(user_id)
