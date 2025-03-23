import unittest
import main
from flask import json

class TestMain(unittest.TestCase):
  @classmethod
  def setUpClass(test):
    test.app = main.app.test_client()
    test.app.testing = True  

  def test_save_comment(self):
    request_data = {
        "email": "test_unit@test.com",
        "comment": "Test unit test!",
        "content_id": 10
    }

    response = self.app.post('/api/comment/new', json=request_data)
    response_data = json.loads(response.data)
    self.assertEqual(response_data['status'], 'SUCCESS')
    
    response = self.app.get('/api/comment/list/10')
    self.assertEqual(response.status_code, 200)
    comments = json.loads(response.data)
    self.assertEqual(len(comments), 1)
    self.assertEqual(comments[0]['email'], "test_unit@test.com")
    self.assertEqual(comments[0]['comment'], "Test unit test!")

if __name__ == '__main__':
    unittest.main()