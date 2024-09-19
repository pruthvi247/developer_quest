_A Little More Framework for the Flutter Framework makes for better apps_
[Source](https://dev.to/andrious/little-more-life-cycle-handling-1fp0?utm_source=substack&utm_medium=email)


As part of [the ‘Little More’ Series](https://dev.to/andrious/the-little-more-series-19df), this article will review the Life cycle events that should be considered when running your app. Events that are made readily available to you when using the [[Fluttery Framework](https://pub.dev/packages/fluttery_framework)] package.


[iOS Application Life Cycle](https://blog.devgenius.io/ios-application-life-cycle-672a7eec9d8d)
![[Pasted image 20240802132009.png]]

[Android Application Life Cycle](https://developer.android.com/guide/components/activities/activity-lifecycle#alc)
![[Pasted image 20240802132202.png]]
Like its iOS and Android counterparts (see above), Flutter StatefulWidgets have their own life cycle. Below is a graphical depiction of that Life cycle as it’s currently understood. Follow the arrows, and you’re following the ‘sequence of function calls’ when certain circumstances occur. Using the Fluttery Framework, your State object will always have a corresponding function to address any such event — as best as it‘s able anyway.

You see, Flutter is a cross-platform solution — the Flutter engine runs on top of a completely different operating system depending on the device. As such, there are two separate life cycles involved when it comes to Flutter (denoted in the graphic by the dotted line). Unfortunately, as of this writing, these two life cycles do not acknowledge each other at all.
![[Pasted image 20240802132314.png]]
For example, Flutter will not call a StatefulWidget’s **deactivate**() and **dispose**() functions whenever a user has ‘unfocused’ your app with some hand gesture — only to terminate it soon after. For those developers working on the mobile platforms in particular, this has become an issue.
### Rule #2 To Keep In Mind

_Regardless of platform, remember to close databases and other time-critical resources in the **hiddenAppLifeCycleState__() method only to open them again in the method, **resumeAppLifeCycleState__(), if and when the user returns to your app._

This can get really complicated, but the Fluttery Framework is here to help you.

Another quick example is demonstrated in the video below. Page 1 and Page 2 are two StatefulWidgets called one after the other. The user then returns from Page 2 to Page 1. Again, the example app with its many **print**() functions details all the events that occur (see below). In this case, you can see when Page2 was closed, the functions, **deactivate**() and **dispose**(), are called in quick succession.

### Better To Deactivate Than Dispose

Remember this: You’ll have no idea when a State object’s **dispose**() is called — if ever. This function is called by the Flutter engine as part of its ‘garbage collection’ process. It’s to the engine’s discretion when the **dispose**() function is called (or never called under certain memory constraints), and so, if your StatefulWidgets have any time-critical resources being freed and such, it would be more reliable to do so in their **deactivate**() functions and not in their **dispose**() functions.

### Rule #1 To Keep In Mind

_Regardless of platform, if no longer required by the closing StatefulWidget, remember to close any databases and any time-critical resources in its **deactivate__() method only to open them again in its method, **activate__(), if the running StatefulWidget is not being closed but instead is being moved around the Widget tree (e.g. Reordering items in a ListView widget)._
## The Series of Events

[ **Fluttery frame work from greg** ](https://pub.dev/packages/fluttery_framework)
![[Pasted image 20240802134317.png]]


Let’s quickly go through the event functions calls listed above and suggest what they represent. As you know, when a State object is first created, it is these two functions below that are called. The first State object is called, __AppState._
![[Pasted image 20240802133449.png]]

The Fluttery Framework is ‘aware’ a router is involved in this example app, and so the ‘home’ screen with its State object, __Page1State_, is started up and will soon call its **initState**() function, but not before its event function, **didPush**(), is called first. This allows you to run code ‘when a StatefulWidget is just opened by a Router.
![[Pasted image 20240802133555.png]]

The next two **print**() functions are displayed below.
![[Pasted image 20240802133728.png]]

Because this was run on a mobile phone emulator, the painting and sizing of the app’s interface triggers the **didChangeMetrics**() in the two StatefulWidgets that make up the app so far. Note, how they’re called in the order they were instantiated — with the help of the Fluttery Framework.
![[Pasted image 20240802133746.png]]

The next line tells Page 1 that the next screen to be displayed has been selected while the second line tells Page 2 it came about because of a router. Note, there’s no reinventing the wheel to achieve this. Fluttery is just implementing what’s already there in Flutter to note these events.
![[Pasted image 20240802133837.png]]

The next three lines tells you ‘Page 2’ is now displayed with a count of zero.
![[Pasted image 20240802133855.png]]

In the next screenshot below, both the first screen and second screen are notified when the user has returned back to Page 1. Great stuff!
![[Pasted image 20240802133947.png]]
Consequently, Page 2 is about to be removed from memory. Therefore, the next two lines appear. Again, the **deactivate**() is a better place to ‘clean up things’ before returning to the previous screen. The **dispose**() function just happens to be called right after **deactivate**() frankly. Under different circumstances beyond your control, it could just as easily never be called.
![[Pasted image 20240802134012.png]]

