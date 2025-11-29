from dataclasses import dataclass
from models import database

@dataclass
class User:
    id: int
    name: str
    email: str
    birthdate: str
    score: int = 0  # <--- NOVO CAMPO

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'birthdate': self.birthdate,
            'score': self.score # <--- Manda pro JSON
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
        
        users = []
        for row in rows:
            pontos = row['score'] if 'score' in row.keys() else 0
            users.append(User(
                id=row['id'], 
                name=row['name'], 
                email=row['email'], 
                birthdate=row['birthdate'],
                score=pontos
            ))
        return users

    def get_by_id(self, user_id: int):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
        row = cursor.fetchone()
        conn.close()

        if row:
            pontos = row['score'] if 'score' in row.keys() else 0
            return User(
                id=row['id'], 
                name=row['name'], 
                email=row['email'], 
                birthdate=row['birthdate'],
                score=pontos
            )
        return None

    def add_user(self, user: User):
        conn = database.get_connection()
        cursor = conn.cursor()

        cursor.execute("INSERT INTO users (name, email, birthdate, score) VALUES (?, ?, ?, ?)", 
                       (user.name, user.email, user.birthdate, user.score))
        conn.commit()
        conn.close()

    def update_user(self, user: User):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("UPDATE users SET name = ?, email = ?, birthdate = ?, score = ? WHERE id = ?", 
                       (user.name, user.email, user.birthdate, user.score, user.id))
        conn.commit()
        conn.close()

    def delete_user(self, user_id: int):
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM users WHERE id = ?", (user_id,))
        conn.commit()
        conn.close()