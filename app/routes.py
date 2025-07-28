from flask import json, jsonify
from app import app
from app import db
from app.models import Menu
from flask import render_template_string

menu_items = [
    {"id": 1, "name": "Pizza", "price": 1200, "quantity": 10},
    {"id": 2, "name": "Burger", "price": 900, "quantity": 5},
    {"id": 3, "name": "Fried Rice", "price": 800, "quantity": 7},
    {"id": 4, "name": "Pasta", "price": 1000, "quantity": 6},
    {"id": 5, "name": "Sandwich", "price": 650, "quantity": 8},
    {"id": 6, "name": "French Fries", "price": 400, "quantity": 15}]


# @app.route('/')
# def home():
# 	return jsonify({ "status": "ok" })

@app.route('/')
def home():
    html = """
    <html>
        <head>
            <title>Flask Sample App - API Guide</title>
        </head>
        <body>
            <h1>Welcome to the Flask Sample App</h1>
            <p>This app manages a sample menu. Below are the available API endpoints:</p>
            <ul>
                <li><code>GET /menu</code> – List all menu items</li>
                <li><code>GET /menu/&lt;item_id&gt;</code> – Get a menu item by ID</li>
                <li><code>GET /menu/names</code> – Get all menu item names</li>
                <li><code>GET /menu/stock/total</code> – Get total quantity in stock</li>
                <li><code>GET /menu/summary</code> – Get summary: IDs, names, quantities</li>
                <li><code>GET /menu/available/&lt;min_qty&gt;</code> – Filter items by minimum quantity</li>
                <li><code>GET /menu/sorted/price</code> – List items sorted by price</li>
                <li><code>GET /menu/under/&lt;max_price&gt;</code> – List items priced below a value</li>
            </ul>
            <p>Example: <a href="/menu">/menu</a></p>
        </body>
    </html>
    """
    return render_template_string(html)

@app.route("/menu/<int:item_id>", methods=["GET"])
def get_menu_item(item_id):
    item = next((item for item in menu_items if item["id"] == item_id), None)
    if item:
        return jsonify(item)
    return jsonify({"error": "Item not found"}), 404

@app.route("/menu/names", methods=["GET"])
def get_menu_names():
    names = [item["name"] for item in menu_items]
    return jsonify({"names": names})

@app.route("/menu/stock/total", methods=["GET"])
def get_total_stock():
    total = sum(item["quantity"] for item in menu_items)
    return jsonify({"total_quantity": total})



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
    return jsonify({"menu":filtered})


@app.route("/menu/sorted/price", methods=["GET"])
def get_sorted_by_price():
    sorted_items = sorted(menu_items, key=lambda x: x["price"])
    return jsonify({"menu":sorted_items})

@app.route("/menu/under/<int:max_price>", methods=["GET"])
def get_items_under_price(max_price):
    filtered = [item for item in menu_items if item["price"] < max_price]
    return jsonify({"menu":filtered})