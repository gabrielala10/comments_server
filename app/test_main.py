import unittest
import main 

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
    self.app.post('/api/comment/new', json=request_data)
    comments, status = main.api_comment_list(10)
    self.assertEqual(status, 200)
    self.assertEqual(len(comments), 1)


if __name__ == '__main__':
    unittest.main()