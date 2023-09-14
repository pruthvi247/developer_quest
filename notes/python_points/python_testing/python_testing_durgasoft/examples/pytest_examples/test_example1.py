import pytest


@pytest.fixture()
def setUp() : ### this method name need not be as setup only we can give any name like m1(), setup and tear down is defined by fixtrues
        print('Setup method')

def test_method1():
	print('Test method 1')

def test_method2(setUp):
        print('Test method 2')
