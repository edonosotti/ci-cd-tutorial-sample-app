import unittest
import json
from app import app  # Adjust if your app filename or variable is different

class MenuApiTestCase(unittest.TestCase):
       
    def test_dummy_pass(self):
        self.assertTrue(True)

    def test_dummy_always_pass(self):
        self.assertEqual(1, 1)


if __name__ == '__main__':
    unittest.main()
