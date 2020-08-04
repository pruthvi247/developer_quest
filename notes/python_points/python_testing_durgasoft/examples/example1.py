import unittest

class TestCaseDemo(unittest.TestCase):

	def setUp(self):
		print("setup method")
	def test(self):
		print("test method execution")
	def tearDown(self):
		print("Tear down method")

unittest.main()

#### setup and teardown method names can not be changed, but test method can be changed only condition is test method should be prefixed with "test_" eg : "test_method1"
### how to run the test -> we should call unittest.main()
#moudle name : unittest
#class name : Testcase
#instance methods : 3 methods -> setup(),test(),teardown()

#> for every test method execution setup() and teardown() methods will get executed
