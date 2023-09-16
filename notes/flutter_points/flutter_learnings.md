The boring show - ep-4
---------------
> we should use Behaviour subject in bloc pattern because it send output as soon as an entry, where as other opproach waits till there is any change

> safe area
> navigator.push
> switch class
> shared preferences
> flutter inspector
> modal / bottom sheets
> Testing flutter apps
> in app paymentss
> state managements using providers

[link :https://medium.com/flutter-community/flutter-effectively-scale-ui-according-to-different-screen-sizes-2cb7c115ea0a]

> [link : https://medium.com/@jelenaaa.lecic/complex-layout-in-flutter-example-8c50e81d5aa9]
> linkg : https://medium.com/flutter-community/flutter-login-tutorial-with-flutter-bloc-ea606ef701ad

> copy with method (we have to google and read)

> [link : https://medium.com/better-programming/simple-firebase-login-flow-in-flutter-6f44c2b5c58a?source=email-38f618178336-1584483767666-digest.reader------0-59------------------c13eaf01_7679_4a6e_a357_96fa403fd763-1-97e5cd15_35b1_4815_89ad_4d74812e5383----]


> [link : https://medium.com/flutter-community/5-tips-to-know-before-you-start-developing-your-app-with-flutter-50771507dae0] [must read]

> [link : https://medium.com/coding-with-flutter/flutter-the-power-of-small-and-reusable-widgets-7649e3b0bca2]


The boring show -  refactoring and dart advanced features:
----------------------------------------------------------

> we can use const for Edgeinsets
> valid syntax : int get number => 42;
> factory constructors

cascade operation:
------------------
> result.add('a')
> result.add('b')
> result.add('c')
>> result.add('a')..add('b')..add('c')
---------------
> unmodifiablelistview

> animation controller
> WillPopScope class
link:  [https://medium.com/@iamatul_k/flutter-handle-back-button-in-a-flutter-application-override-back-arrow-button-in-app-bar-d17e0a3d41f]

> classpath "com.google.gms:google-services:4.2.0"





>>> udemy tutorial
> navigator.pop (to close the bottom sheet)
> text field we can set input key board type like to only display numbers in key board
>
important resources:
--------------------
Flutter Performance Related articles:
-------------------------------------


[source:https://medium.com/flutter/building-performant-flutter-widgets-3b2558aa08fa ]

[source : https://medium.com/flutter-community/flutter-laggy-animations-how-not-to-setstate-f2dd9873b8fc]

[source: https://medium.com/flutter/improving-perceived-performance-with-image-placeholders-precaching-and-disabled-navigation-6b3601087a2b]

Youtube links:
-------------

[source : https://www.youtube.com/watch?v=YfQkOfm1OC0&list=PLKlZdGMAYp6_cpXFIhv3nLTZeFClrORoY&index=2]

[Source : https://www.youtube.com/watch?v=PJ_AH61dTIc]


>> Calling setState schedules a build() method to be called. Doing this too often can slow down the performance of a screen.


[source : https://medium.com/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2]


> Constraints go down. Sizes go up. Positions are set by parents.

[source : https://twitter.com/biz84/status/1295783344827965441?s=20]

Private named constructor:
class singleton{
singleton._();
static final instance = Singleton._();
}

[source : https://stackoverflow.com/questions/42718973/run-avd-emulator-without-android-studio]

On MacOS:
---------
First list down the installed emulators

~/Library/Android/sdk/tools/emulator -list-avds

then run an emulator

~/Library/Android/sdk/tools/emulator -avd Nexus_5X_API_27

iphone simulator :
>>  open -a simulator
or 
>> open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app

[source : https://medium.com/@jelenaaa.lecic/when-to-use-async-await-then-and-future-in-dart-5e00e64ab9b1]
Dart Async programming:
----------------------

## look at flutter in focus on async programming videos(explanation is good)

> Async means that this function is asynchronous and you might need to wait a bit to get its result.
> Await literally means - wait here until this function is finished and you will get its return value.
> Future is a type that ‘comes from the future’ and returns value from your asynchronous function. It can complete with success(.then) or with
an error(.catchError).
> .Then((value){…}) is a callback that’s called when future completes successfully(with a value).
>>>
void main() async {
  print(getMeSomeFood());   
  print(await getMeSomethingBetter());  
  print(getMeSomethingBetter().runtimeType);  
  maybeSomethingSweet().then((String value) {
    print(value);                    
  });
}Future<String> getMeSomeFood() async {
  return "an apple";
}Future<String> getMeSomethingBetter() async {
  return "a burger?";
}Future<String> maybeSomethingSweet() async {
  return "a chocolate cake!!";
}Future<String> bye() async{          //will not compile, add async
  return "see you soon! :)";
}
//output:
Instance of '_Future<String>'
a burger?
_Future<String>
a chocolate cake!!

> As you could see, there’s no difference between .then and await when it comes to fetching results. But be careful, when you use await, your program will wait there until async function finishes:

>>> void main() async {
  await waitForMe();
  print('I was waiting here :)');
}Future waitForMe() async {
  print('Started.');
  return Future.delayed(Duration(seconds: 5), () {
    print("Now I'm done!");
  });
}
//output : Started.
Now I’m done!
I was waiting here :)
 
> And this is an example where we do not want to wait:
>>> void main() async {
  waitForMe().then((_) {
    print("I'm more done THEN you :)");
  });
  print('I was waiting here :)');
}Future waitForMe() async {
  print('Started.');
  return Future.delayed(Duration(seconds: 3), () {
    print("Now I'm done!");
  });
}
//output:
Started.
I was waiting here :)
Now I’m done!
I’m more done THEN you :)

Build context:
-------------
[source : https://engineering.liefery.com/2019/02/18/flutter-for-newbies-why-you-should-care-about-the-build-context.html, https://medium.com/flutter-community/widget-state-buildcontext-inheritedwidget-898d671b7956]

> Every widget in Flutter is created from a build method, and every build method takes a BuildContext as an argument.
> This build context describes where you are in the tree of widgets of your application

> If a widget ‘A’ has children widgets, the BuildContext of widget ‘A’ will become the parent BuildContext of the direct children BuildContexts.

BuildContext visibility (Simplified statement):
‘Something’ is only visible within its own BuildContext or in the BuildContext of its parent(s) BuildContext. From this statement we can derive that from a child BuildContext, it is easily possible to find an ancestor (= parent) Widget.

> An example is, considering the Scaffold > Center > Column > Text:
context.ancestorWidgetOfExactType(Scaffold) => returns the first Scaffold by going up to tree structure from the Text context.
> From a parent BuildContext, it is also possible to find a descendant (= child) Widget but it is not advised to do so

###### [source : https://medium.com/flutter-community/understanding-buildcontext-6df0d540bad3]
note: pls run the below examples in dart pad to see the difference

eg1: >>>
/////////////
import 'package:flutter/material.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        home:MyWidget()
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
   Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          child: Text(
            "SnackBar",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.red,
          onPressed: () {
             print("pressed!!!");
            Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Oh! You clicked me!"),
            ),
          );},
        ),
      ),
    );
  }
}
////////////////////
> But if we click on the button, no SnackBar is displayed, and we get the following error: flutter: Scaffold.of() called with a context that does not contain a Scaffold.

>we may be inclined to access the showSnackbarmethod, which resides in the ScaffoldState, with a GlobalKey:
//// need not try thin in dartpad
>>> class MyHomePage extends StatelessWidget {
	// The GlobalKey will allow us to access the Scaffold's State
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
		// We add the key to the Scaffold so we can access it later
      key: _key,
      body: Center(
          child: MaterialButton(
            child: Text(
              "SnackBar",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
			   // We now can access the currentState via the GlobalKey
            onPressed: () => _key.currentState.showSnackBar(
              SnackBar(
                content: Text("Oh! You clicked me!"),
              ),
            ),
          ),
        ),
    );
  }
}
//////////////////
> Though this works, the GlobalKey documentation page states that: "Global keys are relatively expensive", so we should avoid using them when we can find another solution.

> The Tale of Two BuildContexts
Let’s examine the error message:
> No Scaffold ancestor could be found starting from the context that was passed to Scaffold.of(). This usually happens when the context provided is from the same StatefulWidget as that whose build function actually creates the Scaffold widget being sought

> This is because both button widget and scafold are in same build method (same buildcontext)


				     _______Scaffold
				    |
				    |
build(BuildContext context)----------
				    |
				    |_______ Material Button

> Looking inside the Scaffold.of(context) method, we see that it will call a method named findAncestorStateOfType , and if this method returns null , then the error message is printed in the console

> The findAncestorStateOfType method describes in its name what its purpose is - to find a Widget that is above in the Widget tree whose State's matches the ScaffoldState. How does this work? If we look into the framework.dart file, we verify that BuildContext is an abstract class that is implemented by the Element class.
>> abstract class Element extends DiagnosticableTree implements BuildContext 

> To put it simply, the Element class’ purpose is to instantiate new Widget s. In order to track its position in the Widget tree, it will have a reference to its ancestor and, since all Element objects have a parent, we can now traverse up the Element tree and verify if we can find a State that matches the one we are looking for

>Looking at the previous image, we can clearly see now that the Scaffold then when the findAncestorStateOfType method is called, the ScaffoldState will not be found since the BuildContext we are using is of mywidget() (class MyWidget extends StatelessWidget ) does not have a Scaffold as an ancestor (ancestor is MeterialApp)

> we can solve this by wrapping the material buttorn with scaffold.

eg2 : >>> run it in dartpad
///////////////////////
import 'package:flutter/material.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        home:MyWidget()
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
   Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomButton(),
      ),
    );
  }
}

/// We separate the UI by creating a new StatelessWidget
class CustomButton extends StatelessWidget {
	
	/// This build method will create a new `BuildContext` that will have as an ancestor the `Scaffold`
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        "SnackBar",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.red,
		// We can now safely find the ancestor `Scaffold` via the `BuildContext`
      onPressed: () => Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Oh! You clicked me!"),
        ),
      ),
    );
  }
}
////////////////////////////////
> above widget tree can be transformed to : 
Screen context -> scaffold-> custom Button-> custombotton context -> button

