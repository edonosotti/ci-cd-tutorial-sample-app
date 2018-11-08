from app import db

class Menu(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), index=True)

    def __repr__(self):
        return '<Menu {}>'.format(self.name)
