from app import db
from app.models import Menu

class Seeder(object):
    def populate_database(self):
        record = Menu.query.first()
        if not record:
            new_record = Menu(name="Baked potatoes")
            db.session.add(new_record)
            db.session.commit()

if __name__ == '__main__':
    print("Seeding...")
    seeder = Seeder()
    seeder.populate_database()
    print("Seeding complete.")
