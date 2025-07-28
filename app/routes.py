from flask import json, jsonify
from app import app
from app import db
from app.models import Menu

@app.route('/')
def home():
	return jsonify({ "status": "ok" })

@app.route('/menu')
def menu():
    all_items = Menu.query.all()
    if all_items:
        menu_list = [{"id": item.id, "name": item.name, "price": item.price} for item in all_items]
        body = { "menu": menu_list }
        status = 200
    else:
        body = { "error": "Sorry, no menu items are available today." }
        status = 404
    return jsonify(body), status
