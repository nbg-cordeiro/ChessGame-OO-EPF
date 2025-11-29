from bottle import request
from models.user import UserModel, User

class UserService:
    def __init__(self):
        self.user_model = UserModel()

    def get_all(self):
        users = self.user_model.get_all()
        return users

    def get_by_id(self, user_id):
        return self.user_model.get_by_id(user_id)

    def save(self):
        # Lógica para pegar dados do formulário
        name = request.forms.get('name')
        try:
            if name:
                name = name.encode('latin-1').decode('utf-8')
        except:
            pass
            
        email = request.forms.get('email')
        birthdate = request.forms.get('birthdate')

        user = User(id=0, name=name, email=email, birthdate=birthdate, score=0)
        
        self.user_model.add_user(user)

    def edit_user(self, user):
        name = request.forms.get('name')
        try:
            if name:
                name = name.encode('latin-1').decode('utf-8')
        except:
            pass
            
        email = request.forms.get('email')
        birthdate = request.forms.get('birthdate')

        user.name = name
        user.email = email
        user.birthdate = birthdate

        self.user_model.update_user(user)

    def delete_user(self, user_id):
        self.user_model.delete_user(user_id)

    def registrar_resultado(self, id_vencedor, id_perdedor):
        try:
            vencedor = self.get_by_id(int(id_vencedor))
            perdedor = self.get_by_id(int(id_perdedor))

            if vencedor and perdedor:

                vencedor.score += 3
                
                perdedor.score -= 3
                if perdedor.score < 0:
                    perdedor.score = 0 

                self.user_model.update_user(vencedor)
                self.user_model.update_user(perdedor)
                
                print(f"🏆 Ranking Atualizado: {vencedor.name} agora tem {vencedor.score} pts.")
                return True
            
        except Exception as e:
            print(f"Erro ao atualizar pontuação: {e}")
            
        return False