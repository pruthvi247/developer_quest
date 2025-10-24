### Error Widgets for UI Exceptions

Flutter provides a mechanism to display error messages directly in the UI when widgets fail to build or render. This is particularly useful during development, as it can provide immediate feedback about issues directly on the screen.

- **ErrorWidget**: Flutter uses the `ErrorWidget` class to create a widget when an error occurs in the widget tree. By default, the `ErrorWidget` displays a red screen with error details in debug mode, which is very helpful for developers. However, in production, you might want to display a more user-friendly error message.
    
- **Customizing ErrorWidget**: You can customize the appearance of error widgets globally by setting the `ErrorWidget.builder` to your own widget builder function. This allows you to replace the default red error screen with something more appropriate for your app, such as a message or an image indicating that something went wrong.
```dart
ErrorWidget.builder = (FlutterErrorDetails details) {
  bool inDebug = false;
  assert(() {
    inDebug = true;
    return true;
  }());
  // Show a friendly error message in production mode and detailed error in debug mode
  if (inDebug) {
    return ErrorWidget(details.exception);
  } else {
    return Container(
      alignment: Alignment.center,
      child: Text('Something went wrong!', style: TextStyle(color: Colors.red)),
    );
  }
};
```
### Global Error Handling

Flutter also allows you to handle errors globally, which is useful for catching and logging exceptions that are not caught by local try-catch blocks or for errors occurring in the Flutter framework itself.

- **FlutterError.onError**: Flutter provides the `FlutterError.onError` static function where you can set a custom error handler for uncaught errors in the Flutter framework. This is a place to log errors to your server, show general error messages, or perform other error handling strategies that are not specific to a particular widget or piece of code.
```dart
FlutterError.onError = (FlutterErrorDetails details) {
  // Log the error to a server
  logErrorToServer(details);
  // Optionally, pass the error to the default error handler
  // FlutterError.presentError(details);
};
```
**Zone Error Handling**: For errors that occur in Dart asynchronous code, you can capture unhandled exceptions by running your app inside a custom zone with error handling.

```dart
void main() {
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    // Handle uncaught errors from asynchronous operations
    logErrorToServer(error, stackTrace);
  });
}
```

### [Error Widget Class](https://api.flutter.dev/flutter/widgets/ErrorWidget-class.html)
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [ErrorWidget].

void main() {
  // Set the ErrorWidget's builder before the app is started.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // If we're in debug mode, use the normal error widget which shows the error
    // message:
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    }
    // In release builds, show a yellow-on-blue message instead:
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error!\n${details.exception}',
        style: const TextStyle(color: Colors.yellow),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      ),
    );
  };

  // Start the app.
  runApp(const ErrorWidgetExampleApp());
}

class ErrorWidgetExampleApp extends StatefulWidget {
  const ErrorWidgetExampleApp({super.key});

  @override
  State<ErrorWidgetExampleApp> createState() => _ErrorWidgetExampleAppState();
}

class _ErrorWidgetExampleAppState extends State<ErrorWidgetExampleApp> {
  bool throwError = false;

  @override
  Widget build(BuildContext context) {
    if (throwError) {
      // Since the error widget is only used during a build, in this contrived example,
      // we purposely throw an exception in a build function.
      return Builder(
        builder: (BuildContext context) {
          throw Exception('oh no, an error');
        },
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('ErrorWidget Sample')),
          body: Center(
            child: TextButton(
                onPressed: () {
                  setState(() {
                    throwError = true;
                  });
                },
                child: const Text('Error Prone')),
          ),
        ),
      );
    }
  }
}
```

### Global Error Handling

Flutter also allows you to handle errors globally, which is useful for catching and logging exceptions that are not caught by local try-catch blocks or for errors occurring in the Flutter framework itself.

- **FlutterError.onError**: Flutter provides the `FlutterError.onError` static function where you can set a custom error handler for uncaught errors in the Flutter framework. This is a place to log errors to your server, show general error messages, or perform other error handling strategies that are not specific to a particular widget or piece of code.

```dart
FlutterError.onError = (FlutterErrorDetails details) {

// Log the error to a server
logErrorToServer(details);
// Optionally, pass the error to the default error handler
// FlutterError.presentError(details);

};
```

`Another example` 
https://medium.com/@siddharthmakadiya/building-an-effective-error-handling-system-in-flutter-with-custom-widgets-c5a6fdfd29d9

```dart
void main() {  
  FlutterError.onError = (FlutterErrorDetails details) {  
    FlutterError.dumpErrorToConsole(details);  
    runApp(ErrorWidgetClass(details));  
  };  
  runApp(MyApp());  
}class ErrorWidgetClass extends StatelessWidget {  
  final FlutterErrorDetails errorDetails;ErrorWidgetClass(this.errorDetails);[@override](http://twitter.com/override)  
  Widget build(BuildContext context) {  
    return CustomErrorWidget(  
        errorMessage: errorDetails.exceptionAsString(),  
    );  
  }  
}class MyApp extends StatelessWidget {  
  [@override](http://twitter.com/override)  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      title: 'Custom Error Widget Example',  
      home: MyHomePage(),  
    );  
  }  
}class MyHomePage extends StatelessWidget {  
  [@override](http://twitter.com/override)  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text('Custom Error Widget Example'),  
      ),  
      body: ==Center(  
        child: ElevatedButton(  
          child: Text('Throw Error'),  
          onPressed: () {  
            throw Exception('An error has occurred!');  
          },  
        ),  
      ),  
    );  
  }  
}
```
### ErrorWidget.builder

- **Purpose**: `ErrorWidget.builder` is a static property that allows you to define a custom widget to be displayed whenever a widget fails to build. This is typically used to display a user-friendly error message instead of the default red error screen in release builds.
- **Scope**: It affects how Flutter displays widgets that encounter build-time errors. It's a UI-level error handling mechanism.
- **Usage**: You set this property at the root of your application to ensure that any uncaught errors in the widget tree that would otherwise result in the rendering of an `ErrorWidget` are displayed using your custom widget instead.

```dart
ErrorWidget.builder = (FlutterErrorDetails details) {
  return MyCustomErrorWidget(details: details);
};
```
### FlutterError.onError

- **Purpose**: `FlutterError.onError` is a static function that acts as a global error handler for Flutter framework errors that occur during the build, layout, and paint phases. It allows you to log, report, or handle these errors as needed.
- **Scope**: It's a broader error handling mechanism that can capture errors from the Flutter framework itself, not just widget build errors. It's more about error reporting and logging rather than displaying something on the UI.
- **Usage**: You can set this function at the start of your application to intercept and handle all errors caught by the Flutter framework.

```dart
FlutterError.onError = (FlutterErrorDetails details) {
  // Log to console or send to an error tracking service
  FlutterError.dumpErrorToConsole(details);
};
```
### Key Differences

- **Level of Operation**: `ErrorWidget.builder` operates at the widget level, providing a way to customize the display of errors that occur when widgets fail to build. `FlutterError.onError`, on the other hand, is a global error handler for the Flutter framework, allowing for logging, reporting, or handling of errors.
- **Purpose**: `ErrorWidget.builder` is specifically for customizing the appearance of errors in the UI, while `FlutterError.onError` is for error handling and potentially logging or reporting errors that occur within the Flutter framework.
- **Scope**: `ErrorWidget.builder` is limited to build-time widget errors, whereas `FlutterError.onError` has a broader scope that includes build, layout, and paint phase errors.

In summary, `ErrorWidget.builder` is used to customize the UI presented when an error occurs in widget building, while `FlutterError.onError` is a more comprehensive error handling mechanism for capturing and dealing with errors from the Flutter framework.