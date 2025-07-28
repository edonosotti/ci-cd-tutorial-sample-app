from flask import Flask
from app.config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config.from_object(Config)
db = SQLAlchemy(app)
migrate = Migrate(app, db)

from app import routes, models

menu_items = [
    {"id": 1, "name": "Pizza", "price": 1200},
    {"id": 2, "name": "Burger", "price": 900}
]
