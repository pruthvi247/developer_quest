[medium-source](https://medium.com/flutter-community/how-the-getit-service-locator-package-works-in-dart-fc16a2998c07)

Before moving on to how GetIt works under the hood, let’s review how to use it.

Say you have a web API class that you want to access from several places within your app:
```dart
// storage_service.dart

abstract interface class StorageService {
  Future<void> saveData(String data);
}

class WebApi implements StorageService {
  @override
  Future<void> saveData(String data) async {
    // make http request
  }
}
```
You can use [GetIt](https://pub.dev/packages/get_it) for that. First, add `get_it` to your dependencies in **pubspec.yaml**:
Then make a file to register any services you plan to use in your app:

```dart
// service_locator.dart

import 'package:get_it/get_it.dart';
import 'storage_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<StorageService>(() => WebApi());
}
```
And call that method before your Flutter app starts:
```dart
// main.dart  
  
import 'service_locator.dart';  
  
void main() {  
setupServiceLocator();  
runApp(const MyApp());  
}
```
Then you can use GetIt to obtain a reference to your `WebApi` instance from some state management class like so:
```dart
import 'storage_service.dart';
import 'service_locator.dart';

class MyStateManager {
  void doSomething() {
    final storage = getIt<StorageService>();
    storage.saveData('Hello world');
  }
}
```
That’s the review. Now you’ll learn how to build that functionality yourself.

# Building GetIt yourself

The GetIt package is by Thomas Burkhart. The [source code](https://github.com/fluttercommunity/get_it) is in a Flutter Community GitHub repo. The current version of the code is somewhat complex, so it helped me understand how the code worked by going all the way back to [version 1.0](https://github.com/fluttercommunity/get_it/tree/de04750dec623e1147bed99f0e94e46bd79dfc51). I won’t follow the exact same naming conventions or coding style as the internal GetIt code, but it’ll be close.

I’ll write this article as a tutorial, so create a new Flutter project and follow along with me.

## Making GetIt a singleton

Create a new file in the **lib** folder named **get_it.dart**. Then add the following code:
```dart
class GetIt {  
GetIt._instance();  
static final instance = GetIt._instance();  
}
```
This makes `GetIt` a singleton class. The private named constructor `GetIt._instance()` ensures that users won’t be able to create a new instance of `GetIt` using the default constructor `GetIt()`. The static `instance` will always be the same value. (See [this post](https://stackoverflow.com/a/55348216) for other ways of creating singletons in Dart.)

Now your class will enable you to write something like this (as you saw previously using the `get_it` package):
```dart
final getIt = GetIt.instance;
```
## Three ways to register an object

There are three main ways to register a service with GetIt.

**_Note_**_: Actually, nowadays there are more than three, but in this tutorial we’ll just recreate the original three._

They’re the following:

1. **Register a factory**: This means that every time you request your service object, GetIt will create a new instance of it for you. Think of it like brand-new objects coming out of a factory. This is useful when you want to reinitialize the state, such as with a state management class for a Flutter UI screen that starts out fresh each time you navigate to it.
2. **Register a singleton**: You create a new instance of your service class at the time you register it with GetIt. Then GetIt always gives you that same instance back. This is useful when you want to keep the state of some service that you reference in multiple parts of your app. An example might be a database helper object.
3. **Register a lazy singleton**: Here you register your service class, but GetIt doesn’t actually create an instance of it until you request it for the first time. After that, it always returns the same instance. This is useful when you want your app to start up faster by delaying some of the initialization logic until you actually need it.

To prepare to implement these three ways of registration, add the following enum below your `GetIt` class:
```dart
enum _ServiceFactoryType {
  factory,
  singleton,
  lazySingleton,
}
```
The official `get_it` package calls these `alwaysNew`, `constant`, and `lazy`, but I find the names above easier to remember since they’ll have a one-to-one naming match with the functions you’ll create later.

## Holding the object or the object builder

The purpose of GetIt is to give you the object you ask for whenever you want it. As you saw in the previous section, though, sometimes GetIt creates a new instance and sometimes it gives you a reference to a previously created instance. That means GetIt needs to have one of two things:

1. An instance of the object itself, or
2. A function that will create the object.

Your next step will be to write a wrapper class that will encompass those two possibilities. Add the following class at the bottom of **get_it.dart**:
```dart
class _ServiceFactory<T> {
  _ServiceFactory({
    required this.type,
    this.creationFunction,
    this.instance,
  });

  final _ServiceFactoryType type;

  T Function()? creationFunction;
  T? instance;
}
```
Here are the notes:

- `_ServiceFactory` holds either the `instance` of your service class or the `creationFunction` that GetIt will use to build the `instance` in the future.
- The generic `T` is used to represent any service class type that you may wish to register. For example, `WebApi` or `DataRepo` or `StorageService`.
- Both `creationFunction` and `instance` are nullable because when you register a service, you’re only going to specify one of them. The one you don’t specify will be null.
- What’s not nullable, though, is the `_ServiceFactoryType`. That’s the value of the enum that you created in the last step. That is, `factory`, `singleton`, or `lazySingleton`.

Now that you have a way to hold the object or its creation function, you can proceed to the next step, the magic of GetIt itself.

## Storing the registered objects

The magic way that GetIt uses to store all of your registered objects is… _(drum roll)_… a map!

That’s it. No mysterious data structure or complex storage algorithm. Just a plain old Dart `Map`.

Add the following line to your `GetIt` class:
```dart
final _map = <Type, _ServiceFactory>{};
```
Maps are collections of key-value pairs. The key is a `Type` and the value is a `_ServiceFactory`. You’ve already been introduced to `_ServiceFactory`, but `Type` might be new for you. The `Type` type — (That makes me want to type, “Are you the type to type the `Type` type on a typewriter?”) — anyway, joking aside, the `Type` type is used for holding the different kinds of types that you have in Dart. Here are some examples:
```dart
Type myType = int;  
Type another = String;  
Type example = WebApi;
```
What that means in your `_map` is that you can look up a type and then get a `_ServiceFactory` wrapper back. For example, you look up the `WebApi` class type and get back a `_ServiceFactory` that either has an instantiated `WebApi` object or a function that will create the object.

The advantage of using the map data structure is that it’s fast. Returning a value from a map is an O(1) constant time operation.

## Creating the objects

Before you add the register methods to your `GetIt` class, you still need to do one more thing.

You need to add a method to your `_ServiceFactory` class that will handle when to create the object instances. Replace `_ServiceFactory` with the following complete implementation:
```dart
class _ServiceFactory<T> {
  _ServiceFactory({
    required this.type,
    this.creationFunction,
    this.instance,
  });

  final _ServiceFactoryType type;
  T Function()? creationFunction;
  T? instance;

  T getObject() {
    switch (type) {
      case _ServiceFactoryType.factory:
        return creationFunction!();
      case _ServiceFactoryType.singleton:
        return instance as T;
      case _ServiceFactoryType.lazySingleton:
        instance ??= creationFunction!();
        return instance as T;
    }
  }
}
```
Note the following about `getObject`:

- When the enum value is `factory`, you always return a new object of type `T` by calling `creationFunction`.
- When the enum value is `singleton`, you just return the existing object.
- When the enum value is `lazySingleton`, you create a new object if `instance` is `null`. Otherwise, you return the existing object.

## Adding the API to register services

Next, add the following `registerFactory` method to your `GetIt` class:
```dart
void registerFactory<T>(T Function() create) {
  final value = _ServiceFactory(
    type: _ServiceFactoryType.factory,
    creationFunction: create,
  );
  _map[T] = value;
}
```
This takes your creation function argument and wraps it in a `_ServiceFactory` class. Then you add this value to the map. The generic type `T` for the key will be the actual object type at run-time.

Add a similar method for `registerSingleton`:
```dart
void registerSingleton<T>(T instance) {
  final value = _ServiceFactory(
    type: _ServiceFactoryType.singleton,
    instance: instance,
  );
  _map[T] = value;
}
```
And another one for `registerLazySingleton`:
```dart
void registerLazySingleton<T>(T Function() create) {
  final value = _ServiceFactory(
    type: _ServiceFactoryType.lazySingleton,
    creationFunction: create,
  );
  _map[T] = value;
}
```
The only things that differed between these method bodies were the enum values and whether you provided the `creationFunction` or the `instance` value.

## Making GetIt callable

As you saw in the quick review section at the beginning of this article, the `get_it` package allows you to get a registered object using the following syntax:
```dart
final myObject = getIt<MyServiceClass>();
```
Note the `()` parentheses at the end. `getIt` is an instance but you can call it like a function if you implement the `call` method. (See the [callable objects documentation](https://dart.dev/language/callable-objects) for more details about this topic.)

Add the following method to your GetIt class:
```dart
T call<T>() {
  final serviceFactory = _map[T];
  return serviceFactory!.getObject() as T;
}
```
This code looks up the class type in the service factory map and returns the instance of that type, either by creating a new instance or by returning the stored instance.

That’s it! Now you can delete `get_it` from **pubspec.yaml.** The code in the Quick Review section at the start of the article should still work the same.

# Conclusion

The `get_it` package is much more sophisticated than what you built here. Nowadays, it handles [async factories](https://pub.dev/packages/get_it#asynchronous-factories) and [scopes](https://pub.dev/packages/get_it#scopes). It also has more error checking. However, if all you need are the basic features you built today, there’s no reason you can’t use your own implementation. I’m probably going to keep using the `get_it` package myself, but I like knowing how it works now. I hope you do, too.
FULL CODE:
```dart
// get_it.dart

class GetIt {
  GetIt._instance();
  static final instance = GetIt._instance();

  final _map = <Type, _ServiceFactory>{};

  T call<T>() {
    final serviceFactory = _map[T];
    return serviceFactory!.getObject() as T;
  }

  void registerFactory<T>(T Function() create) {
    final value = _ServiceFactory(
      type: _ServiceFactoryType.factory,
      creationFunction: create,
    );
    _map[T] = value;
  }

  void registerSingleton<T>(T instance) {
    final value = _ServiceFactory(
      type: _ServiceFactoryType.singleton,
      instance: instance,
    );
    _map[T] = value;
  }

  void registerLazySingleton<T>(T Function() create) {
    final value = _ServiceFactory(
      type: _ServiceFactoryType.lazySingleton,
      creationFunction: create,
    );
    _map[T] = value;
  }
}

enum _ServiceFactoryType {
  factory,
  singleton,
  lazySingleton,
}

class _ServiceFactory<T> {
  _ServiceFactory({
    required this.type,
    this.creationFunction,
    this.instance,
  });

  final _ServiceFactoryType type;

  T Function()? creationFunction;
  T? instance;

  T getObject() {
    switch (type) {
      case _ServiceFactoryType.factory:
        return creationFunction!();
      case _ServiceFactoryType.singleton:
        return instance as T;
      case _ServiceFactoryType.lazySingleton:
        instance ??= creationFunction!();
        return instance as T;
    }
  }
}
```
```dart
// service_locator.dart  
  
import 'get_it.dart';  
import 'my_state_manager.dart';  
import 'storage_service.dart';  
  
final getIt = GetIt.instance;  
  
void setupServiceLocator() {  
getIt.registerLazySingleton<StorageService>(() => WebApi());  
// getIt.registerSingleton<StorageService>(LocalStorage());  
getIt.registerFactory(() => MyStateManager());  
}
```
```dart
// storage_service.dart

abstract interface class StorageService {
  Future<void> saveData(String data);
}

class WebApi implements StorageService {
  @override
  Future<void> saveData(String data) async {
    print('Saving to the cloud: $data');
  }
}

class LocalStorage implements StorageService {
  @override
  Future<void> saveData(String data) async {
    print('Saving to SQLite: $data');
  }
}
```
```dart
// my_state_manager.dart

import 'service_locator.dart';
import 'storage_service.dart';

class MyStateManager {
  void doSomething() {
    final storage = getIt<StorageService>();
    storage.saveData('Hello world');
  }
}
```
```dart
// main.dart

import 'package:flutter/material.dart';
import 'my_state_manager.dart';
import 'service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: const Text('Do something'),
            onPressed: () {
              final manager = getIt<MyStateManager>();
              manager.doSomething();
            },
          ),
        ),
      ),
    );
  }
}
```
