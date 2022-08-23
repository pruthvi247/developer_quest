
- For quick reference of dart syntax refer : {Source : https://dart.dev/samples}


##### premitive datatypes:
- numbers - int,float
- strings - "hello"
- booleans
- lists - aka arrays -list<int>
-  maps -hashmaps
- runes - unicode character sets
- symbols - `#symbol`

```dart
void main() {
   var x = (a, b) {
     print("Hello, from closure: ${a + b}");
  }(20, 30.0);
```

 Above code we have used clousers ,clousers are also called anonymus functions
 Dynamic x=5 -> we can assign any type of value to x since it is delared as dynamic eg : x="hello", it will override to string
 var x=5 and change to x="hellow" -> will throw error

you can change the type of `x`, but not `a`

```dart
void main() {
  dynamic x = 'hal';
  x = 123;
  print(x);
  var a = 'hal';
  a = 123;
  print(a);
}
```


**dynamic**: can change TYPE of the variable, & can change VALUE of the variable later in code.

**var** : can't change TYPE of the variable, but can change VALUE of the variable later in code.

**final**: can't change TYPE of the variable, & can't change VALUE of the variable later in code.




 > dynamic -> generalizes all types
 > object -> all types are derived from object

 ##### string interpolation 

 var x=10
 var y=20
 var a = "add numbers :$x and $y ${x+y}";
 `num` is a parent of int and double
 `object` is the parent for all objects in dart


 ##### Cascade notation (..)

Cascades (..) allow you to make a sequence of operations on the same object.
- In addition to function calls, you can also access fields on that same object.
- This often saves you the step of creating a temporary variable and allows you to write more fluid code.

Consider the following code:

```
querySelector('#confirm') // Get an object.
  ..text = 'Confirm' // Use its members.
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'));
```

> The first method call, querySelector(), returns a selector object. The code that follows the cascade notation operates on this selector object, ignoring any subsequent values that might be returned.

The previous example is equivalent to:

```
var button = querySelector('#confirm');
button.text = 'Confirm';
button.classes.add('important');
button.onClick.listen((e) => window.alert('Confirmed!'));
```

**another example** :
```dart
List list = [];
list.add(color1);
list.add(color2);
list.add(color3);
list.add(color4);
```

// with cascade

```dart
List list = [];
list
  ..add(color1)
  ..add(color2)
  ..add(color3)
  ..add(color4);
  ```


`dart 2.3 has a spread operator(...) which is equal to cascade, we need not use add() function`

```dart
var a = [0,1,2,3,4];
var b = [6,7,8,9];
var c = [...a,5,...b];
```

##### constructor:

```dart
class complex{
	num real;
	num imaginary;
	complex(this.real,this.imaginary); //constructor for the class complex

  @override
  bool operator ==(other) {
    if (!(other is Complex)) {
      return false;
    }
    return this._real == other._real && this._imaginary == other._imaginary;
  }

  @override
  String toString() {
    if (this._imaginary >= 0) {
      return '${this._real} + ${this._imaginary}i';
    }
    return '${this._real} - ${this._imaginary.abs()}i';
  }
}
```
**Named constructor:**(from above code)

	  Complex(this._real, this._imaginary);
	
	  Complex.real(num real) : this(real, 0);
	
	  Complex.imaginary(num imaginary) : this(0, imaginary);

```dart
var c2 = complex(5,4)
var r = complex.real(10)// named constructor,10 is set for real and 0 for imaginary value
var i = complex.imaginary(-4)// named constructor
```

**factory constructor** :
```dart
class Animal {
String type;

factory Animal(String type) {
     if (type == "cat") {
      return Cat(type);
     } else if (type == "dog") {
      return Dog(type);
     } else {
      throw AnimalException(type);
     }
   }

   Animal._type(this.type);
 }
```

-   A named constructor can only generate the instance of the current class.
-   A factory constructor can decide which instance to return on runtime, it can return either the instance of the current class or any of the instances of its descendants class.

factory point constructor:
```dart
// class Point {
//   final String name;
//   int _x;
//   int _y;

//   int get x => _x;
//   int get y => _y;

//   int get add => _x + y;


//   void set x(val) {
//     _x = val;
//   }

//   void set y(val) {
//     _y = val;
//   }

//   static final Map<String, Point> _cache = <String, Point>{};

//   Point(this._x, this._y, {this.name});

//   Point.zero() : name = "zero" { ############ this is because name field is declared final in the class,point.zero is a named constructor
//     _x = 0;
//     _y = 0;
//   }
```

**If we want to make an object private then prepend name with '_'**

```dart
class Complex {
  num _real;    // private variable
  num _imaginary;

  get real => _real;	// getter
  set real(num value) => _real = value; // setter

  get imaginary => _imaginary;
  set imaginary(num value) => _imaginary = value;
  }
```

##### Inheritance:

```dart
class Quaternion extends Complex {
  num jImage;

  Quaternion(
    num real,
    num imaginary,
    this.jImage,
  ) : super(
          real,
          imaginary,
        );
 ```
var numbers = Iterable.generate(1000, (i) => i);

`we can access first and last values of iterables numbers.first(),numbers.last()`

we can convert iterable to list,toset ,to string 

	// var list = numbers.toList();
	// var s = numbers.toSet();
	// var str = numbers.toString();

**we can use mixins with keywork 'with'**
**take while -> takes values till the condition is false, they are lazy,**
```dart
 print(
  numbers.takeWhile((n) => n < 10,).toList(),);
  ```
```dart
	// print(
  //   numbers.take(10).map((n) => n * 2).toList(),
  // );

  // print(numbers.any((n) => n % 2 == 0));

  // print(numbers.every((n) => n % 2 == 0));
   // print(
  //   numbers.where((n) => n % 2 == 0).toList(),
  // );
  // print(numbers.reduce((prev, i) => prev + i));
```
```dart
import 'dart:math' as Math;
print(numbers.reduce(Math.min));
print(numbers.reduce(Math.max));
```
```dart
  Map<int, int> map = Map.fromIterable(
    numbers.take(10),
  );
  var newMap = map.map(
    (int k, int v) => MapEntry(k, k + v),
  );
```



> link : https://steemit.com/utopian-io/@tensor/the-fundamentals-of-zones-microtasks-and-event-loops-in-the-dart-programming-language-dart-tutorial-part-3


##### Named arguments :
```dart
findVolume(int length, int breath, {int height=<defalut value>}) {
 print('length = $length, breath = $breath, height = $height');
}
```
> findVolume(10,20,height:30);
> height is the named argument here,named arguments are surrounded by {}



**Typedef**:
A typedef, or function-type alias, gives a function type a name that you can use when declaring fields and return types. A typedef retains type information when a function type is assigned to a variable.

```
typedef ManyOperation(int firstNo , int secondNo); 
//function signature  
```
```dart
Add(int firstNo,int second){ 
   print("Add result is ${firstNo+second}"); 
} 
Subtract(int firstNo,int second){ 
   print("Subtract result is ${firstNo-second}"); 
}
Divide(int firstNo,int second){ 
   print("Divide result is ${firstNo/second}"); 
}  
Calculator(int a, int b, ManyOperation oper){ 
   print("Inside calculator"); 
   oper(a,b); 
}  
void main(){ 
   ManyOperation oper = Add; 
   oper(10,20); 
   oper = Subtract; 
   oper(30,20); 
   oper = Divide; 
   oper(50,5); 
} 
```

`Typedefs can also be passed as a parameter to a function.`

```dart
typedef ManyOperation(int firstNo , int secondNo);   //function signature 
Add(int firstNo,int second){ 
   print("Add result is ${firstNo+second}"); 
}  
Subtract(int firstNo,int second){
   print("Subtract result is ${firstNo-second}"); 
}  
Divide(int firstNo,int second){ 
   print("Divide result is ${firstNo/second}"); 
}  
Calculator(int a,int b ,ManyOperation oper){ 
   print("Inside calculator"); 
   oper(a,b); 
}  
main(){ 
   Calculator(5,5,Add); 
   Calculator(5,5,Subtract); 
   Calculator(5,5,Divide); 
} 
```

>  **Note** In Dart, everything is, by default, public. To mark something private we use the _ (underscore) character. We can also use the @protected annotation provided by the meta Dart package. When added to a class member, it indicates the member should be used only inside the class or its subtypes.

======================================================
https://www.youtube.com/watch?list=PLJbE2Yu2zumDjfrfu8kisK9lQVcpMDDzZ&v=8F2uemqLwvE&feature=emb_logo
======================================================

-  pub - package manager for dart

- link : https://medium.com/run-dart/dart-dartlang-introduction-advanced-dart-features-524de79456b9

- link : https://medium.com/flutter-community/dart-what-are-mixins-3a72344011f3

- link :  https://medium.com/@jelenaaa.lecic/what-are-in-dart-df1f11706dd6

- link : https://github.com/erluxman/awesomefluttertips

======================================================
https://www.youtube.com/watch?list=PLJbE2Yu2zumDjfrfu8kisK9lQVcpMDDzZ&v=8F2uemqLwvE&feature=emb_logo
======================================================

**classes in dart:**
eg:
```dart
import 'dart:math';

class Position {
  // properties
  int x;
  int y;

  // methods
  double distanceTo(Position other) {
    var dx = other.x - x;
    var dy = other.y - y;
    return sqrt(dx * dx + dy * dy);
  }
}

main() {
  var origin = new Position()
    ..x = 0
    ..y = 0;

  var p = new Position()
    ..x = -5
    ..y = 6;

  print(origin.distanceTo(p));
}
```
[source: https://medium.com/analytics-vidhya/getting-started-with-dart-the-basics-24ac13efbc27]


##### Functions:
Dart is a true object-oriented language, so even functions are objects and have a type, Function. 
This means that functions can be assigned to variables or passed as arguments to other functions. 
Type of passed arguments need not be specific (although it’s best practice to do so)
`The basic syntax for defining a function is`
```dart
<return type>functionName(parameters){
(function body)
}
```
**Inline functions:**

Making functions in line using 
```dart
String sayHi(String name) =>'Hi $name'
```

**Optional Parameters**
Often times while calling functions the user isn’t always aware as to what they should use as arguments. Optional parameters come in handy. They are usually enclosed in square braces []

**Classes & Object-Oriented Programming:**

Dart is an object-oriented language with classes and mixin-based inheritance. Every object is an instance of a class, and all classes descend from Object. 
Mixin-based inheritance means that although every class (except for Object) has exactly one superclass, a class body can be reused in multiple class hierarchies. 
Extension methods are a way to add functionality to a class without changing the class or creating a subclass.

** Use extends to create a subclass, and super to refer to the superclass

** Enumerated types**
Enumerated types, often called enumerations or enums, are a special kind of class used to represent a fixed number of constant values.

`enum Days = {monday,tuesday,wednesday}`

```
void main(){
print(Days.monday.index) //->0
}
```

Null aware operators:
--------------------
- [source : https://medium.com/@thinkdigitalsoftware/null-aware-operators-in-dart-53ffb8ae80bb]
- [source : https://stackoverflow.com/questions/17006664/what-is-the-dart-null-checking-idiom-or-best-practice]
- [source: https://medium.com/flutter-community/simple-and-bug-free-code-with-dart-operators-2e81211cecfe]

> x=y ??Z; // assign y to x, unless y is null, other wise assign z

> x ??= y ; // assign y to x if x is null

> x?.foo() // call foo() only if x is not null

> `??`
Use ?? when you want to evaluate and return an expression IFF another expression resolves to null.
eg  : exp ?? otherExp; is similar to ((x) => x == null ? otherExp : x)(exp)

> ``??=``
Use ??= when you want to assign a value to an object IFF that object is null. Otherwise, return the object.
obj ??= value

> ``?.``
Use ?. when you want to call a method/getter on an object IFF that object is not null (otherwise, return null).
obj?.method()

> You can chain ?. calls, for example:
obj?.child?.child?.getter

> ``?…``
Dart 2.3 brings in a spread operator (…) and with it comes a new null aware operator, ?... !
Placing ... before an expression inside a collection literal unpacks the result of the expression and inserts its elements directly inside the new collection.
 eg : List lowerNumbers = [1, 2, 3, 4, 5];
List upperNumbers = [6, 7, 8, 9, 10];
List numbers = […lowerNumbers?…upperNumbers];

[source : https://bezkoder.com/dart-flutter-convert-object-to-json-string/#DartFlutter_convert_List_to_JSON_string]

Dart/Flutter convert List of objects to JSON string:
---------------------------------------------------
```dart
class Tag {
  String name;
  int quantity;

  Tag(this.name, this.quantity);

  Map toJson() => {
        'name': name,
        'quantity': quantity,
      };
}
```
Now everything becomes simple with jsonEncode() function.

```dart
import 'dart:convert';

main() {
  List<Tag> tags = [Tag('tagA', 3), Tag('tagB', 6), Tag('tagC', 8)];
  String jsonTags = jsonEncode(tags);
  print(jsonTags);
}
```
Enum utils:
----------
```
enum CarType {
  sedan,
  suv,
  truck
}
void main(){
  String enumToString(Object o) => o.toString().split('.').last;
  print(CarType.values[1]);
  print(CarType);
  print(enumToString(CarType.values[1]));
}
  ```
 ```
 import 'package:flutter/foundation.dart';
enum Day {
  monday, tuesday, wednesday, thursday, friday, saturday, sunday
}
print(describeEnum(day.MONDAY));
```

** `on` keyword:**
[source: https://medium.com/flutter-community/https-medium-com-shubhamhackzz-dart-for-flutter-mixins-in-dart-f8bb10a3d341#:~:text=The%20keyword%20on%20is%20used,mixin%20using%20the%20mixin%20keyword.]
```
class A {}

class B{}

mixin X on A{}

mixin Y on B {} 

class P extends A with X {} //satisfies condition as it extends A
class Q extends B with Y {} //satisfies condition as it extends B
```
> In the above code we are restricting mixins Xand Y to be only used by the classes which either implements or extends A and B respectively.

[source : https://stackoverflow.com/questions/38908285/add-methods-or-values-to-enum-in-dart]
Enum:

```dart
enum CodeVerifyFlow{
  SignUp, Recovery, Settings
}

extension CatExtension on CodeVerifyFlow {
  String get name {
    return ["sign_up", "recovery", "settings"][this.index];
  }
}

// use it like
CodeVerifyFlow.SignUp.name
```
##### Catching exceptions:
[source: https://jelenaaa.medium.com/catching-exceptions-in-flutter-dart-e777d4050ff6]

When using try/catch there is a difference when using await or not in front of your async function.
If you do not wait your async function to be finished, catch section will not be called when an exception is fired inside you async method.

```dart
void main() {
  try {
    catchMeIfYouCan();
  } catch (e) {
    print(e.toString());
  }
}
Future<void> catchMeIfYouCan() async {
  await Future.delayed(Duration(seconds: 1), () {
    throw Exception('did you?');
  });
}
output: Uncaught Error: Exception: did you?
```
`But, if you add await in front of the catchMeIfYouCan() method call:`

```dart
void main() async {
  try {
    await catchMeIfYouCan();
  } catch (e) {
    print(e.toString());
  }
}
#exception will be caught
```

If you do not wanna wait for your async function to finish in order to be able to proceed with your program execution, but still be able to catch errors inside it, you can use .catchError() callback like this:
```dart
void main() {
  catchMeIfYouCan().onError((e, _) {
    print(e.toString());
  });
}
```