# Python Interview Questions and Internal Working

> Source:  
> [sigmavirus24/python-interview-questions](https://github.com/sigmavirus24/python-interview-questions)  
> [Internal working of Python - GeeksforGeeks](https://www.geeksforgeeks.org/internal-working-of-python/)

---

## Q: How does Python execute code?

> Python doesn’t convert its code into machine code, something that hardware can understand. It actually converts it into something called byte code. So within Python, compilation happens, but it’s just not into a machine language. It is into byte code and this byte code can’t be understood by CPU. So we need actually an interpreter called the Python Virtual Machine. The Python Virtual Machine executes the byte codes.

The Python interpreter performs the following tasks to execute a Python program:

1. **Step 1:** The interpreter reads Python code or instruction. It verifies that the instruction is well formatted (syntax check). If it finds an error, it immediately halts and shows an error message.
    
2. **Step 2:** If no error is found, the interpreter translates the code into an intermediate language called _byte code_. This byte code is the output of a successful Python script execution.
    
3. **Step 3:** The byte code is sent to the Python Virtual Machine (PVM). The PVM executes the byte code. If an error occurs, it halts execution and displays an error.
    

> Note: The byte code file has the extension `.pyc`.

_Source: [https://www.quora.com/How-does-Python-execute-code](https://www.quora.com/How-does-Python-execute-code)_

## Detailed Steps:

- The update time of the script is compared with the update time of the corresponding `.pyc` file in the **pycache** directory. If the `.pyc` is newer, the interpreter skips ahead.
    
- The `.py` file is parsed into an Abstract Syntax Tree (AST), which maps out how the elements relate internally. Syntax errors are raised here.
    
- The AST is compiled into Python byte code, a set of opcodes for the Python Virtual Machine.
    
- The byte code is written into the **pycache** directory as `.pyc`.
    
- The byte code is passed to the Virtual Machine which executes the opcodes sequentially, operating on an internal stack.
    
- Runtime errors will be raised during this execution if encountered.
    
- When execution finishes, the Python Virtual Machine exits.
    

---

## Q: Python bindings, how does it work?

> Python bindings allow you to call functions and pass data between Python and C/C++ libraries, leveraging both languages' strengths. For example, if you create a C library and want to use it from Python, you write Python bindings. The CPython interpreter itself is written in C.

---

## Q: What is a list comprehension? Why would you use one?

Say you have a list of integers and want only even numbers. A typical approach:

python

`integers = range(0, 10) even = [] for i in integers:     if i % 2 == 0:        even.append(i) print(even) # Output: [0, 2, 4, 6, 8]`

**Python ways:**

- Using `filter`:
    

python

`even = filter(lambda x: x % 2 == 0, integers)`

- Using **list comprehension** (preferred and more Pythonic):
    

python

`even = [x for x in integers if x % 2 == 0]`

## Map example

Applies a function to every element without changing the number of elements:

python

`integers = range(0, 10) list(map(lambda x: x * x, integers)) # Output: [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]`

Equivalent with list comprehension:

python

`[x * x for x in integers] # Output: [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]`

## Reduce

Consumes a list but returns a single value:

python

`from functools import reduce integers = range(1, 10) reduce(lambda x, y: x * y, integers) # Output: 362880`

List comprehensions cannot be used here as they always return iterables.

## all() and any() with comprehensions example

python

`integers = range(1, 10) any(x % 2 == 0 for x in integers)  # True all(x % 2 == 0 for x in integers)  # False`

---

## Q: What is a generator? What can it be used for?

_Source: [https://www.programiz.com/python-programming/generator](https://www.programiz.com/python-programming/generator)_

> Normal functions return sequences by creating the entire sequence in memory—inefficient for large data sets. Generators provide memory-friendly iteration by yielding one item at a time.

Example of a manual iterator class (lengthy and complex):

python

`class PowTwo:     """Class to implement an iterator of powers of two"""    def __init__(self, max=0):        self.max = max    def __iter__(self):        self.n = 0        return self    def __next__(self):        if self.n <= self.max:            result = 2 ** self.n            self.n += 1            return result        else:            raise StopIteration numbers = PowTwo(3) i = iter(numbers) print(next(i))  # 1 print(next(i))  # 2 print(next(i))  # 4 print(next(i))  # 8 print(next(i))  # Raises StopIteration`

Better iterating with a for-loop is usual.

---

## Generators simplify iterator creation

- Defined as functions using `yield` instead of `return`.
- When called, they return a generator object without running the code immediately.
- Calling `next()` runs the function until the next `yield`, which pauses the function preserving local state.

Example:

python

`def my_gen():     n = 1    print('This is printed first')    yield n    n += 1    print('This is printed second')    yield n    n += 1    print('This is printed at last')    yield n a = my_gen() next(a)  # Prints "This is printed first" and returns 1 next(a)  # Prints "This is printed second" and returns 2 next(a)  # Prints "This is printed at last" and returns 3 next(a)  # Raises StopIteration`

To restart, create a new generator object.

---

## Generators with loops example

python

`def rev_str(my_str):     length = len(my_str)    for i in range(length - 1, -1, -1):        yield my_str[i] for char in rev_str("hello"):     print(char)`

---

## Inheritance

Inheritance is the capability of one class to derive or inherit properties from another.

---

## **init** method and self

- `__init__` is a reserved method in Python classes called the constructor.
    
- It initializes attributes when an object is created.
    
- `self` refers to the instance of the class, allowing access to attributes and methods.
    

---

## Q: What happens if you have an error in an **init** statement?

> If an error occurs in `__init__` without an exception handler, the object is not properly initialized and no instance is created.

You can raise exceptions safely inside `__init__` and handle them with try/except during object creation.

Example:

python

`import sys, os, traceback class MyClass:     def __init__(self, path):        self._path = path        try:            os.mkdir(path)        except:            traceback.print_exc(file=sys.stdout)`

---

## Q: How do I return multiple values from a function?

_Method 1: Returning a tuple_

python

`def get_image_data(filename):     # ...    return size, (format, version, compression), (width, height) size, type, dimensions = get_image_data(x)`

_Method 2: Returning a dictionary_

python

`def g(x):     y0 = x + 1    y1 = x * 3    y2 = y0 ** y3    return {'y0': y0, 'y1': y1, 'y2': y2}`

---

## Q: What’s the fastest way to swap two variables?

python

`x = 10 y = 5 x = x + y  # x becomes 15 y = x - y  # y becomes 10 x = x - y  # x becomes 5 print("After Swapping: x =", x, " y =", y)`

---

## Reference counting

Reference counting deallocates objects when no references to them remain. Every variable is a reference (pointer) to an object.

Example to get ref count:

python

`import sys sys.getrefcount(object)`

---

## Q: Do functions return something if there is no return statement? What do they return?

python

`def my_func1():     print("Hello World")    return None def my_func2():     print("Hello World")    return def my_func3():     print("Hello World")`

All these functions return `None` implicitly or explicitly.

---

## Q: How would you count the lines in a file? How to do it if the file is too big to hold in memory?

Reading in blocks and counting newline characters:

python

`def blocks(files, size=65536):     while True:        b = files.read(size)        if not b:            break        yield b with open("file", "r", encoding="utf-8", errors='ignore') as f:     print(sum(bl.count("\n") for bl in blocks(f)))`