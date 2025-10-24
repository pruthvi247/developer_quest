# It’s Not Flutter
[source](https://andrious.medium.com/its-not-flutter-1b7c415eb487)

Like any good framework, Flutter doesn’t impose its chosen pattern allowing developers to implement BLoC, RiverPod, etc. —likely a design pattern they are already familiar with. However, it’s my opinion using one that resembles the underlying framework will make developing and maintaining an app that much easier, that much more efficient, and that much more effective.

The design pattern taken up by the Flutter framework is like the MVC design pattern, but more like the [PAC](https://softwareengineering.stackexchange.com/questions/207620/what-are-the-downfalls-of-mvc#answer-207672) ([Presentation-Abstraction-Control](http://en.wikipedia.org/wiki/Presentation%E2%80%93abstraction%E2%80%93control)) design pattern. Flutter’s emphasis is more on the Interface (Presentation), then a little on the logic and event handling (Controller), and even less on data (Model). In Flutter, data is an Abstraction. It can be anything; It can be nothing. It’s implementation is left to the developer.

Further, Google engineers have only issued a Controller class to a select number of Widgets so far (see Google search below). With these Widgets, their **build**() functions will work the interface while their Controller class will work the widget’s data, logic, and or event handling.

# Take Control

In this article, a controller is supplied to the State class. That Controller will then have a reference to the State object allowing for a very powerful capability. A capability coveted by all those State Management solutions out there: Allowing for the change-in-state to be conveyed at any time and from anywhere. See below.

`controller.state.setState((){});   controller.setState((){});`

The class, _StateX_, will be introduced in this article — it comes from the package, [_state_extended_](https://pub.dev/packages/state_extended). Its constructor can take in a ‘State Object Controller’ and will then reference that Controller using the property, _controller_. See the screenshot below for an example.
[weather_page.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/main/view/weather_page.dart#L13)
```dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_weather/search/search.dart';
// import 'package:flutter_weather/settings/view_settings.dart';
// import 'package:flutter_weather/weather/weather.dart';

import '/src/controller.dart';

import '/src/model.dart';

import '/src/view.dart';

///
class WeatherPage extends StatefulWidget {
  ///
  const WeatherPage({super.key});
  @override
  State<StatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends StateX<WeatherPage> {
  _WeatherPageState()
      : super(controller: WeatherController(), useInherited: true) {
    con = controller as WeatherController;
  }

  late WeatherController con;

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push<void>(
              SettingsPage.route(),
            ),
          ),
          AppMenu(),
        ],
      ),
      body: Center(
        // Only this part of the interface will ever rebuild.
        child: setBuilder(
          (_) {
            final status = con.weatherStatus;
            switch (status) {
              case WeatherStatus.initial:
                return const WeatherEmpty();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.failure:
                return const WeatherError();
              case WeatherStatus.success:
                final state = con.stateOfWeather;
                return WeatherPopulated(
                  weather: state.weather,
                  units: state.temperatureUnits,
                  onRefresh: () {
                    return con.refreshWeather();
                  },
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search, semanticLabel: 'Search'),
        onPressed: () async {
          final city = await Navigator.of(context).push(SearchPage.route());
          if (context.mounted) {
            await con.fetchWeather(city);
          }
        },
      ),
    );
  }

  /// Set it to return false and try a new city. It won't work.
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
```

This separate Controller class now has a reference to a State object and all that that entails. Make up your own State Object Controller, by extending the class, _StateXController_, and further receive a variety of properties and capabilities:

> `_con.state;_ **_The current State object assigned to the Controller._**_con.initAsync();_ **_Run asynchronous operations before State build() runs.   _**_con.appState;_ **_The 'AppState' object. The app's first State object._**_con.firstState;_ **_The first State object ever assigned to this Controller._**_con.dependOnInheritedWidget(context);_ **_Register widget to InheritedWidget._**_con.dataObject;_ **_Optional 'data object' passed down through the app._**_con.inDebugMode;_ **_Boolean indicating if running in Production or not._**_con.lastContext;_ **_The lastest context object in the Widget tree._**_con.lastState;_ **_The latest State object assigned to this Controller._**_con.forEachState((state){});_ **_Loop through its State objects._**_con.notifyClients();_ **_Call the built-in InheritedWidget._**_con.ofState<_MainPageState>();_ **_Returns specified State object._**_con.setState((){});_ **_Calls current State object's setState() function.   _**_con.setBuilder();_ **_setState() will rebuild the Widget from this builder._**_con.stateOf<MainPage>();_ **_Returns the StatefulWidget's State object._**`

Further note, it’s a Mixin that supplies much of this functionality to these Controllers (see below). If you don’t want to use the class, _StateX,_ you can always use the Mixin instead.

![[Pasted image 20250806142028.png]]
[part14_set_state_mixin.dart](https://github.com/AndriousSolutions/state_extended/blob/f7aa762b7afc1b47412df4718d0c242f27875af1/lib/part14_set_state_mixin.dart#L7)

I‘ve migrated the ‘weather’ example app from BloC to this ‘MVC-more-like-PAC’ approach using the [Fluttery Framework](https://pub.dev/packages/fluttery_framework) package. In this article, I’ll describe the differences between these two implementations.

Both GitHub repositories are available below:
1. https://github.com/felangel/bloc/tree/master/examples/flutter_weather
2. https://github.com/Andrious/flutter_weather?source=post_page-----1b7c415eb487---------------------------------------

# Control Your Build

Below is a side-by-side comparison of the example app’s Settings page. The first screenshot below is the original BLoC version with its **BlocBuilder**() function while the second screenshot uses the class, StateXController, and its **setBuilder**() function. Both are functions that rebuild with a **setState**() function call leaving the rest of the interface untouched.

Note how some of the logic (how values are conceived) is more readily visible in the BLoC version. For example, in the first screenshot, the property, _WeatherState_, is exposed in the interface while the Controller version in the second screenshot only displays designated properties and necessary functions from the Controller object, __con._

_S_upplying such a layer of abstraction encourages better modularity, better adaptation, better scalability, and generally better maintenance of the software. It provides the interface that’s needed without revealing how it’s provided. That way, in the future, you can change how that’s done with ease without changing one bit of the interface.

[left-git](https://github.com/felangel/bloc/blob/f951eef84e4e740697b712ff3e1cf244eea3a1e6/examples/flutter_weather/lib/settings/view/settings_page.dart#L15) [right-git](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/main/view/settings/settings_page.dart#L24)

# Inherited Builds

In the BLoC version, the BlocProvider implements an InheritedWidget and makes the app’s remaining interface, _WeatherAppView_, a dependency of that InheritedWidget — a means to ‘rebuild’ that Widget again and again when necessary. See the first screenshot below.

In the second screenshot below, the _StateX_ version utilizes the class, InheritedWidget, as well. However, the widget, _WeatherAppView_, is replaced by the State object, __WeatherAppState,_ that defines the overall ‘look and behavior’ of the app.

This may be an unfair comparison at this point, as the [Fluttery Framework](https://pub.dev/packages/fluttery_framework) is designed to produce ‘production-ready’ apps while the BLoC version is merely a very simple example app. Therefore, I’ll limit this article to comparing the ‘differences’ made to conceive the same interface and behavior. For more information on the Fluttery Framework, see the [‘Little More’ Series](https://andrious.medium.com/the-little-more-series-94b0a9c6cd25).

Zoom image will be displayed

[app.dart](https://github.com/felangel/bloc/blob/f951eef84e4e740697b712ff3e1cf244eea3a1e6/examples/flutter_weather/lib/app.dart#L8) [weather_app.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/app/view/weather_app.dart#L11)
![[Pasted image 20250806142729.png]] ![[Pasted image 20250806142738.png]]


# Control is Everything

Back to the BLoC version, as a dependency, the _WeatherAppView_ widget will be rebuilt again if and when the value, _toColor_, has changed. You can see that highlighted in the first screenshot below. Again, the logic is exposed in the interface.

The next two screenshots below are from the Fluttery version of the app but are not the corresponding interface. Instead, it’s of the controller, _WeatherController_. That’s because that specific logic is found in the Controller and not in the interface. Again, it is the Controller that determines what widget is rebuilt and why.

[app.dart](https://github.com/felangel/bloc/blob/f951eef84e4e740697b712ff3e1cf244eea3a1e6/examples/flutter_weather/lib/app.dart#L22) and [weather_controller.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/main/controller/weather_controller.dart#L115) and [weather_controller.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/main/controller/weather_controller.dart#L136)

In the BLoC version, the class, _WeatherCubit_, is the equivalent to the class, _WeatherController,_ in the Fluttery version. Both fetch new Weather information, and both deal directly with the data source involved.
[weather_cubit.dart](https://github.com/felangel/bloc/blob/f951eef84e4e740697b712ff3e1cf244eea3a1e6/examples/flutter_weather/lib/weather/cubit/weather_cubit.dart#L11) and [weather_conroller.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/main/controller/weather_controller.dart#L12)

# A Single Simple Solution

Note, how the Controller uses a factory constructor to make only one instance of this class. This implements the Singleton design pattern and is, more often than not, very suitable for the role of a State Object Controller: It retains ‘a running account’ of the app’s state, its logic, and the current data involved. Further, it makes that one instance readily available throughout your app if you like using very little boilerplate code. Much of what makes up the Provider Model, is instead achieved by a factory constructor. Keep it simple. Keep it Flutter.

`context.read<Weatheruit>.refreshWeather(); vs WeatherController().refreshWeather();`

Going back to the example app comparisons. You can see in the first screenshot below, the BLoC version relies on the Widget tree to retrieve the one instance of _WeatherCubit_. This is so as to call its functions, **refreshWater**() and **fetchWeather**(). The State object in the second screenshot below merely uses the local variable, _con_. It originally came about from the constructor call, **WeatherController**().

`extension ReadContext on BuilldContext {   T read<T>() { return Provider.of<T>(this, listen: false); }   }`

[weather_page.dart](https://github.com/felangel/bloc/blob/f951eef84e4e740697b712ff3e1cf244eea3a1e6/examples/flutter_weather/lib/weather/view/weather_page.dart#L30) and [weather_page.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/main/view/weather_page.dart#L53)

The same approach is used in the Settings page respectively
[settings_page.dart](https://github.com/felangel/bloc/blob/f951eef84e4e740697b712ff3e1cf244eea3a1e6/examples/flutter_weather/lib/settings/view/settings_page.dart#L15) and [settings_page.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/main/view/settings/settings_page.dart#L24)

# In The Beginning

Note how the WeatherCubit class is defined nowhere near where it is first required. This practice is a throwback to when the Provider design pattern was first introduced with ASP.Net 2.0. Generally, everything was defined at the start of the app.

In the BLoC example app, the _BlocProvider_ will only create an instance of the WeatherCubit class when it’s first required. When instantiated, it’s then stored in an internal variable, __value_ (second screenshot below). In the first screenshot below, the WeatherCubit class is defined at the start of the app. It is only stored in the variable, __value_, (making for a pseudo-Singleton approach) when required to determine the app’s background color (third screenshot below).

[app.dart](https://github.com/felangel/bloc/blob/f951eef84e4e740697b712ff3e1cf244eea3a1e6/examples/flutter_weather/lib/app.dart#L8) and [inherited_provider.dart](https://github.com/rrousselGit/provider/blob/a689f406d2e937993de4ad9fa3028f126fab695e/packages/provider/lib/src/inherited_provider.dart#L690) and [app.dart](https://github.com/felangel/bloc/blob/f951eef84e4e740697b712ff3e1cf244eea3a1e6/examples/flutter_weather/lib/app.dart#L22)

In the Controller version, a WeatherController instance is only created when it’s first required as well. With its factory constructor, it is that instance that is then used throughout the app. Done.

At the start of this Controller version, the _inTheme_ clause is used to supply the color scheme — one of many options available to you when using Fluttery (see [Little More Adaptive](https://andrious.medium.com/little-more-adaptive-8ef102ea1375)). In the second screenshot below, of course, it’s the same instance used to fetch the weather info

[weather_app.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/app/view/weather_app.dart#L11) and [weather_page.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/main/view/weather_page.dart#L13)

# The Hive Mind

By default, the BLoC version uses a popular lightweight NoSQL database called [Hive](https://pub.dev/packages/hive). As such, working through the class, _WeatherCubit_, the Weather object’s data is saved to this database assumingly to demonstrate that capability. Thus, I noted when restarting the app, it wouldn’t fetch that city’s current weather info., but simply retrieve the past data stored in the Hive database. It makes for out-of-date weather reading, but demonstrates that capability. Therefore, in the video below, the weather is only updated with another explicit fetch of the data.
[main.dart](https://github.com/felangel/bloc/blob/f951eef84e4e740697b712ff3e1cf244eea3a1e6/examples/flutter_weather/lib/main.dart) and [hydrated_bloc.dart](https://github.com/felangel/bloc/blob/e2407caf46dd217535816889ea0e6791fdc4ab3c/packages/hydrated_bloc/lib/src/hydrated_bloc.dart#L114)
Zoom image will be displayed![](https://miro.medium.com/v2/resize:fit:1480/1*-tApvzqUL3WU_61vbBH0fQ.gif)
Fluttey doesn’t offer a database. Like Flutter, that’s left to the developer. As for the example app, I chose only to save the city name using the device’s own stored-preferences infrastructure. The next time the app started up, that city name would be looked up again with the usual API call.

In the first screenshot above, Felix chose to initialize the database at the beginning of the app. Again, a common practice in the past. The Fluttery version is more State-centric. The data source is only required in the State object, __WeatherPageState_, where data is retrieved (first screenshot below). Of course, in the second screenshot below, it is its Controller that takes care of all this. Because the Controller was passed into that State object (see line below), its **initAsync**() function is called and performs the fetch. A spinner is displayed on the screen until that weather info is fetched from the Web service (see video below).

`_WeatherPageState() : super(controller: WeatherController()) {`

[part01_statex.dart](https://github.com/AndriousSolutions/state_extended/blob/46d143e5feb071bb68820e2eb8e28c79f384278c/lib/part01_statex.dart#L193) and [weather_controller.dart](https://github.com/Andrious/flutter_weather/blob/29b0e2b7649ca000e09e1807026867d0697b260c/lib/main/controller/weather_controller.dart#L38)

Again, I chose only to save the city name using the [_Prefs_](https://pub.dev/packages/prefs) package. It works with the plugin, [_shared_preferences_](https://pub.dev/packages/shared_preferences). which, depending on the platform, wraps the NSUserDefaults (in iOS) and the SharedPreferences (in Android), to provide persistent storage.

Let’s leave it there. Again, I found if I kept it simple and kept it Futter, my apps proved to my very adaptive and easy to maintain with a clean architecture and scalable code.

By the way, if this app supplied real-time forecasts, I’d then use a Stream.

Cheers.
