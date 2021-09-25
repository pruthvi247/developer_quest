# setUpClass(cls) is used to execute only once before all the test methods executed,
# tearDown(class) is executed only once after all the test methods are executed.

import unittest

class TestCaseDemo(unittest.TestCase):
	@classmethod
	def setUpClass(cls):
		print("setup class method")
	@classmethod
        def tearDownClass(cls):
                print("teardown  class method")
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





###TestSuite
## import unittest
## from example1 import *
## from example2 import *


##tc1 =  unittest.TestLoader().loadTestsFromTestCase()