> When the Buttoncalls tries to find an ancestor with the CustomButton's BuildContext, it will find the Scaffold as a direct ancestor, so the findAncestorStateOfType find a ScaffoldStatewhich we can access to call the showSnackBar method.

> But what if we want to keep it all in the same StatelessWidget? That's where the Builder Widget comes in. It provides us with a WidgetBuilder callback with a new BuildContext

>>>
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
		// The `Builder` widget will provide a `builder` method with its own `BuildContext` so that we can access any ancestor above it with this new context
      body: Builder(
              builder: (secondContext) => Center(
          child: MaterialButton(
            child: Text(
              "SnackBar",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
			  // Using the `Builder` `BuildContext`, named `secondContext` we can reach the `Scaffold` ancestor.
            onPressed: () => Scaffold.of(secondContext).showSnackBar(
              SnackBar(
                content: Text("Oh! You clicked me!"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

> This will create exactly the same Widget- BuildContext graph that we have seen previously, with the main difference that now we have all Widgets in the same class.

screen context -> scaffold -> Builder -> Builder context -> Button


Why should we take care of our BuildContext:
-------------------------------------------
> We now know that the BuildContext can be used to locate our widget and other widgets in the tree. But the question is - why should we care?

In the below example we created an initial screen in which a Scaffold accepts a StatelessWidget as a body. As with the previous section, we will want to show a SnackbBar with some text.
We also decide to abstract the onPressed method, but since we don’t have access to the BuildContext in a StatelessWidget, we cache it
>>> eg3: // try it in dart pad
//////////////
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        home:MyHomePage()
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() =>
      _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	/// The child Widget
  Widget _child;
  @override
  void initState() {
    super.initState();
    _child = PageBody();
  }
  @override
  Widget build(BuildContext context) {
      return _getMaterialScaffold(_child);
  }

  Widget _getMaterialScaffold(Widget child) => Scaffold(
        appBar: AppBar(
          title: Text("This is a material widget"),
        ),
        body: child,
      );

}

class PageBody extends StatelessWidget {
	/// The cached instance of the BuildContext
  BuildContext _context;

	/// Shows a snackbar with the cached BuildContext
  void showSnackbar() {
    Scaffold.of(_context).showSnackBar(
      SnackBar(
        content: Text(
          "Yay!",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Called build");
    // Caching the context when this Widget is first built
    if (_context == null) {
      _context = context;
    }

    return Center(
      child: RaisedButton(
            color: Colors.red,
            child: Text(
              "Show Snackbar",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => showSnackbar()),
    );
  }
}
////////////////////

> Though this works as intended, we may ask: What happens if the Widget tree changes and it no longer has a Scaffold Ancestor?
> examples given below is to show the importance of buildcontext with when scafold is not present 

> Let’s look at the following example: we have two buttons in the screen:
	The first one shows a SnackBar
	The second one changes the page root Widget from a Scaffold to a CupertinoPageScaffold

//////////// eg 4: /// try it in dart pad
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        home:MyHomePage()
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() =>
      _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	/// The child Widget
  Widget _child;

  bool _isMaterial = true;

  @override
  void initState() {
    super.initState();
    _child = PageBody();
  }

  @override
  Widget build(BuildContext context) {
    /// We check if the `isMaterial` flag is true to either return a `Scaffold` or a `CupertinoPageScaffold` as the root Widget
    if (_isMaterial) {
      return _getMaterialScaffold(_child);
    }
    return _getCupertinoScaffold(_child);
  }

  Widget _getMaterialScaffold(Widget child) => Scaffold(
        appBar: AppBar(
          title: Text("This is a material widget"),
        ),
        body: child,
      );

  Widget _getCupertinoScaffold(Widget child) => CupertinoPageScaffold(
        child: child,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.red,
          middle: Column(
            children: <Widget>[
              Icon(Icons.warning),
              Text(
                "Changed Theme to cupertino!",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      );

	/// Public method to change the current root widget
  void changeType() {
    setState(() => _isMaterial = !_isMaterial);
  }
}

class PageBody extends StatelessWidget {
  BuildContext _context;

  void showSnackbar() {
    Scaffold.of(_context).showSnackBar(
      SnackBar(
        content: Text(
          "Yay!",
        ),
      ),
    );
  }

  void changePageType() {
    _context
        .findAncestorStateOfType<_MyHomePageState>()
        .changeType();
  }

  @override
  Widget build(BuildContext context) {
    print("Called build");
    // Caching the context
    if (_context == null) {
      _context = context;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
            color: Colors.red,
            child: Text(
              "Show Snackbar",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => showSnackbar()),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
            color: Colors.blue,
            child: Text(
              "Change Style",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => changePageType()),
      ],
    );
  }
}
//////////////////////////
> This Widget exposes the changeType method that will force a rebuild with the different root Widget .
> The PageBody will contain two buttons and the methods to access both the Scaffold, to show a SnackBar, and MyHomePageso that we can access the public method changeType. As with before, since it's a StatelessWidget, we opt to cache the BuildContext
> We can click on the “Show Snackbar” button once, and it shows the SnackBar correctly. However, when we click the Change Style button, the root widget of MyHomePagewill be changed to a CupertinoPageScaffoldthat cannot be accessed via the Scaffold.of(_context) method.
> As predicted, when clicking again in the Show Snackbar button again, the error that we have encountered before.What’s more interesting is that if we click again in the Change Type button, it will not work and in turn it throws different error. (flutter: calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method.)

> differnt error is because the cached BuildContext is now referencing a deactivated widget.
Looking at the findAncestorStateOfType method again, we verify that the in the first line there is a call to:
>> assert(_debugCheckStateIsActiveForAncestorLookup());
This will in turn verify if the Element is in active state or not

> while the parent was rebuilding, the Element related to the cached BuildContext was marked as not active, and we will no longer be able to look up ancestors in the tree. To learn more about how Flutter builds its UI elements, specifically Widgets, Elements and Render Objects

> how can we solve it? And, as we may guess, the solution is to always use the BuildContext provided by the build method
//// eg 5: //// try in dartpad

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        home:MyHomePage()
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() =>
      _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	/// The child Widget
  Widget _child;

  bool _isMaterial = true;

  @override
  void initState() {
    super.initState();
    _child = PageBody();
  }

  @override
  Widget build(BuildContext context) {
    /// We check if the `isMaterial` flag is true to either return a ` fold` or a `CupertinoPageScaffold` as the root Widget
    if (_isMaterial) {
      return _getMaterialScaffold(_child);
    }
    return _getCupertinoScaffold(_child);
  }

  Widget _getMaterialScaffold(Widget child) => Scaffold(
        appBar: AppBar(
          title: Text("This is a material widget"),
        ),
        body: child,
      );

  Widget _getCupertinoScaffold(Widget child) => CupertinoPageScaffold(
        child: child,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.red,
          middle: Column(
            children: <Widget>[
              Icon(Icons.warning),
              Text(
                "Changed Theme to cupertino!",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      );

	/// Public method to change the current root widget
  void changeType() {
    setState(() => _isMaterial = !_isMaterial);
  }
}

class PageBody extends StatelessWidget {
  BuildContext _context;

  void showSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Yay!",
        ),
      ),
    );
  }

  void changePageType(BuildContext context) {
    context
        .findAncestorStateOfType<_MyHomePageState>()
        .changeType();
  }

  @override
  Widget build(BuildContext context) {
    print("Called build");
    // Caching the context
    if (_context == null) {
      _context = context;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
            color: Colors.red,
            child: Text(
              "Show Snackbar",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => showSnackbar(context)),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
            color: Colors.blue,
            child: Text(
              "Change Style",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => changePageType(context)),
      ],
    );
  }
}
///////////////////////////////
[source : https://stackoverflow.com/questions/51983011/when-should-i-use-a-futurebuilder]

Future builder:
--------------

> FutureBuilder removes some of the boilerplate codes.

> Lets say you want to fetch data from backend on launch of page and show loader till data comes.

Tasks for ListBuilder:

a) have two state variables 
	1.dataFromBackend 
	2.isLoadingFlag
b) On launch, set isLoadingFlag = true and based on which show loader.
c) Once data arrival, set data with what you get from backend and set isLoadingFlag = false (inside setState obviously)
d) We need to have a if-else in widget creation. If isLoadingFlag is true, show loader else show the data. If failure, show error message.
Tasks for FutureBuilder:

a) give the async task in future of Future Builder
b) based on connectionState, show message (loading, active(streams), done)
c)based on data(snapshot.hasError) show view
Pros of FutureBuilder

a) no two flags and no setState
b) reactive programming (FutureBuilder will take care of updating the view on data arrival)
Example:
>>>
    FutureBuilder<String>(
        future: _fetchNetworkCall, // async work
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
           switch (snapshot.connectionState) {
             case ConnectionState.waiting: return Text('Loading....');
             default:
               if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
               else
              return Text('Result: ${snapshot.data}');
            }
         },
        )
