
```dart
enum Size {
  small,
  medium,
  large
}

T stringToEnum<T>(String str, Iterable<T> values) {
  return values.firstWhere(
    (value) => value.toString().split('.')[1] == str,
    orElse: () => null,
  );
}

Size size = stringToEnum<Size>("medium", Size.values);
```
In this code, `T` represents the type to be provided by the caller of `stringToEnum()`. That type will be used as the function's return type, so when we call the function on the last line, size will be safely typed. Incidentally, `T` will be passed along to the `values` parameter type, ensuring that only the correct types will be accepted in the Iterable collection. The `stringToEnum()` function will operate in a type-safe way for any `enum`. Of course, if the provided string doesn't match any of the `enum` values, `null` will be returned.
Without generics, we might have to write `stringToSize()`, `stringToBorderType()`, `stringToTimespan()`, and so on, to cover all the different `enum` types we may need to deserialize from string dat

## Creating generic classes

You will also want to avoid creating separate classes for the sole purpose of handling different data types. Perhaps you need to create a specialized collection class, and you want to write it just once, allow it to handle any type, but still maintain type safety. Let's use a simple stack as an example
```dart
class Stack<T> {
  List<T> _stack = [];

  void push(T item) => _stack.add(item);
  T pop() => _stack.removeLast();
}
```
This class provides you with a collection that will do nothing but push items onto a stack and pop them off. It's impossible to access the stack's values directly from outside an instance, as the `_stack` property is private. Every operation is type safe through the use of generics, and the collection is guaranteed to be homogeneous (all elements will have the same type), as long as a type is provided when the stack is instantiated:
```dart
final stack = Stack<String>();

stack.push("A string.");  // works
stack.push(5);            // error
```
This stack will not allow a value of the wrong type to be added. Additionally, the `pop()` method will produce a value with a matching return type.