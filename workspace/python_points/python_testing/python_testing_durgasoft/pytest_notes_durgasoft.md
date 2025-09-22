
[Source : https://www.youtube.com/watch?v=9AOsrjkTKGc&list=PLd3UqWTnYXOlb7QmXAYRGxDGf2xJ07V9N&index=4]

Limitations of unit test:

> test methods are executed in alphabetical order ie. test_a, test_b,test_c order, even if you declare in differnt order
> from the above point it is not possible to customize execution order of test methods

> Its not possible to generate test results

> As the part of test suite all the test method will be executed, we can not skip selected test methods 

> No option to perform any operation before starting test suite and after test suite in unittest framework.

## Pytest naming conventions


> file name should start or end with 'test'
> Class name should start with 'test'
> Test method should start with 'test_'

> just typeing 'py.test' in the folder containing test modules will run all the tests present in the folder

> if we want to run only particular test moudule 'py.test <test_moudle_name.py>' will fun only passed moudule

> by default pytest will not print all the print statements in console so we have to either pass '-s' or '-v' for print statements

> just like unittest , pytests has setup(),teardown(),setupcalss(),teardownclass() methods and funtions the same way 


How to implement setup and teardown in pytests:
-----------------------------------------------
> Fixtures are functions, which will run before each test function to which it is applied. Fixtures are used to feed some data to the tests such as database connections, URLs to test and some sort of input data. Therefore, instead of running the same code for every test, we can attach fixture function to the tests and it will run and return the data to the test before executing each test.
> By using decorator @pytest.fixture()

eg :

@pytest.fixture()
def setUp() : ### this method name need not be as setup only we can give any name like m1(), setup and tear down is defined by fixtrues
        print('Setup method')

def test_method1():
        print('Test method 1')

def test_method2(setUp): ### here we are associating setup fixture with test_method2
        print('Test method 2')


How to implement teardown in pytests:
------------------------------------ 

>@pytest.yield.fixture() - > will act as both setup and tear down

eg:


@pytest.yield.fixture()
def setupandtearDown():
	setup_activity
	yield
	teardown_activity

> if we need to do only for teardown then

eg:

@pytest.yield.fixture()
def onlytearDown():
        yield ### remove setup activity
        teardown_activity

> if we want setup and tear down for all the test methods, ie if we want to execute only once before all test or moudle, we have to use 'scope'

@pytest.yield.fixture(scope='module') ### scope='fuction' by default
def tearDown():
        setup_activity
        yield
        teardown_activity


How to execute setup and teardown at class level and test method level:
----------------------------------------------------------------------

import pytest
@pytest.yield_fixture(scope='module')
def setupandteardownClass():
        print('class level setup')
        yield
        print('class level teardown')

@pytest.yield_fixture()
def setupandteardownmethod():
        print('method level setup')
        yield
        print('method level teardown')

def test_method1(setupandteardownClass,setupandteardownmethod):
        print('test_method1')

def test_method2(setupandteardownmethod):
        print('test_method2')


output:

test_example2.py class level setup
method level setup
test_method1
.method level teardown
method level setup
test_method2
.method level teardown
class level teardown

another example: 

import pytest


@pytest.yield_fixture(autouse=True,scope='module')
# @pytest.yield_fixture(scope='module')
def setupandteardownClass():
        print('class level setup')
        yield
        print('class level teardown')


# @pytest.yield_fixture(autouse=True,scope='function')
@pytest.yield_fixture(scope='function')
def setupandteardownmethod():
        print('method level setup')
        yield
        print('method level teardown')


# def test_method1(setupandteardownClass,setupandteardownmethod):
#         print('test_method1')
#
#
# def test_method2(setupandteardownmethod):
#         print('test_method2')


def test_method3():
        print('test_method2')

> If we need to use setup and teardown for all the modules then copying the same setup fixtures in all the module is redundant, instead we can use confest.py


> all common activities we have to define in this file
> *** name is constant, we can not change the conftest.py name



Possible ways to run pytest scrips:
---------------------------------

> py.test -s -v -> run all test moudles present in folder
> py.test -s -v <test_module.py> <test_module2.py> -> runs the particular test module
> py.test -s -v <test_movule.py>::test_medod1 -> only one method of test module will be executed
> unlike unittest, pytest execution order is from top to bottom

How to customize order of test execution in pytest:>
--------------------------------------------------
> pip3 install pytest-ordering

> @pytest.mark.run(order=n)

eg :

@pytest.mark.run(order=2)
def test_method1(setupandteardownClass,setupandteardownmethod):
        print('test_method1')
@pytest.mark.run(order=1)
def test_method2(setupandteardownmethod):
        print('test_method2')


How to generate Html reports:
----------------------------
> pip3 install pytest-html

> command to generate html report -> pytest -s -v <test_module> --html=<test_result_name>.html

>  



[source : https://stackoverflow.com/questions/10464502/how-can-i-skip-a-test-if-another-test-fails-with-py-test/45834419]


How to fail another test if one test fails:
-----------------------------------------

> pip install pytest-dependency

>>> https://pytest-dependency.readthedocs.io/en/latest/usage.html

import pytest
import pytest_dependency

@pytest.mark.dependency()   #First test have to have mark too
def test_function_one():
    assert 0, "Deliberate fail"

@pytest.mark.dependency(depends=["test_function_one"])
def test_function_two():
    pass   #but will be skipped because first function failed







  

