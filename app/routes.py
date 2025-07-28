from flask import json, jsonify
from app import app
from app import db
from app.models import Menu

menu_items = [
    {"id": 1, "name": "Pizza", "price": 1200},
    {"id": 2, "name": "Burger", "price": 900}
]

@app.route('/')
def home():
	return jsonify({ "status": "ok" })

@app.route("/menu", methods=["GET"])
def get_menu():
    return jsonify({"menu": menu_items})

@app.route("/menu", methods=["POST"])
def add_menu_item():
    global next_id
    data = request.get_json()
    name = data.get("name")
    price = data.get("price")

    if not name or price is None:
        return jsonify({"error": "Missing 'name' or 'price'"}), 400

    item = {
        "id": next_id,
        "name": name,
        "price": price
    }
    menu_items.append(item)
    next_id += 1
    return jsonify({"message": "Item added", "item": item}), 201

@app.route("/menu/<int:item_id>", methods=["DELETE"])
def delete_menu_item(item_id):
    global menu_items
    for item in menu_items:
        if item["id"] == item_id:
            menu_items = [m for m in menu_items if m["id"] != item_id]
            return jsonify({"message": f"Deleted item {item_id}"}), 200
    return jsonify({"error": "Item not found"}), 404