import unittest
import json
from app import app  # Adjust if your app filename or variable is different

class MenuApiTestCase(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()
        # Reset global state before each test
      

    def test_health_check(self):
        res = self.client.get('/')
        self.assertEqual(res.status_code, 200)
        self.assertEqual(res.json, {"status": "ok"})

    def test_get_empty_menu(self):
        res = self.client.get('/menu')
        self.assertEqual(res.status_code, 200)
        self.assertEqual(res.json, {"menu": []})



if __name__ == '__main__':
    unittest.main()
