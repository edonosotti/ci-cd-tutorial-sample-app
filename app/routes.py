from flask import jsonify, request
from app import app, db
from app.models import Menu

# Health check
@app.route('/')
def home():
    return jsonify({"status": "ok"}), 200


# Get today's menu
@app.route('/menu', methods=['GET'])
def get_menu():
    today = Menu.query.first()  # Adjust filter logic if needed
    if today:
        return jsonify({
            "menu": today.serialize(),  # Make sure Menu model has serialize() method
            "status": "available"
        }), 200
    else:
        return jsonify({"error": "Sorry, the service is not available today."}), 404


# Add or update menu
@app.route('/menu', methods=['POST'])
def add_menu():
    data = request.json
    if not data or "name" not in data or "price" not in data:
        return jsonify({"error": "Invalid data. 'name' and 'price' are required."}), 400
    
    try:
        menu_item = Menu(name=data["name"], price=data["price"])
        db.session.add(menu_item)
        db.session.commit()
        return jsonify({"message": "Menu item added successfully"}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
