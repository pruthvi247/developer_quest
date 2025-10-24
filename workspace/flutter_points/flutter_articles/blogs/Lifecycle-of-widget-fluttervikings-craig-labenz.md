

![[Pasted image 20230404121554.png]]
![[Pasted image 20230404121516.png]]

Lets see the widget tree for below code

```dart
Container(

color: Colors.blue,

padding: const EdgeInsets.all(10),

child: const Text('Hello, Flutter vikings-2022'),

)
```
Widget tree for above code

In below diagram, color coding is :
- grey boxes - stateless widget
- blue boxes - render object

![[Pasted image 20230404124431.png]]


**Pseudocode:
The class that manages rendening phases is called ***ScheculerBinding*** . 

![[Pasted image 20230404124730.png]]

### Schedulerphase :
```dart
enum SchedulerPhase{
	idle,
	transientCallbacks,
	midFrameMicrotasks,
	persistentCallbacks,
	postFrameCallbacks,
	}
```


> Scheduler will redraw the screen when setstate or animation/ticker controler is updated
> transientCallbacks - This is when vsync evnet happens, activte animation controllers ticks and call backs

![[Pasted image 20230404125040.png]]
**transientCallbacks**
![[Pasted image 20230404125444.png]]
**midFrameMicrotasks**
![[Pasted image 20230404131456.png]]

**persistentCallbacks**
![[Pasted image 20230404131632.png]]

> Elements and State objects have life cycles

### LifeCycle of element

```dart
//widgets/framework.dart
enum _ElementLifeCycle{
	initial,
	active,
	inactive,
	defunct,
}
```

![[Pasted image 20230404132220.png]]

**LifeCycle of state object**
![[Pasted image 20230404132828.png]]

>didChangeDependencies, didUpdateWidget, build -> These are in one circle because these gets  called sequentially

Code that runs begining of frame:
```dart
import 'dart:ui';
ui.PlatformDispatcher.instance.scheduleFrame()
WidgetsBinding.instance.darwFrame()
WidgetsBinding.buildOwner.buldScope(Element element)

```
Above code is the handshake between flutter and dart engine

![[Pasted image 20230404133617.png]]
**First Frame** :
> Build scope builds all widgets below it, in above code its checking for dirty elements and deleting

![[Pasted image 20230404133736.png]]
> inflatewidget is the first method that gets called by flutter to draw first frame, if you observe *createElement()* method is called in above code, which means it calls *initstate* lifecycle

![[Pasted image 20230404134112.png]]

When ever some one calls *setState* flutter marks that particular elements as dirty elements

![[Pasted image 20230404134226.png]]
Below code is the rebuild from `buildscope()` above

![[Pasted image 20230404134440.png]]
![[Pasted image 20230404134502.png]]
> Below updateChild() is the core of widget system

![[Pasted image 20230404134744.png]]

![[Pasted image 20230404134805.png]]
![[Pasted image 20230404134824.png]]
![[Pasted image 20230404134944.png]]
![[Pasted image 20230404135007.png]]

Example of above flow:

![[Pasted image 20230404135043.png]]

![[Pasted image 20230404135057.png]]
![[Pasted image 20230404135127.png]]
![[Pasted image 20230404135150.png]]
![[Pasted image 20230404135213.png]]
once all the widgets and elements are rebuild and resynced then flutter moves to layout and paint

**PostframeCallbacks**
![[Pasted image 20230404135644.png]]
We can call *postFrameCallback* any were , but we should not call any where we want. we can run some clean up or cheap code in *postFrameCallback*

