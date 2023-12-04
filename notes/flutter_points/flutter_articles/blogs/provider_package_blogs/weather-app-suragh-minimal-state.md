[source-medium](https://suragch.medium.com/flutter-minimalist-state-management-weather-app-708b01417b9a)
This tutorial will walk you through making a basic weather app using the state management tools that are already built into Flutter. You’ll use a `ValueNotifier` to tell the UI when there’s a state change and a `ValueListenableBuilder` to rebuild the parts of the UI that have changed.

For background on the motivation and architectural principles, read [_Flutter State Management for Minimalists_](https://suragch.medium.com/flutter-state-management-for-minimalists-4c71a2f2f0c1?sk=6f9cedfb550ca9cc7f88317e2e7055a0). Also check out the [counter app tutorial](https://suragch.medium.com/flutter-minimalist-state-management-counter-app-ab1671a1f877) for an even more basic example. This article will build on that by introducing how to handle the common use cases of making web requests and storing data locally. For that, you’ll use services and provide access to them with the [GetIt](https://pub.dev/packages/get_it) package.

The weather app will contact a web API on startup and, depending on the response, either show an error screen or the current temperature and weather. There is also a button in the top right to switch the temperature between Celsius and Fahrenheit.
![[Pasted image 20231121085454.png]]
Let’s get started.

# Creating the weather app

Create a new Flutter project and name it **weather_app**:

`flutter create weather_app`
# Setting up the file structure

Create the following folder and file structure within the **lib** folder of your project:
```dart
lib  
  models  
    weather.dart  
  pages  
    home  
      home_page.dart  
      home_page_manager.dart  
  services  
    web_api.dart  
    local_storage.dart  
    service_locator.dart  
  main.dart
```
You can leave the new files empty for now. You’ll fill them in as you go through the tutorial.

The file structure generally corresponds to the app architecture below:
![[Pasted image 20231121085538.png]]
This is the architecture that you’ll use in this tutorial.

Sometimes I use the repository pattern to provide a single app-facing interface for the services:

![[Pasted image 20231121085552.png]]
That’s not what you’ll do in this app, though. The state management class will talk directly to the web API and storage services.

# Defining a data model

This is a weather app, so make a data class to hold the information the app will need.

Add the following code to **lib/models/weather.dart**:
```dart
class Weather {  
const Weather({  
required this.description,  
required this.temperature,  
});  
final String description;  
final int temperature;  
}
```
_aps to the JSON coming from your web API. Or you might have a presentation data object that gives your UI exactly what it needs. These data objects might both be slightly different than the data model object that your core business logic uses. For this app, though, we’ll just use one data object._

# Building the services

When making an app, I usually start by building the UI and using fake data to fill in the parts I don’t have yet. For the case of a tutorial, though, that requires jumping back and forth between files and making lots of changes as you progress along. So, to keep the process a little more straightforward, let’s go the other way around. We’ll start with the data and build back toward the UI.

## Web API service

First, let’s get the weather for a given location.

You’ll need the [http](https://pub.dev/packages/http) package, so add it to your **pubspec.yaml**:
```dart
dependencies:  
http: ^1.1.0
```
Open **lib/services/web_api.dart** and add the following:
```dart
import 'dart:convert';  
import 'package:http/http.dart';  
import 'package:weather_app/models/weather.dart';  
  
// 1  
abstract interface class WebApi {  
  Future<Weather> getWeather({  
    // 2  
    required double latitude,  
    required double longitude,  
  });  
}  
  
// 3  
class FccApi implements WebApi {  
  @override  
  Future<Weather> getWeather({  
    required double latitude,  
    required double longitude,  
  }) async {  
    final url = Uri.parse('https://fcc-weather-api.glitch.me/api/current'  
        '?lat=$latitude&lon=$longitude');  
    final result = await get(url);  
    final jsonString = result.body;  
    final jsonMap = jsonDecode(jsonString);  
    final temperature = jsonMap['main']['temp'] as double;  
    final weather = jsonMap['weather'][0]['main'] as String;  
    return Weather(  
      temperature: temperature.toInt(),  
      description: weather,  
    );  
  }  
}
```
Here are a few notes about the numbered comments above:

1. You’re defining an interface named `WebApi`. The purpose is to tell what your API doesn’t without specifying how it’s implemented. This allows you to create a plug-in architecture where you can swap out implementations without affecting the code in the rest of your app. Read [_Flutter state management for minimalists_](https://suragch.medium.com/flutter-state-management-for-minimalists-4c71a2f2f0c1?sk=6f9cedfb550ca9cc7f88317e2e7055a0) for more background. Some people find an interface with a single implementation (as you have here) to be an unnecessary abstraction. You can make your own decision about that.
2. Your API takes latitude and longitude as the input parameters. Another option would have been to provide a city name.
3. `FccApi` is the concrete implementation of your `WebApi` interface. FCC stands for [freeCodeCamp](https://www.freecodecamp.org/), the provider of the [API](https://fcc-weather-api.glitch.me/) this code uses. If you’re making a production weather app, you’ll probably want to find a different API because this one has a rather strict rate limit. (It returns fake data if you make multiple requests in quick succession.) The API is nice for a tutorial, though, because it doesn’t require an API key.

**_Note_**_: Although your API supports any geographic coordinates, in order to simplify things, the rest of the app will hard-code the values for Ulaanbaatar, Mongolia._

## Local storage service

We’ll use the [shared_preferences](https://pub.dev/packages/shared_preferences) package to implement local storage for this app. Add that to your **pubspec.yaml** file:

```dart
dependencies:  
shared_preferences: ^2.2.2
```
Then add the following code to **lib/services/local_storage.dart**:
```dart
import 'package:shared_preferences/shared_preferences.dart';  
  
abstract interface class LocalStorage {  
  Future<void> init();  
  
  bool get isCelsius;  
  Future<void> saveIsCelsius(bool value);  
}  
  
class SharedPrefsStorage implements LocalStorage {  
  static const isCelsiusKey = 'isCelsius';  
  static const latitudeKey = 'latitude';  
  static const longitudeKey = 'longitude';  
  
  late SharedPreferences prefs;  
  
  @override  
  Future<void> init() async {  
    prefs = await SharedPreferences.getInstance();  
  }  
  
  @override  
  bool get isCelsius => prefs.getBool(isCelsiusKey) ?? true;  
  
  @override  
  Future<void> saveIsCelsius(bool value) async {  
    await prefs.setBool(isCelsiusKey, value);  
  }  
}
```
You don’t need to add an `init` method if you don’t want to, but the reason I like to (and the reason this tutorial is doing so) is so that the getter is a fast synchronous operation. We’ll need to remember to call `init` when the app starts up.

If you haven’t used shared preferences before, read [_Saving and reading data in Flutter with SharedPreferences_](https://suragch.medium.com/saving-and-reading-data-in-flutter-with-sharedpreferences-bb4238d3105?sk=0926a92ceb83a9eb0bc8602c4b65a451).

## Service locator

In order to provide your web API and local storage services to the rest of your app, you’ll use the [get_it](https://pub.dev/packages/get_it) package, which is a [service locator](https://en.wikipedia.org/wiki/Service_locator_pattern). (Alternatively, you could write your own service locator. Read [_How the GetIt service locator package works in Dart_](https://suragch.medium.com/how-the-getit-service-locator-package-works-in-dart-fc16a2998c07?sk=496f177587ce0c6932d8874642fc9425) if you’re interested.)

Add the dependency to **pubspec.yaml**:

```dart
dependencies:  
get_it: ^7.6.4
```
Then add the following to **lib/service/service_locator.dart**:
```dart
import 'package:get_it/get_it.dart';  
import 'package:weather_app/services/local_storage.dart';  
import 'package:weather_app/services/web_api.dart';  
  
final getIt = GetIt.instance;  
  
void setupServiceLocator() {  
getIt.registerLazySingleton<WebApi>(() => FccApi());  
getIt.registerLazySingleton<LocalStorage>(() => SharedPrefsStorage());  
}
```
The outside world will only know the names `WebApi` and `LocalStorage`, not the names of the concrete implementation classes.

We’ll need to call `setupServiceLocator` before the app starts.

# Building the UI

Now that the services are finished, you can work on using them to build the UI. First you’ll set up the state management class with its notifiers, and then you’ll create the widgets that display the app state.

## Managing the state

Open **lib/pages/home/home_page_manager.dart** and add the following code. The numbered comments will have explanations below:

```dart
import 'package:flutter/foundation.dart';
import 'package:weather_app/services/local_storage.dart';
import 'package:weather_app/services/service_locator.dart';
import 'package:weather_app/services/web_api.dart';

class HomePageManager {
  // 1
  HomePageManager({WebApi? webApi, LocalStorage? storage}) {
    _webApi = webApi ?? getIt<WebApi>();
    _storage = storage ?? getIt<LocalStorage>();
  }

  late WebApi _webApi;
  late LocalStorage _storage;

  // 2
  final loadingNotifier = ValueNotifier<LoadingStatus>(const Loading());
  final temperatureNotifier = ValueNotifier<String>('');
  final buttonNotifier = ValueNotifier<String>('°C');

  late int _temperature;

  // 3
  Future<void> loadWeather() async {
    loadingNotifier.value = const Loading();
    final isCelsius = _storage.isCelsius;
    buttonNotifier.value = (isCelsius) ? '°C' : '°F';
    try {
      final weather = await _webApi.getWeather(
        longitude: 106.9057,
        latitude: 47.8864,
      );
      _temperature = weather.temperature;
      final temperature =
          (isCelsius) ? _temperature : _convertToFahrenheit(_temperature);
      temperatureNotifier.value = '$temperature°';
      loadingNotifier.value = LoadingSuccess(
        weather: weather.description,
      );
    } catch (e) {
      print(e);
      loadingNotifier.value = const LoadingError(
        'There was an error loading the weather.',
      );
    }
  }

  int _convertToFahrenheit(int celsius) {
    return (celsius * 9 / 5 + 32).toInt();
  }

  void convertTemperature() {
    final isCelsius = !_storage.isCelsius;
    _storage.saveIsCelsius(isCelsius);
    final temperature =
        (isCelsius) ? _temperature : _convertToFahrenheit(_temperature);
    temperatureNotifier.value = '$temperature°';
    buttonNotifier.value = (isCelsius) ? '°C' : '°F';
  }
}

// 4
sealed class LoadingStatus {
  const LoadingStatus();
}

class Loading extends LoadingStatus {
  const Loading();
}

class LoadingError extends LoadingStatus {
  const LoadingError(this.message);
  final String message;
}

class LoadingSuccess extends LoadingStatus {
  const LoadingSuccess({
    required this.weather,
  });
  final String weather;
}
```
Explanations:

1. Initializing your web API and local storage services like this in the constructor makes it easy to mock them out in your unit tests.
2. Add a `ValueNotifier` for each part of your UI that needs rebuilding when the state changes.
3. `loadWeather` will serve as both an initialization method when the app starts up and also as a refresh method. I usually name this method `init` when its only purpose is initialization.
4. `LoadingStatus` is similar to an enum with three values `Loading`, `LoadingError`, and `LoadingSuccess`. Instead of an enum though, you’re using a sealed class. This allows you to provide the appropriate data to the UI depending on what the loading state is. Also, since the classes are sealed, the compiler will help you know that you’re handling every possibility when you use a switch statement. I got the inspiration for this pattern from the Flutter Bloc package. You can use an enum or a combination of Booleans and strings if this pattern doesn’t make sense to you.

## Creating the UI

Your UI will listen to the notifiers from the manager class and react to their state updates.

Open **lib/pages/home/home_page.dart** and add the code below. As usual, the interesting parts have numbered comments:
```dart
import 'package:flutter/material.dart';
import 'package:weather_app/pages/home/home_page_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1
  final manager = HomePageManager();

  // 2
  @override
  void initState() {
    super.initState();
    manager.loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        // 3
        child: ValueListenableBuilder<LoadingStatus>(
          valueListenable: manager.loadingNotifier,
          builder: (context, loadingStatus, child) {
            switch (loadingStatus) {
              case Loading():
                return const CircularProgressIndicator();
              case LoadingError():
                // 4
                return ErrorWidget(
                  errorMessage: loadingStatus.message,
                  onRetry: manager.loadWeather,
                );
              case LoadingSuccess():
                // 5
                return WeatherWidget(
                  manager: manager,
                  weather: loadingStatus.weather,
                );
            }
          },
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });
  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorMessage),
        TextButton(
          onPressed: onRetry,
          child: const Text('Try again'),
        ),
      ],
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
    required this.manager,
    required this.weather,
  });
  final HomePageManager manager;
  final String weather;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // 6
            child: TextButton(
              onPressed: manager.convertTemperature,
              child: ValueListenableBuilder<String>(
                valueListenable: manager.buttonNotifier,
                builder: (context, buttonText, child) {
                  return Text(
                    buttonText,
                    style: textTheme.bodyLarge,
                  );
                },
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 7
              ValueListenableBuilder<String>(
                valueListenable: manager.temperatureNotifier,
                builder: (context, temperature, child) {
                  return Text(
                    temperature,
                    style: const TextStyle(fontSize: 56),
                  );
                },
              ),
              Text(
                weather,
                style: textTheme.headlineMedium,
              ),
              Text(
                'Ulaanbaatar',
                style: textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```
Here’s the explanation of the numbered comments above:

1. Create an instance of your `HomePageManager` in the state class of your stateful widget. This will only be created once.
2. Getting access to `initState` is the main reason stateful widgets are useful. This allows to to call some method as soon as the UI starts loading. In this case, you call `loadWeather`, which will call your weather API.
3. This `ValueListenableBuilder` rebuilds the UI every time `LoadingStatus` changes. For every state (loading, error, and success), you return a different UI widget. Since you handle every possibility with your sealed classes, you don’t need to give the switch statement a `default` option. If you forget one, the compiler will tell you.
4. The `ErrorWidget` has a retry button, so it needs to access the `loadWeather` method from your manager class. Pass that in as a parameter.
5. The `WeatherWidget` needs to access the `manager` object in a few different ways. Usually when that’s the case, I just pass down the manager itself as a parameter. If you find your manager class doing too much, you can factor out the logic and create smaller manager classes for the child widgets.
6. The Celsius/Fahrenheit button label gets updated based on the state, so it needs its own `ValueListenableBuilder`.
7. The temperature number also needs updating depending on the Celsius/Fahrenheit state, so this part also has its own `ValueListenableBuilder`.

Note that the UI above is dumb. It doesn’t perform any logic (except the simple `switch` statement). All the logic and preparation for display is handled by the manager class. The only job of the UI class is to display what the manager has already prepared. This helps to keep bugs out of the UI, which is more difficult to test than the manager class is.

## Tying it all together

You’re almost finished. Open **lib/main.dart** and replace the contents with the following code:

```dart
import 'package:flutter/material.dart';
import 'package:weather_app/pages/home/home_page.dart';
import 'package:weather_app/services/local_storage.dart';
import 'package:weather_app/services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt<LocalStorage>().init();
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
```
Before running the app in `main`, you first register your services with GetIt and then initialize the local storage service.

If you need to, also perform whatever platform-related tasks are needed to allow access to the internet. ([macOS](https://stackoverflow.com/a/61201109/3681880), [Android](https://stackoverflow.com/a/55606098/3681880))

# Testing it out

Run your app and you should see the following result:
![[1_nSdPlHjtHTOXcuemb73FkA.gif]]
You can find [the full project on GitHub](https://github.com/suragch/weather_app).

Were there any parts of the tutorial that didn’t make sense? Do you have any suggestions for improvement or a disagreement about some aspect? Leave a comment below.

Also refer  :
scott stoll EL5
- https://github.com/ScottS2017/valuenotifier_simplified/blob/master/lib/ui_page.dart
- https://www.youtube.com/watch?v=Jx7JzP3-KYE
- https://brewyourtech.com/complete-guide-to-valuenotifier-in-flutter/
- https://medium.com/flutter-ease/4-approaches-to-write-a-reactive-widget-in-flutter-without-using-statefulwidget-96e9a947b97d
- 