Performance impact:

looking into the FutureBuilder code to understand the performance impact of using this.

> FutureBuilder is just a StatefulWidget whose state variable is _snapshot
> Intial state is _snapshot = AsyncSnapshot<T>.withData(ConnectionState.none, widget.initialData);
> It is subscribing to future which we send in constructor and updating the state based on that.
>>> // _subscribe(){  
widget.future.then<void>((T data) {
      if (_activeCallbackIdentity == callbackIdentity) {
    setState(() {
      _snapshot = AsyncSnapshot<T>.withData(ConnectionState.done, data);
     });
   }
  }, onError: (Object error) {
  if (_activeCallbackIdentity == callbackIdentity) {
    setState(() {
      _snapshot = AsyncSnapshot<T>.withError(ConnectionState.done, error);
    });
   }
  });

> So the FutureBuilder is a wrapper/boilerplate of what we do typically. So there should not be any performance impact.


[source : https://www.filledstacks.com/snippet/dependency-injection-in-flutter/]
Get_it : dependency injection:
-----------------------------


> In Flutter, the default way to provide object/services to widgets is through InheritedWidgets. If you want a widget or it's model to have access to a service, the widget has to be a child of the inherited widget. This causes unneccessary nesting.
That's where get it comes in. An IoC that allows you to register your class types and request it from anywhere you have access to the container. Sounds better? Let's set it up.
Implementation

In your pubspec add the dependency for get_it.
  ...

  # dependency injection
  get_it: ^1.0.3

  ...
In your lib folder create a new file called service_locator.dart. Import get_it and create a new instance of getIt called locator. We'll use everything in the global scope so we can just import the file and have access to the locator.
Create a new function called setupLocator where we will register our services and models.
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
}
In the main.dart file call setupLocator before we run the app.
import 'service_locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}
Setup:

