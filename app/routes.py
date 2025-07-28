from flask import json, jsonify
from app import app
from app import db
from app.models import Menu

menu_items = [
    {"id": 1, "name": "Pizza", "price": 1200, "quantity": 10},
    {"id": 2, "name": "Burger", "price": 900, "quantity": 5},
    {"id": 3, "name": "Fried Rice", "price": 800, "quantity": 7},
    {"id": 4, "name": "Pasta", "price": 1000, "quantity": 6},
    {"id": 5, "name": "Sandwich", "price": 650, "quantity": 8},
    {"id": 6, "name": "French Fries", "price": 400, "quantity": 15}]

@app.route("/menu/<int:item_id>", methods=["GET"])
def get_menu_item(item_id):
    item = next((item for item in menu_items if item["id"] == item_id), None)
    if item:
        return jsonify(item)
    return jsonify({"error": "Item not found"}), 404

@app.route('/')
def home():
	return jsonify({ "status": "ok" })

@app.route("/menu", methods=["GET"])
def get_menu():
    return jsonify({"menu": menu_items})

@app.route("/menu/summary", methods=["GET"])
def menu_summary():
    names = [item["name"] for item in menu_items]
    ids = [item["id"] for item in menu_items]
    quantities = [item["quantity"] for item in menu_items]

    return jsonify({
        "names": names,
        "ids": ids,
        "quantities": quantities
        })

        @app.route("/menu/available/<int:min_qty>", methods=["GET"])
def get_items_with_min_quantity(min_qty):
    filtered = [item for item in menu_items if item["quantity"] >= min_qty]
    return jsonify({"menu": filtered})