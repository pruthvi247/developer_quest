###TestSuite
import unittest
from example1 import *
from example2 import *


tc1 =  unittest.TestLoader().loadTestsFromTestCase(TestCaseDemo)

tc2 =  unittest.TestLoader().loadTestsFromTestCase(TestCaseDemo)


ts = unittest.TestSuite([tc1,tc2])

unittest.TextTestRunner().run(ts)


### unittest.main() line is commented in TestCaseDemo of exaple1.py so that we can use it in testsuite
