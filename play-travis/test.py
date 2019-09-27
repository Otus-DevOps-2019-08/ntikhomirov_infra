import unittest

class NumbersTest(unittest.TestCase):

    def test_equal(self):
        self.assertEqual(1 + 1, 2)
        self.assertEqual(1 - 1, 0)
        self.assertEqual(10 + 10, 100)
        self.assertEqual(50/0.5, 100)

if __name__ == '__main__':
    unittest.main()