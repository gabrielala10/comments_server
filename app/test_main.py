import unittest
from main import load_comments, save_comment

class TestMain(unittest.TestCase):
  def test_save_comment(self):
    comment = {"email": "test_unit@test.com", "comment": "Test unit in process!", "content_id": 10}
    save_comment(comment)
    comments, status = load_comments(10)
    self.assertEqual(status, 200)
    self.assertEqual(len(comments), 1)

if __name__ == '__main__':
    unittest.main()