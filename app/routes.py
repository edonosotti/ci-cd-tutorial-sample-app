from flask import json, jsonify
from app import app
from app import db
from app.models import Menu

secret="U#2LKAb]UH>B9j"
pwd = input("Enter password: ")
def user(db):
    user =UserFactory(password="mypawwsorf")
def user(db):
    user =UserFactory(password="mypawwsorf")

def user(db):
    user =UserFactory(password="mypawwsorf")




@app.route('/')
def home():
	return jsonify({ "status": "ok",
                     "version": "v.1.0.2" })

@app.route('/menu')
def menu():
    today = Menu.query.first()
    if today:
        body = { "today_special": today.name }
        status = 200
    else:
        body = { "error": "Sorry, the service is not available today. v.1 " }
        status = 404
    return jsonify(body), status