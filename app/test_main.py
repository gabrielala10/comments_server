import unittest
import main 

class TestMain(unittest.TestCase):
  def test_save_comment(self):
    comment = {"email": "test_unit@test.com", "comment": "Test unit in process!", "content_id": 10}
    main.api_comment_new(comment)
    comments, status = main.api_comment_list(10)
    self.assertEqual(status, 200)
    self.assertEqual(len(comments), 1)

if __name__ == '__main__':
    unittest.main()