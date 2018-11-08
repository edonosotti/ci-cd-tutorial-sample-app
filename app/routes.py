from flask import json, jsonify
from app import app
from app import db
from app.models import Menu

@app.route('/')
def home():
	return jsonify({ "status": "ok" })

@app.route('/menu')
def menu():
    today = Menu.query.first()
    if today:
        body = { "today_special": today.name }
        status = 200
    else:
        body = { "error": "Sorry, the service is not available today." }
        status = 404
    return jsonify(body), status