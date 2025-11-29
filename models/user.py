from dataclasses import dataclass
from models import database
@dataclass
class User:
    id: int
    name: str
    email: str
    birthdate: str

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'birthdate': self.birthdate
        }

class UserModel:
    def __init__(self):
        pass

    def get_all(self):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users")
        rows = cursor.fetchall()
        conn.close()
        
        # Converte as linhas do banco para objetos User
        return [User(id=row['id'], name=row['name'], email=row['email'], birthdate=row['birthdate']) for row in rows]

    def get_by_id(self, user_id: int):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
        row = cursor.fetchone()
        conn.close()

        if row:
            return User(id=row['id'], name=row['name'], email=row['email'], birthdate=row['birthdate'])
        return None

    def add_user(self, user: User):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (name, email, birthdate) VALUES (?, ?, ?)", 
                       (user.name, user.email, user.birthdate))
        conn.commit()
        conn.close()

    def update_user(self, user: User):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("UPDATE users SET name = ?, email = ?, birthdate = ? WHERE id = ?", 
                       (user.name, user.email, user.birthdate, user.id))
        conn.commit()
        conn.close()

    def delete_user(self, user_id: int):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM users WHERE id = ?", (user_id,))
        conn.commit()
        conn.close()