In the lib folder create a new folder called services. Under that folder create two new files, login_service.dart and user_service.dart
Login Service
class LoginService {
    String loginToken = "my_login_token";
}
User Service:
class UserService {
    String userName = "filledstacks";
}
Using get_it, class types can be registered in two ways.
Factory: When you request an instance of the type from the service provider you'll get a new instance everytime. Good for registering ViewModels that need to run the same logic on start or that has to be new when the view is opened.
Singleton: Singletons can be registered in two ways. Provide an implementation upon registration or provide a lamda that will be invoked the first time your instance is requested (LazySingleton). The Locator keeps a single instance of your registered type and will always return you that instance.
Registering types:

Go to your service locator and import the two new services. We'll register the UserService as a singleton, and the LoginService as a Factory.
import './services/user_service.dart';
import './services/login_service.dart';

...

void setupLocator() {
  locator.registerSingleton(UserService());
  locator.registerFactory<LoginService>(() => LoginService());
}
Now wherever you need the service you'll import the service_locator.dart file and request the type like below.
import 'package:my_project/service_locator.dart';

...

var userService = locator<UserService>();

...
You don't need to wrap any widgets to inherit anything, or need the context anywhere. All you do is import the service_locator file and use the locator to resolve your type. This means that in places without the context you'll still be able to inject the correct services and values, even if the app's UI structure changes.



