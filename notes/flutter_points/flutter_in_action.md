[source: flutter in action]
> start android simulator on ma os
First list down the installed emulators

~/Library/Android/sdk/tools/emulator -list-avds

then run an emulator

~/Library/Android/sdk/tools/emulator -avd Nexus_5X_API_27

> cmd+shift+p -> to open dev tools (chap3,lession 8)


Lectures :

> named routes instead of MaterialPageRoute
> listbuilder is better than regular list view
> use const key word where ever possible
> when navigating form one page to another page , we should make sure that pages are not accomidating, make sure that old page is getting replaced with new, (using pushReplacementNamed , instaed of pushNamed)
> expanded widget

chapter 9:

> snack bar, make sure present snackbar goes before new one comes -lesson2
> dismissable object->confirm dismiss-> dialogue
> in flutter builders give their own context of what widget they will be building
> consumer for state management
> Provider.of vs Consumer is a matter of personal preference. But there's a few arguments for both
Provider.of

    can be called in all the widgets lifecycle, including click handlers and didChangeDependencies
    doesn't increase the indentation

Consumer

    allows more granular widgets rebuilds
    solves most BuildContext misuse

[link]: https://medium.com/flutter-community/making-sense-all-of-those-flutter-providers-e842e18f45dd

> form widget -> for user inputs
> adding images to forms - lession 10 
> submitting forms - lession 11
> validator , for validating user input in forms - lession 12
> did change dependencies()
> setState()
> optimistic updating - chapter-10, lession -17 and lession 20
> notifyListeners()
> future builder
> media query.of -> to get the device size
> dispose method -> we should call this to dispose a widget when widget is not required any more
> expanded widget
> path provider
> maps/url launcher

################# The Boring Show ###################
ep1:
----


















