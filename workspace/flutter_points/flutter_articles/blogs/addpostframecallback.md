[Source](https://www.didierboelens.com/2019/04/addpostframecallback/)

How can I show a Dialog the very first time I load a page? How can I do something once a build is complete?

## Question

Several times I received questions such as

-   _How can I show a Dialog only the first time a page is displayed?_
-   _How can I get the dimensions of something that depends on the device dimensions and other constraints?_
-   _How can I do something once the build is complete?_

---

## Answer

All these questions have something in common, we have to wait for the completion of **build** before doing something…

Let’s take each of the questions, one by one, to explain how _Flutter_ works…
### How can I show a Dialog only the first time a page is displayed?

When you begin in _Flutter_ and you need to display something on the screen at page load, it is very natural to think that you can trigger it from the **initState()** or even from the **Widget build(BuildContext context)**…

Then you end up with a code that might look like one the following:
```dart
... @override void initState(){ 
super.initState();
showDialog( ... );
}
```
or
```dart
... @override Widget build(BuildContext context){
showDialog( ... );
return Scaffold( ... );
}
```
I think that everyone who started up with _Flutter_ once thought it was the way to proceed… but you systematically received a debug console error message stating something like:

-   “_setState() or markNeedsBuild() called during build. This Overlay widget cannot be marked as needing to build because the framework is already in the process of building widgets…_”
-   “_inheritFromWidgetOfExactType(_LocalizationsScope) or inheritFromElement() was called before _PageState.initState() completed…_”

What does this mean and why can I not do it this way?

In order to understand it, you need to get back to the basics and more precisely on the “_StatefulWidget Lifecyle_” (see my article [Widget - State - Context - InheritedWidget](https://www.didierboelens.com/2018/06/widget---state---context---inheritedwidget/)).

When you are loading a _Page_ (= “_Route_"), the latter is either a _StatelessWidget_ or a _StatefulWidget_, but if you consider the _initState()_ method, it is a _StatefulWidget_. So, let’s continue the explanation with a _StatefulWidget_.

So, when you ask _Flutter_ to display a new _Page_ (=_Route_), behind the scene, _Flutter_ needs to render your page on your device screen. This is done during a process called “_frame rendering_” (I will explain all this in a next article).

During this _frame rendering_, related to the first time we want to display the new page, the _Widget_ is **inflated**. This means that it creates an _Element_ (= _BuildContext_) which starts its lifecyle and will call the following methods in sequence:

-   initState
-   didChangeDependencies
-   build

It is **ONLY** once the method _build_ is complete, that a couple of milliseconds later the _frame rendering_ of that page is complete and that you may request to display something else, **in addition**.

What does happen when I call _showDialog()_ inside the _initState()_?

In fact, when _Flutter_ executes the _initState()_ method, it is in the middle of a _frame rendering_ process.

When you invoke the _showDialog()_ method, you request _Flutter_ to try to find the nearest **Overlay** _Widget_ in the _Widgets tree_, using the _context_ as source of the research…

Bear in mind that the _context_ is, in fact, the **Element** that corresponds to the _Widget_ you are currently inflating and that during the call to the _initState()_, that _element_ is not yet **mounted** (= not yet formally positioned in the tree). Therefore, that _context_ cannot yet be used to look for the nearest _Overlay_, since not yet formally in the tree…

What does happen when I call _showDialog()_ from the _build(…)_ method?

When you are invoking the _showDialog()_ from the _build(BuildContext context)_ method, _Flutter_ finds the nearest _Overlay_ widget and asks it to insert a new _OverlayEntry_, which will be used as a container for the _dialog_ you want to show.

As the _Overlay_ needs to be refreshed (to render the dialog), it requests the _Flutter Framework_ to rebuild it but… _Flutter_ is **already** in a build process. Therefore, _Flutter_ rejects the request and throws an exception.

### So, what is the solution?

_Flutter Framework_ has a convenient API to request a callback method to be executed **once** a _frame rendering_ is complete. This method is:

[WidgetsBinding.instance.addPostFrameCallback](https://docs.flutter.io/flutter/scheduler/SchedulerBinding/addPostFrameCallback.html).
## How to use the _addPostFrameCallback_?

Case 1: Show a dialog **only** the first time you display a page
```dart
@override void initState(){
super.initState();
WidgetsBinding.instance.addPostFrameCallback((_){
showDialog( context: context, ... );
});
}
```
As the **initState** is only invoked the **very first time** you inflate the _StatefulWidget_, this method will **never** be called a second time.

Therefore, you may request the **addPostFrameCallback** to display your dialog from that method. The _showDialog_ will be executed **after** the build is complete.

Case 2: Do something once the _build_ is **complete**

This might be very useful to wait for the rendering to be complete to, for example, get the exact dimensions of _Widget_. To do this:
```dart
@override Widget build(BuildContext context){
WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
return Container( ... ); } 
void _onAfterBuild(BuildContext context){
// I can now safely get the dimensions based on the context
}
```