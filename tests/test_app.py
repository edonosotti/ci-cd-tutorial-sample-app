import unittest
import json
from app import app  # Adjust if your app filename or variable is different

class MenuApiTestCase(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()
        # Reset global state before each test
        app.menu_items.clear()
        app.next_id = 1

    def test_health_check(self):
        res = self.client.get('/')
        self.assertEqual(res.status_code, 200)
        self.assertEqual(res.json, {"status": "ok"})

    def test_get_empty_menu(self):
        res = self.client.get('/menu')
        self.assertEqual(res.status_code, 200)
        self.assertEqual(res.json, {"menu": []})

    def test_add_menu_item(self):
        res = self.client.post('/menu', json={"name": "Pizza", "price": 1200})
        self.assertEqual(res.status_code, 201)
        self.assertIn("item", res.json)
        self.assertEqual(res.json["item"]["name"], "Pizza")
        self.assertEqual(res.json["item"]["price"], 1200)

    def test_add_menu_item_missing_field(self):
        res = self.client.post('/menu', json={"name": "Burger"})
        self.assertEqual(res.status_code, 400)
        self.assertIn("error", res.json)

    def test_delete_menu_item(self):
        # First add
        self.client.post('/menu', json={"name": "Pasta", "price": 900})
        # Delete it
        res = self.client.delete('/menu/1')
        self.assertEqual(res.status_code, 200)
        self.assertIn("message", res.json)

    def test_delete_nonexistent_item(self):
        res = self.client.delete('/menu/999')
        self.assertEqual(res.status_code, 404)
        self.assertIn("error", res.json)

if __name__ == '__main__':
    unittest.main()