[source : https://medium.com/flutter-community/flutter-statemanagement-with-provider-ee251bbc5ac1]

Providers:
---------
Provider exposes a few kinds of provider for different types of objects 

provider: the most basic form of provider.it takes a value and expose it, whatever the value is.

ListenableProvider: Aprovider specific for listenable object.Lisenable will listen the object and ask widgets which depends on it to rebuild whenever the listener is called.

ChangeNotifireProvider: A specification of listenable Provider for changenotifier.Itwill automatically call change notifier.dispose when needed.

ValueListenableProvider: listen to a valueListenable and only expose ValueListenable.value.

StreamProvider: Listen to stream and expose the latest value emitted
[source : https://medium.com/flutterdevs/flutter-performance-optimization-17c99bb31553]

When to use isolates/threads ?
> There are a few situations where isolates can be very handy.
	1)Let say you want to execute a network call and you want to process that data that you just received . and that data contains about million records that alone will hang your UI.
	2)You have some image processing tasks that you want to do on-device these kinds of tasks are highly computational as they have to deal with lots of number crunching operations which may lead to frozen UI or legginess in UI.

> Languages like JAVA and C++ Share Their heap memory with threads, but in case of flutter, every isolate has its own memory and works independently. As it has its own private space this memory doesn’t require locking, as if a thread finishes its task it already means that the thread has finished utilizing its memory space and then that memory can go for garbage collection.

