### in this example we will see if multiple setUp() and tearDown() methods can be used of each test method


import unittest
  
class TestCaseDemo(unittest.TestCase):

        def setUp(self):
                print("setup of  method 1")
        def test_method1(self):
                print("test method 1 execution")
        def tearDown(self):
                print("Tear down method 1")
	def setUp(self):
                print("setup of  method 2")
        def test_method2(self):
                print("test method 2 execution")
        def tearDown(self):
                print("Tear down method 2")

unittest.main()

### from the observation, only setup of method 2 is executing, i mean last specified setup and teardown() methods are getting executed
