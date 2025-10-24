we will discuss all the important state methods you can implement in your code to empower your app.

## **InitState()**

InitState() is used to subscribe to the object. Overriding of initState() method performs initialization which depends on the location at which this object was inserted into the tree (like context) or on the widget used to configure this object (or widget). In simple terms, while a page in flutter gets created on screen, this method gets called at very first.

## **didUpdateWidget()**

This method is helpful to unsubscribe the old object and subscribe to new one if it is required for the object to be replaced with updated widget configuration. Overriding this method responds when the widget changes (example, to begin implicit animations).

> **Fact:** The framework always calls build() **after** calling didUpdateWidget(), which means any calls to setState() in didUpdateWidget() are redundant.

## **dispose()**

When the instance is removed from the tree (or simply from the screen) completely, this method should be called. The aim of this method is to release the resources retained by the object.(like any controllers, animations, timers, etc.) The framework calls this method when object will never gonna be built again. when dispose() method gets called, the object is considered as “unmounted” and “mounted” is updated as false. (this is called terminal of life-cycle.)

> **Fact:** Sometimes you have the error like setState() called after dispose() method which is because of the unsubscribed of the resources. It is always a best practice to implement setState() method wrapping with “mounted”. There is no way to remount a state object that has been disposed.

## build()

build() is a main and important method of the app. Whatever one want to see in the app must be added inside this method. BuildContext passed inside build method contains every information regarding the location in the tree at which the widget is being built.

> **Fact:** The **_context_** object is passed to the widget’s **build** function automatically by the framework. If you try to pass a specific **_context_** object to a child, you won’t be able to.

## **reassemble()**

reassemble() is called whenever the application is reassembled during debugging (e.g. during hot reload). This method should rerun any initialization logic that depends on global state, for e.g., image loading from asset bundles (since the asset bundle may have changed). This function will only be called during development.

> **Fact:** In release builds, the reassemble() hook is not available, and so this code will never execute. Implementer should not rely on any ordering for hot reload source update, reassemble, and build methods after a hot reload has been initiated. **Once reassemble is called, build will be called after it at least once.**

It is possible that a Timer (or an animation) or a debugging session attached to the isolate could trigger a build with reloaded code before reassemble is called.

## **didChangeDependencies()**

This is one of the most important and often used method. didChangeDependencies() is called just few moments after the state loads its dependencies and context is available at this moment.

> **Fact:** Both: initState() and didChangeDependencies() are called before build() is called. The only difference is that initState() is called before the state loads its dependencies and didChangeDependencies() is called a few moments after the state loads its dependencies.

If you want to listen updated value, The recommendation is to use didChangeDependencies() instead initState() (it will cause an exception).

## **mount()**

Consider a scenario where you want to call the method only when the page gets loaded (availability of object in a tree), before dispose(), here mount is really helpful. After creating a object and before calling initState(), the framework “mounts” the state object by associating it with a current context (BuildContext) object. The state object remains mounted until the framework calls dispose(), after which time the framework will never ask the state object to build() again.

> **Fact:** One should only implement setState() method after checking “if(mounted)” which helps to avoid error like, setState() called after dispose().

## **deactivate()**

This method is called whenever it removes this state object from the tree. In some cases, the framework will reinsert the state object into another part of the tree. If that happens, the framework will ensure that it calls build() to give the state object a chance to adapt to its new location in the tree. If the framework does reinsert this sub-tree, it will do so before the end of the animation frame in which the sub-tree was removed from the tree. For this reason, state objects can defer releasing most resources until the framework calls their dispose method.

> [**FYI:**](https://developpaper.com/) when the State object is removed from the tree, this callback function is called, which indicates that the StatefulWidget will perform a destruction operation. It is also called when the page is switched because the position of the State in the view tree changes, but the State is not destroyed.

_Just look around the below example for strengthening the understanding of all this methods._
```dart
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("build statelessWidget");
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(initValue: 0),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.initValue: 0});

  final int initValue;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.initValue;
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    print("build State widget");
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display4,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Increment Counter",
            onPressed: () {
              if (mounted) {
                print("mounted");
                setState(
                  () => ++_counter,
                );
              } else {
                print("unmounted");
              }
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            heroTag: "Next Screen Navigation",
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return DemoScreen();
            })),
            tooltip: 'Next Screen',
            child: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactivate");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }
}

class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo Screen"),
      ),
      body: Center(
        child: Text("Demo Screen"),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "Previous Screen Navigation",
        onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return HomeScreen();
        })),
        tooltip: 'Previous Screen',
        child: Icon(Icons.navigate_before),
      ),
    );
  }
}

/*
  Attempt:
    1) add button click
    2) add button click
    3) next button click
  Output:
    flutter: build statelessWidget
    flutter: initState
    flutter: didChangeDependencies
    flutter: build State widget
    flutter: mounted
    flutter: build State widget
    flutter: mounted
    flutter: build State widget
    flutter: deactivate
    flutter: dispose
*/
```