> To maintain these benefits flutter has a separate memory for every isolate(Flutter way of multi-threading) that’s why they are called isolate 

> Using compute we can do the same task which isolates does but in a more cleaner and abstract way. Let’s take a look at the flutter compute function.
Syntax:
>> var getData = await compute(function,parameter);

Compute function takes two parameters :
1) A future or a function but that must be static (as in dart threads does not share memory so they are class level members not object level).
2) Argument to pass into the function, To send multiple arguments you can pass it as a map(as it only supports single argument).compute function returns a Future which if you want can store into a variable and can provide it into a future builder.

>>> import 'dart:io';

import 'package:flutter/material.dart';

class With10SecondDelay extends StatelessWidget {
  runningFunction() {
    int sum = 0;
    for (int i = 1; i <= 10; i++) {
      sleep(Duration(seconds: 1));
      print(i);
      sum += i;
    }
    return "total sum is $sum";
  }

  pauseFunction() {
    //pause function is not async
    print(runningFunction());
  }

  @override
  Widget build(BuildContext context) {
    pauseFunction();
    return Material(
      child: Center(
        child: Center(
          child: Text(
            "Tnx for waiting 10 seconds : check console for response",
            style: TextStyle(
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}

> In the above code pausefunction() is called just below the build method which pauses the execution of code for 10 seconds. And because of that when you try to navigate to this page from a previous one there will be a delay of ten seconds before our page gets pushed on to the widget tree.
We can try to resolve this issue by using async.
>>  pauseFunction() async {
    //pause function is async
    print(runningFunction());
  }

> As you can see now we have declared our pause function as async even doing this will not help
As async in dart is basically puts our code in ideal until there is something to compute so it seems to us that dart is executing these on a different thread but actually it’s just waiting for some event to occur in that async function.

> Let’s solve the above issue using compute: 

>> import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ComputeWith10SecondDelay extends StatelessWidget {
  static Future<String> runningFunction(String str) async {
    int sum = 0;
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(Duration(seconds: 1));
      print(i);
      sum += i;
    }
    return "Sum is : " + sum.toString() + str;
  }

  pauseFunction() async {
    print(await compute(runningFunction,
        " This is an argument")); //storing data of copute result
  }

  @override
  Widget build(BuildContext context) {
    pauseFunction();

    return Material(
      child: Center(
        child: Center(
          child: Text(
            "Wow , it saved my 10 seconds : check console for response",
            style: TextStyle(
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}

> In the above code, we basically passed our function in compute() function and that creates a separate isolate to handle the task and our main UI will still run without any delay (check the debug console for response ).
Summary:
> Dart is by default executes all its code on a single-threaded.
> Every function and every async-await calls work only on the main thread(until and unless specified).
> We can create multiple threads using compute( Future function/normal function, argument).
> You can use compute for executing network calls, performing number-crunching calculations, image processing, etc.

[source : https://stackoverflow.com/questions/57335980/changenotifierprovider-vs-changenotifierprovider-value#:~:text=Use%20ValueNotifier%20if%20you%20need,when%20notifyListeners()%20is%20called.&text=So%20Flatter%20recycles%20the%20same,Provider%20with%20the%20create%20function.]


Let's take this in steps.

What is ChangeNotifier?
A class that extends ChangeNotifier can call notifyListeners() any time data in that class has been updated and you want to let a listener know about that update. This is often done in a view model to notify the UI to rebuild the layout based on the new data.

Here is an example:

class MyChangeNotifier extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}
I wrote more about this in A beginner’s guide to architecting a Flutter app.

What is ChangeNotifierProvider?
ChangeNotifierProvider is one of many types of providers in the Provider package. If you already have a ChangeNotifier class (like the one above), then you can use ChangeNotifierProvider to provide it to the place you need it in the UI layout.

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyChangeNotifier>(        // define it
      create: (context) => MyChangeNotifier(),              // create it
      child: MaterialApp(
        ...

          child: Consumer<MyChangeNotifier>(                // get it
            builder: (context, myChangeNotifier, child) {
              ...
                  myChangeNotifier.increment();             // use it
Note in particular that a new instance of the MyChangeNotifier class was created in this line:

create: (context) => MyChangeNotifier(),
This is done one time when the widget is first built, and not on subsequent rebuilds.

What is ChangeNotifierProvider.value for then?
Use ChangeNotifierProvider.value if you have already created an instance of the ChangeNotifier class. This type of situation might be happen if you had initialized your ChangeNotifier class in the initState() method of your StatefulWidget's State class.

In that case, you wouldn't want to create a whole new instance of your ChangeNotifier because you would be wasting any initialization work that you had already done. Using the ChangeNotifierProvider.value constructor allows you to provide your pre-created ChangeNotifier value.

class _MyWidgeState extends State<MyWidge> {

  MyChangeNotifier myChangeNotifier;

  @override
  void initState() {
    myChangeNotifier = MyChangeNotifier();
    myChangeNotifier.doSomeInitializationWork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyChangeNotifier>.value(
      value: myChangeNotifier,                           // <-- important part
      child: ... 
Take special note that there isn't a create parameter here, but a value parameter. That's where you pass in your ChangeNotifier class instance. Again, don't try to create a new instance there.

[source : https://stackoverflow.com/questions/53294006/how-to-create-a-custom-appbar-widget]

Custorm app bar- solutions form stactoverflow:


solution1: 
>>
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
    CustomAppBar({Key key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

    @override
    final Size preferredSize; // default is 56.0

    @override
    _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>{

    @override
    Widget build(BuildContext context) {
        return AppBar( title: Text("Sample App Bar") );
    }
}

Solution2:
>>>

class AppBars extends AppBar {
  AppBars():super(
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
    backgroundColor: Colors.white,
    title: Text(
      "this is app bar",
      style: TextStyle(color: Color(Constant.colorBlack)),
    ),
    elevation: 0.0,
    automaticallyImplyLeading: false,
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () => null,
      ),
      IconButton(
        icon: Icon(Icons.person),
        onPressed: () => null,
      ),
    ],
  );
} 

[source : https://stackoverflow.com/questions/49356664/how-to-override-the-back-button-in-flutter]

Show alert dialog when back button is pressed:
>>>
import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) :super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Home Page"),
        ),
        body: new Center(
          child: new Text("Home Page"),
        ),
      ),
    );
  }
}

[source: https://stackoverflow.com/questions/52088889/can-someone-explain-to-me-what-the-builder-class-does-in-flutter#:~:text=According%20to%20the%20official%20flutter,possible%20thing%20of%20that%20kind.]

> The purpose of the Builder class is simply to build and return child widgets. How is that different from any other widget? Aha! The Builder class allows you to pass a specific context object down to its children. The Builder class is basically your own build function that you setup.

Why would I need to pass a specific context object? Lets take a look at an example:

Lets say that we want to add a new SnackBar widget to its new Scaffold parent widget that is being returned:

>>> 
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Builder(
      builder: (BuildContext context) {
        return FloatingActionButton(onPressed: () {
          Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text('SnackBar'),
                ),
              );
      },
    ),
  );
}

colon after the constructor:
--------------------------

> The part after : is called "initializer list. It is a ,-separated list of expressions that can access constructor parameters and can assign to instance fields, even final instance fields. This is handy to initialize final fields with calculated values.

The initializer list is also used to call other constructors like : ..., super('foo').

Since about Dart version 1.24 the initializer list also supports assert(...) which is handy to check parameter values.

The initializer list can't read from this because the super constructors need to be completed before access to this is valid, but it can assign to this.xxx.

This also means the initializer list is executed before the constructor body. Also the initializer lists of all superclasses are executed before any of the contructor bodies are executed.

notification listner and scroll controller:
-----------------------------------------
[source: https://stackoverflow.com/questions/48035594/flutter-notificationlistener-with-scrollnotification-vs-scrollcontroller]

> If you're using NestedScrollView with nested scrollers, using a scrollController on the inner scrollers will break the link with NestedScrollView meaning NestedScrollView will no longer control the complete scrolling experience. To get information about the scroll positions of the inner scrollers in this case you would use a NotificationListener with ScrollNotification.
> To use a ScrollController you should use a Stateful widget, so that it can be properly dispose.
> NotificationListener is just another widget, so yo don't need to create a Stateful widget.
> You cannot change the scroll position from a NotificationListener. It is read only.
> If you want to change the scroll position, you are going to need a ScrollController (jumpTo / animateTo).

>>> notification listner example:

NotificationListener<ScrollNotification>(
  child: ListView.builder(
    itemCount: 10
    itemBuilder: (BuildContext context, int index) {
      return Text('Item $index');
    },
  ),
  onNotification: (ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels ==
        scrollInfo.metrics.maxScrollExtent) {
      onLoadMore();
    }
  },
);

Downgrade flutter sdk:
[source: https://stackoverflow.com/questions/49468321/how-to-downgrade-flutter-sdk-dart-1-x] 
> Flutter is versioned using git. Changing the Flutter version is as simple as changing git branch.

There are 2 different ways:

flutter channel <branch> (example: flutter channel stable)
This command is used to change between branches – usually stable/dev/beta/master. We can also put a specific commit id from git.

flutter version <version> (example: flutter version v1.2.1)
This command will use a specific version number. You can have the list of the available version numbers using flutter version or here

After this, run any Flutter command (such as flutter doctor), and Flutter will take care of downloading/compiling everything required to run this version.