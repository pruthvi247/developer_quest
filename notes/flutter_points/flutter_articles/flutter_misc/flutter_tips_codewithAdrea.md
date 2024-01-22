[source https://codewithandrea.com/tips/2020-08-09-dart-flutter-easy-wins-1-7/]
[useful source: multiple]
```
dynamic v = 123;   // v is of type int.
v = 456;           // changing value of v from 123 to 456.
v = 'abc';         // changing type of v from int to String.

var v = 123;       // v is of type int.
v = 456;           // changing value of v from 123 to 456.
v = 'abc';         // ERROR: can't change type of v from int to String.

final v = 123;       // v is of type int.
v = 456;           // ERROR: can't change value of v from 123 to 456.
v = 'abc';         // ERROR: can't change type of v from int to String.
```

**dynamic**:
Can change TYPE of the variable, & can change VALUE of the variable later in code.
**var**:
can't change TYPE of the variable, but can change VALUE of the variable later in code.
**final**:
can't change TYPE of the variable, & can't change VALUE of the variable later in code.a final variable or field must have an initializer
Once assigned a value, a final variable's value cannot be changed.But it is set at runtime.You should always create a widget, not modify it. And the way to enforce that is to make all its fields final. 
**const**:
means that the value of the variable is known at compile time and it is going to be constant for the whole duration of the application.we can not change the value of const just like final variables, only diff between const and final is const value is known at compile time. the real advantage of using const is in a reactive UI like Flutter where large parts of the widget tree may be rebuilt regularly, every single object (and all of its own variables) used in every single widget will need to be recreated again on every rebuild, except if it is marked const, in which case it will reuse the same instance throughout the lifetime of the app.

**Static**: 
means a member is available on the class itself instead of on instances of the class.static is with respect to classes,we can not declare static variable/method inside main funtion.
*few facts about static variables:*
> Static variables are not initialized until they're used.
> Useful for representing class state and constants.
> Constants names are declared using lowerCamelCase convention.

*few facts about static methods:*
>Static / Class methods don't have access to this keyword.
>Static methods can be used as compile-time constants, and can be passed as parameters to constant constructor
>Static methods cannot be overridden

1.** Prefer const over final over var:**
-----------------------------------

```
const favourite = "i like pizza with tomatoes";
final newFavourites = favourite.replaceAll('pizza','pasta');
var totalSpaces = 0;
void main() {  
   for (var i=0; i<newFavourites.length; i++){
     final c = newFavourites[i];
     if (c==' '){
       totalSpaces++;
     }
}
  print('counted spaces : $totalSpaces');
}
```

[useful source : https://sites.google.com/site/dartlangexamples/learn/class/instance-variables/static]

A non-final static variable declaration always induces an implicit static setter function with signature
setter and getters:
```
class Location { 
  num _lat, _lng; // private instance variables
   // generative constructor
  Location([this._lat, this._lng]); 
  
  // Setters
  set lat(num lat) => _lat = lat;
  set lng(num lng) => _lng = lng;
 
  // Getters 
  num get lat1 => _lat;
  num get lng1 => _lng;
  
  //num get lat2() => _lat;  // this doesn work , throws error Error: A getter can't have formal parameters.
  //num get lng2() => _lng;
}

void main() {
  var waikiki = new Location(); 
  waikiki.lat = 21.271488; // Setting 
  waikiki.lng = -157.822806; // Setting
  
  print(waikiki.lat1); // Getting
  print(waikiki.lng1); // Getting
  
  
  var waikiki_new = new Location(56.2,26.2); 
  print(waikiki_new.lat1); // Getting
  print(waikiki_new.lng1); // Getting
  
}
```

Static variable example: 
```
class Adder {
  static int added = 0;
  
  static int add(int number) { // (I'd suggest overriding the + operator)
    return added += number;
  }
}

void main() {
  print(Adder.add(2)); // 2 
  print(Adder.add(3)); // 5
  print(Adder.add(5)); // 10
}
```


Static method example:
```
class StringUtils {
  static String removeUnderscores(String string) {
     return string.replaceAll("_", " ");
  }
  
  static int countAs(String string) {
    int total = string.length;
    int diff = string.replaceAll("A", "").length;
    return total - diff;
  }
}

void main() {
  print(StringUtils.removeUnderscores("I_went_to_the_store.")); // I went to the store.
  
  print(StringUtils.countAs("Apple abe Able Mable Arc At")); // 4
}
```

Constant Instances:
1. Use the const keyword to define a constant
>static final WAIKIKI = const Location(21.271488, -157.822806); 


2. Use type annotations for safer code:

> void main(){
  const cities = <String>['London',1]; // Throws error - A value of type 'int' can't be assigned to a variable of type 'String'
  const cities_new = <String>['London',"India"]; // works fine
}
  
3. Use underscores for unused function arguments:
> MaterialPageRoute(
builder: (_)=> DetailPage(), // ->>> use this
);
MaterialPageRoute(
builder: (context)=> DetailPage(),// ->>> to this 
);



4.  Functions are first class citizens in Dart, and they can be passed directly as arguments:
>
void main(){  
  const nnt = <int>[1,2,3,4];
  print(nnt.map(square).toList());
  print(nnt.map((val) => square(val)).toList());
  }
  int square(value){
  return value*value;
}

5. You can use collection-if and spreads with lists, sets AND maps:

```
void main(){  
  const addRatings = true;
  final avgRating=4.3;
  final numRatings = 5;
 final restaurant= {
   'name':'Pizza mario',
   'cusine':"Italian",
    if(addRatings)...{
     'avgRating': avgRating,
     'numRatings': numRatings,
   },
 };
  print(restaurant);
}
// output: {name: Pizza mario, cusine: Italian, avgRating: 4.3, numRatings: 5}
```

6. Use the cascade operator to modify mutable variables:

> var address = getAddress();
address.setStreet(“Elm”, “13a”);
address.city = “Carthage”;
address.state = “Eurasia”
address.zip(66666, extended: 6666); // instead of this 

> getAddress()
 ..setStreet(“Elm”, “13a”)
 ..city = “Carthage”
 ..state = “Eurasia”
 ..zip(66666, extended: 6666); // use this

> myList..add("item1")..add("item2")..add("itemN");

7. You can catch and handle exceptions by type with multiple `on` clauses:

> try {
  await authService.signInAnonymously();
} on PlatformException catch(e) {
 //Handle exception of type SomeException
}on SomeException catch(e) {
 //Handle exception of type SomeException
}  
catch(e) { // Dart is an optional typed language. So the type of e is not required
 //Handle all other exceptions
} 


[source : https://codewithandrea.com/tips/2020-08-13-dart-flutter-easy-wins-8-14/]

8. Use a `finally` block for code that should be executed *both* on success and failure:
> try{
  // code that can throw exceptions;
}
on SomeException catch(e){
  // for handling exceptions of ExceptionType1
}
catch(e){
  // for handling any exception
}
finally{ // finally block is optional
  // code that must always execute regardless of what exception is thrown
}

9. Implement `toString()` in your classes to improve the debugging experience.:
```
class MyClass {
    String data;
    MyClass(this.data);
    @override
    String toString() {
        return data;
    }
}
MyClass myObject = new MyClass("someData");
print(myObject); // outputs "someData", not 'Instance of MyClass'
```

10. Use the if-null operator to provide a fallback for null values:

> x= y??z; // assign y to x, unless y is null, otherwise assign z
x ??=y; // assign y to x if x is null
x?.foo(); // call foo() only if x is not null
void main() {
  var y;
  var z=2;
  var x = y??z;
  print(x);// prints 2
}

> exp ?? otherExp // ((x) => x == null ? otherExp : x)
> obj ??= value // ((x) => x == null ? obj = value : x)
> obj?.method() // ((x) => x == null ? null : x.method())

11. Use multi-line strings to represent large blocks of text.

> print(""" this is a multiline
  comments, this is longer sentence,
  this is an even loner sentence""");

12. String literals can use 'single' or "double" quotes as delimiters. Escape special characters with a backslash (\), or use raw strings:

> pritn('Today i\'m feeling great!');
> print("Today i'm freeling great!");
> print(r'c:\windows\system32'); 
> print(r'c:\windows\system\'32'); // this throws error

13. Use triple slashes to generate documentation comments:

14. Want to auto-generate hashCode, == and toString() implementations for your classes? Use the Equatable package:

```
//Without Equatable

class Person {
  final String name;

  const Person(this.name);

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Person &&
    runtimeType == other.runtimeType &&
    name == other.name;

  @override
  int get hashCode => name.hashCode;
}
// outputs :
> final person = Person('Bob');
>print(bob == Person("Bob")); // false
> print(person); // instance of 'person'
```

*with Equatable package*
```
import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final String name;

  const Person(this.name);

  @override
  List<Object> get props => [name];

  @override
  bool get stringify => true;
}
// outputs:
> print(bob == Person("Bob")); // true
```

[source : https://codewithandrea.com/tips/2020-08-16-dart-flutter-easy-wins-15-21/]

15. Need to shallow copy a list or collection? Use the spread operator:
>
void main() {
  List<int> a = [1,2,3];
List<int> b = [...a];
  a..add(4)..add(5);
  print(a);
  print(b);
}// output: [1, 2, 3, 4, 5] [1, 2, 3]

16. Need to invoke a callback but only if it's not null? Use the "?.call()" syntax:

> onDragCompleted?.call(); // ->> use this 

> if(onDragCompleted !=null){
onDragCompleted()		// instead of this	
}

17. Implement a "call" method in your Dart classes to make them callable like a function:
```dart
class Greet implements Function {
  String _greeting;
  Greet(this._greeting);

  call(String name) {
    return _greeting + ' ' + name;
  }
 dummy_method(){
    print("inside dummy_method");
    return true;
  }
  // alternative syntax for function
  // call(String name) => _greeting + ' '+ name; 
  // => is equivalent to the return statement
}
String followUp(String name) => 'Hey ' + name;
void main() {
  Greet hello = new Greet('Hello');
  
  print(hello('Ali'));
  print(followUp.call('John'));
  print(followUp("pruthvi"));
  print(hello.dummy_method());
  // you can call followUp('John') as well
  // call is implicitly called
}
/// ouput:
Hello Ali
Hey John
Hey pruthvi
inside dummy_method
true
```

18. Want a more ergonomic API for working with dates and times? Use extensions.:

19. Need to execute multiple Futures concurrently? Use Future.wait:

```dart
void main() {
Future<int> a = new Future(() { print('a'); return 1; });
Future<int> b = new Future(() { print('a'); return 2; });
Future<int> c = new Future(() { print('c'); return 3; });
  
  Future.wait([a,b, c]).then((v){
    print(v.toString());
    }).catchError((e) => print("some error"));
}
// output :

a
a
c
[1, 2, 3]
```

- Wait for all the given futures to complete and collect their values.Returns a future which will complete once all the futures in a list are complete. If any of the futures in the list completes with an error, the resulting future also completes with an error. Otherwise the value of the returned future will be a list of all the values that were produced.
``` void main() {
  Future<int> a = new Future(() { print('a'); return 1; });
Future<int> b = new Future.error('Error!');
Future<int> c = new Future(() { print('c'); return 3; });
  
  Future.wait([a,b, c]).then((v){
    print(v.toString());
    }).catchError((e) => print("some error"));
}
//output: 
a
c
some error
```

> The Future returned by wait() throws whichever error it receives as soon as it receives it, so all return values are lost, and if any of the other Futures throws an error, it isn't caught, but each Future still runs until returning or throwing an error.

20. Want to selectively import some APIs in a package? Use show & hide:
> import 'dart:async' show Stream;// Shows stream only
> import 'dart:async' hide StreamController; // shows all but StreamController

21. Use "import as" to avoid name collisions with other packages
> import 'package:http/http.dart' as http;


[source : https://codewithandrea.com/tips/2020-08-23-dart-flutter-easy-wins-22-28/]

22. Use `toStringAsFixed(n)` to format a number with n decimal places
> const x = 12.35698
> x.toStringAsFixed(3) // output : 12.356
> x.toStringAsPrecision(3)// output: 12.3 (total 3)
> x.toStringAsExponential(3)// output : 1.235e+1

23.Dart supports string multiplication

24. One constructor is not enough? Use named constructors and initializer lists for more ergonomic APIs:
```
class Player {
  final String name;
  final String color;
  Player(this.name, this.color);
  Player.fromPlayer(Player another) :
	    color = another.color,
	    name = another.name;
	}
```
25. Prefer factory constructors to static methods for deserialization:

useful source : https://dash-overflow.net/articles/factory/
> details of factory constructor can be found here (../../workspace/design_patterns/programs/dart_implementations/factory_pattern/factory_pattern_notes.txt) 

26. Need a class that can only be instantiated once (aka singleton)? Use static instance variable with a private constructor:
> class Singleton{
   Singleton._();
   static final instance = Singleton._();
}

27. Need a collection of unique items? Use a set rather than a list:


28. Use inheritance to model ISA relationships:
```dart
enum Action{eat,run,swim}

abstract class Animal{
  Set<Action> get actions;
  @override
  String toString() => '$runtimeType actions: $actions';
}

  class Dog extends Animal{
    @override
   Set<Action> get actions => {Action.eat,Action.run} ;
  }
class Shark extends Animal{
    @override
   Set<Action> get actions => {Action.eat,Action.swim} ;
  }

void main() {
  print(Dog().toString());
  print(Dog().actions);
  print(Dog());
  print(Shark());
}
```
// output:
```
Dog actions: {Action.eat, Action.run}
{Action.eat, Action.run}
Dog actions: {Action.eat, Action.run}
Shark actions: {Action.eat, Action.swim}
```

[source: https://dash-overflow.net/articles/factory/]
Difference between factory constructor and static method:












