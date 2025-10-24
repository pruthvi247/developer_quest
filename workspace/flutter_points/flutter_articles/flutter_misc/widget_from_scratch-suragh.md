[medium-source](https://medium.com/flutter-community/creating-a-flutter-widget-from-scratch-a9c01c47c630)

**Important**: First Read [flutter under the hood](#Flutter-under-the-hood) article which is drafted form another blog before reading further. This article explains how createElement works internally

---------- Widgets from scratch by suragh -------------
_A guide to building your own custom RenderObject_

The normal way to create widgets in Flutter is through composition, which means combining several basic widgets into a more complex one. That’s not what this article is about, but if your not familiar with the concept, you can read more about it in [Creating Reusable Custom Widgets in Flutter](https://www.raywenderlich.com/10126984-creating-reusable-custom-widgets-in-flutter).

When the existing Flutter widgets can’t be combined in a way to match what you need, you can [use a](https://suragch.medium.com/how-to-paint-in-flutter-d18c6c26df10) `[CustomPaint](https://suragch.medium.com/how-to-paint-in-flutter-d18c6c26df10)` [widget](https://suragch.medium.com/how-to-paint-in-flutter-d18c6c26df10) to draw exactly what you want. Again, that’s not what this article is about, but you can see some good examples of it [here](https://blog.codemagic.io/flutter-custom-painter/) and [here](https://stackoverflow.com/questions/45130497/creating-a-custom-clock-widget-in-flutter).

When you browse the Flutter source code you’ll discover that the vast majority of widgets use neither composition nor `CustomPaint`. Instead they use `RenderObject` or or one of its subclasses, especially `RenderBox`. Creating a custom widget in this way will give you the most flexibility in painting and sizing your widget — but also the most complexity, which is where this article comes in.

# Are you sure you’re ready?

This article assumes you’re already familiar with render objects. If you’re not, you can start by reading [Flutter Text Rendering](https://www.raywenderlich.com/4562681-flutter-text-rendering), which includes an exploration of widgets, elements, and render objects.

Also, if this is your first time creating a custom widget, you should probably try the composition or custom painting methods mentioned above first. But if you dare to go low-level, then welcome along. You’ll learn the most by following each step as you read the directions.

_The code in this article up to date for_ **_Flutter 2.0.0_** _and_ **_Dart 2.12_**_._

# The big picture

Creating a custom render object involves the following aspects:

- **Widget**: The widget is your interface with the outside world. This is how you get the properties you want. You’ll use these properties to either create or update the render object.
- **Children**: A widget, and in turn a render object, can have zero, one, or many children. The number of children affect the size and layout of the render object. In this article you’ll make a render object with no children. This will simplify a number of steps.
- **Layout**: In Flutter, [constraints go down](https://flutter.dev/docs/development/ui/layout/constraints), so you’re given a max and min width and length from the parent and then expected to report back how big you want to be within those constraints. Will you wrap your content tightly or will you try to expand as large as your parent allows? Part of creating a render object is making information about your **intrinsic size** available. Since the custom widget that you’ll be making in this article won’t have any children, you don’t need to worry about asking them how big they want to be or about positioning them. However, you will need to report back how much space you need to paint your content.
- **Painting**: This step is very similar to what you would do in a `CustomPaint` widget. You’ll receive a canvas that you can draw on.
- **Hit testing**: This tells Flutter whether you want to handle touch events or let them pass through to the widget below. In this article you’ll also add a gesture detector to help you handle the touch events.
- **Semantics**: This is related to providing additional text information about your widget. You won’t see this text, but Flutter can use to help visually impaired users. If you don’t know anyone who’s blind, then it’s tempting to skip this step. But don’t.

So are you sure you want to make a custom render object? There’s still time to back out.

All right. Here we go then.

# Preview

The custom widget you’ll make will look like this:

![[slider-custom-widget.gif]]

It’s a simplified version of the [Slider](https://api.flutter.dev/flutter/material/Slider-class.html) widget.

**_Note_**_: Why not just use a Slider widget then, you say, and skip all the trouble of making a custom render object? The reason I chose this is because I’d like to make an audio player progress bar that shows the download buffer in addition to the current play location. The standard Slider doesn’t do that, though it might be possible to hack a_ [_RangeSlider_](https://api.flutter.dev/flutter/material/RangeSlider-class.html) _into something close. One could probably also get_ [_CustomPaint_](https://api.flutter.dev/flutter/widgets/CustomPaint-class.html) _to work, but it doesn’t give much flexibility with layout. Anyway, given the basic render object above, it will be a fairly simple matter to pass in a few more properties and update the_ `paint` _method to create the audio player progress bar. Besides, this is an opportunity for both you and me to finally learn about making our own render objects._

We’ll follow the general outline I described in **The Big Picture** section above. If you get lost along the way, scroll down to the bottom of this article where you’ll find the full code.

# Widget

The first step is to make a widget that will allow you to pass properties in to your render object. There are a million customizations that you could allow, but let’s start with these three:

- progress bar color
- thumb color
- thumb size
![[Pasted image 20231204150408.png]]
The colors will allow you to learn about repainting, and the size will allow you to learn about updating the size of the widget.

**_Note_**_: I don’t really know why the thumb is called a thumb, but that’s what the Flutter Slider calls it, so I’m using the same name. Think of it more like a handle or a knob. Another name for the progress bar is track bar or seek bar._

## Understanding the main parts of the widget

Before creating the widget, have a look at a skeletal outline of its contents:
```dart
class ProgressBar extends LeafRenderObjectWidget {  
  @override  
  RenderProgressBar createRenderObject(...) {}  @override  
  void updateRenderObject(...) {}  @override  
  void debugFillProperties(...) {}  
}
```
**Notes**:

- Your widget will extend [LeafRenderObjectWidget](https://api.flutter.dev/flutter/widgets/LeafRenderObjectWidget-class.html) because it won’t have any children. If you were making a render object with one child you would use [SingleChildRenderObjectWidget](https://api.flutter.dev/flutter/widgets/SingleChildRenderObjectWidget-class.html) and for multiple children you’d use [MultiChildRenderObjectWidget](https://api.flutter.dev/flutter/widgets/MultiChildRenderObjectWidget-class.html).
- The Flutter framework (that is, the element) will call [createRenderObject](https://api.flutter.dev/flutter/widgets/Transform/createRenderObject.html) when it wants to create the render object associated with this widget. Since we named the widget `ProgressBar`, it’s customary to prefix this with “Render” when naming the render object. That’s why you have the return value of `RenderProgressBar`. Note that you haven’t created this class yet. It’s the render object class that you’ll be working on later.
- Widgets are inexpensive to create, but it would be expensive to recreate render objects every time there was an update. So when a widget property changes, the system will call [updateRenderObject](https://api.flutter.dev/flutter/widgets/RenderObjectWidget/updateRenderObject.html), where you will simply update the public properties of your render object without recreating the whole object.
- The [debugFillProperties](https://api.flutter.dev/flutter/widgets/State/debugFillProperties.html) method provides information about the class properties during debugging, but it’s not very interesting for the purposes of this article.

## Filling in the details

Create a new file called **progress_bar.dart**. Add the following code to it. This is just a fuller version of what you saw above.
`progress_bar.dart`
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ProgressBar extends LeafRenderObjectWidget {
  const ProgressBar({
    Key? key,
    required this.barColor,
    required this.thumbColor,
    this.thumbSize = 20.0,
  }) : super(key: key);
  
  final Color barColor;
  final Color thumbColor;
  final double thumbSize;

  @override
  RenderProgressBar createRenderObject(BuildContext context) {
    return RenderProgressBar(
      barColor: barColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderProgressBar renderObject) {
    renderObject
      ..barColor = barColor
      ..thumbColor = thumbColor
      ..thumbSize = thumbSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('barColor', barColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(DoubleProperty('thumbSize', thumbSize));
  }
}
```
Ignore the errors about the `RenderProgressBar` for now. You haven’t created it yet.

In this filled out version of `ProgressBar`, you can see the `barColor`, `thumbColor`, and `thumbSize` properties are used in the following ways:

- initializing the constructor
- creating a new instance of `RenderProgressBar`
- updating an existing instance of `RenderProgressBar`
- providing debug information

Now that you’ve created the `ProgressBar` widget, it’s time to create the `RenderProgressBar` class.

# Render object

In this section you’ll create the render object class and add the properties you need.

## Creating the class

Create a new class named `RenderProgressBar` as shown below. You can keep it in the same file as the `ProgressBar` widget.

```dart
class RenderProgressBar extends RenderBox {}
```
[RenderBox](https://api.flutter.dev/flutter/rendering/RenderBox-class.html) is a subclass of [RenderObject](https://api.flutter.dev/flutter/rendering/RenderObject-class.html) and has a two-dimensional coordinate system. That is, it has a width and a height.

## Adding the constructor

Add the following constructor to `RenderProgressBar`:
```dart
RenderProgressBar({  
required Color barColor,  
required Color thumbColor,  
required double thumbSize,  
}) : _barColor = barColor,  
_thumbColor = thumbColor,  
_thumbSize = thumbSize;
```
This defines the public properties that you want, but you’ll see some errors since you haven’t created the private fields for them yet. You’ll do that next.

## Adding the properties

Add the code for `barColor`:
```dart
Color get barColor => _barColor;  
Color _barColor;  
set barColor(Color value) {  
if (_barColor == value)  
return;  
_barColor = value;  
markNeedsPaint();  
}
```
Since the setter is updating the color, you’ll need to repaint the bar with a new color. Calling [markNeedsPaint](https://api.flutter.dev/flutter/rendering/RenderObject/markNeedsPaint.html) at the end of the method tells the framework to call the [paint](https://api.flutter.dev/flutter/rendering/RenderObject/paint.html) method at some point in the near future. Since painting can be potentially expensive, you should only call `markNeedsPaint` when necessary. That’s the reason for the early return at the beginning of the setter.

Now add the code for `thumbColor`:
```dart
Color get thumbColor => _thumbColor;  
Color _thumbColor;  
set thumbColor(Color value) {  
if (_thumbColor == value)  
return;  
_thumbColor = value;  
markNeedsPaint();  
}
```
This works the same as `barColor` did.
Finally, add the code for `thumbSize`:
```dart
double get thumbSize => _thumbSize;  
double _thumbSize;  
set thumbSize(double value) {  
if (_thumbSize == value)  
return;  
_thumbSize = value;  
**markNeedsLayout()**;  
}
```
The one difference here is that instead of calling `markNeeds**Paint**`, now you are calling `markNeeds**Layout**`. That’s because changing the size of the handle will also affect the size of the whole render object. Calling [markNeedsLayout](https://api.flutter.dev/flutter/rendering/RenderObject/markNeedsLayout.html) tells the system to call the [layout](https://api.flutter.dev/flutter/rendering/RenderObject/layout.html) method in the near future. Another layout call will automatically result in a repaint, so there is no need to add an additional `markNeedsPaint`.

# Layout and size

If you tried to use your widget now like this:
```dart
Scaffold(
  body: Center(
    child: Container(
      color: Colors.white,
      child: ProgressBar(
        barColor: Colors.blue,
        thumbColor: Colors.red,
        thumbSize: 20.0,
      ),
    ),
  ),
),
```
the IDE wouldn’t complain at you (until you try to run the app). Even if you did run the app, though, there would be nothing to see. One reason is because your widget doesn’t have any intrinsic size, and the other reason is because you haven’t painted any content. First let’s handle the size issue.

Take another look at a the progress bar that we want to make:
![[Pasted image 20231204150857.png]]
On a typical screen you’d probably want to width to expand to whatever the parent width is. But for the height, you’d want it to hug height of the handle.

Given that information you can set the size.

## Setting the desired size

The [computeDryLayout](https://master-api.flutter.dev/flutter/rendering/RenderBox/computeDryLayout.html) method is where you should calculate how big your widget will be based on the given constraints. In the past this was done in [performLayout](https://api.flutter.dev/flutter/rendering/RenderBox/performLayout.html) but now you can put the logic in compute dry layout and just reference it from `performLayout`. [See more information here](https://flutter.dev/docs/release/breaking-changes/renderbox-dry-layout).

Add the following code to `RenderProgressBar`:
```dart
@override
void performLayout() {
  size = computeDryLayout(constraints);
}
@override
Size computeDryLayout(BoxConstraints constraints) {
  final desiredWidth = constraints.maxWidth;
  final desiredHeight = thumbSize;
  final desiredSize = Size(desiredWidth, desiredHeight);
  return constraints.constrain(desiredSize);
}
```
**Notes**:

- If you need the sizes of any children you can get them by calling the child’s [getDryLayout](https://master-api.flutter.dev/flutter/rendering/RenderBox/getDryLayout.html) method and passing in some min and max size constraints. (The old way was to call [layout](https://api.flutter.dev/flutter/rendering/RenderObject/layout.html) on each of them from inside `performLayout`.) This gives you (that is, the parent render object) the information you need to place the children and determine your own size. (Remember the [quote](https://flutter.dev/docs/development/ui/layout/constraints), _“Constraints go down. Sizes go up. Parent sets position.”_) Since `RenderProgressBar` doesn’t have any children, though, (you made a `LeafRenderObjectWidget` if you recall), all you need to do here is calculate your own size.
- The `constraints` variable is of type [BoxContraints](https://api.flutter.dev/flutter/rendering/BoxConstraints-class.html) and is a property of `RenderBox`. These `BoxContraints` are passed in from the parent and tell you the max and min width and length that you’re allowed to be. You can choose any size for yourself within those bounds. By choosing `maxWidth` you’re saying that you want to expand to be as big as the parent allows. For the desired height you’re hugging your content by using the `thumbSize` property.
- Passing your desired size into `constraints.constrain` makes sure that you are still within the allowed constraints. For example, if `thumbSize` were large, it could exceed the `constraints.maxHeight` from the parent, which isn’t allowed.
- The [size](https://api.flutter.dev/flutter/rendering/RenderBox/size.html) variable is also a property of `RenderBox`. You should only set it from within the `performLayout` method. Everywhere else you should call `markNeedsLayout`. Also, the `computeDryLayout` method should not change any state.
- If you’re simply expanding to fill the parent or wrapping a single child, then you don’t need to override `performLayout`. See the [documentation](https://api.flutter.dev/flutter/rendering/RenderBox-class.html#layout) for more on this.

Now you’ve officially set the size of your render object, and the parent render object will also have that information.

## Setting the intrinsic size

Given only a height constraint, how wide would your widget naturally want to be? Or given only a width constrain, how tall would your widget naturally want to be. That’s what intrinsic size is all about.

Add the following four methods to `RenderProgressBar`:
```dart
static const _minDesiredWidth = 100.0;
@override  
double computeMinIntrinsicWidth(double height) => _minDesiredWidth;
@override  
double computeMaxIntrinsicWidth(double height) => _minDesiredWidth;
@override  
double computeMinIntrinsicHeight(double width) => thumbSize;
@override  
double computeMaxIntrinsicHeight(double width) => thumbSize;
```
**Notes**:

- The min intrinsic width is the narrowest that the widget would ever _want_ to be. That’s not guaranteeing it’ll never have a smaller width, but this is saying that the widget isn’t designed to be any narrower than that. The [Flutter Slider widget](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/slider.dart) uses a hard coded value of `144.0` (or three times a 48-pixel touch target). I figured we could go a little narrower with `100.0`.
- In setting the max width, you could have used `double.infinity`, but is infinity intrinsically the size you want to be, though? If not, then using the min width is reasonable. This is similar to what the Slider widget does.
- I used the same values for the max and min widths and also the same values for the max and min heights. That’s because a progress bar’s height isn’t affected by the width constraints. In the same way, the width isn’t affected by the height constraints. If you think about the `Text` widget though, that _would_ make a difference. As you can see in the animation below, making the width narrower causes the intrinsic height of the text to want to be taller.
![[1_Zcp_3UYKiU1iHip2nriwAA.gif]]
☝🏼`Text height being affected by width constraint`

To understand intrinsic sizes, it’s also helpful to see the difference between `width`, `minIntrinsicWidth`, and `maxIntrinsicWidth` for a `Text` widget.

This image shows the **width**. This is based on what the parent told the widget to be and is independent of the content.
![[Pasted image 20231204151212.png]]
The following image shows **minIntrinsicWidth**. It is the narrowest that this widget would ever want to be. Notice that it is the size of the word “Another”. If you forced the widget to be any narrower than this width, it would make “Another” have to break across lines unnaturally.
![[Pasted image 20231204151227.png]]
Finally, the last image shows **maxIntrinsicWidth**. It’s the widest that this widget would ever want to be. The first two lines end with a `\n` newline character. However, because of the `width` constraint imposed by the parent, the third line soft-wrapped so that “wraps around.” is on the fourth line. If you took the full width of “A line of text that wraps around.” without making it wrap, that would be the value of **maxIntrinsicWidth**.
![[Pasted image 20231204151245.png]]
See [my Stack Overflow answer here](https://stackoverflow.com/a/57083633/3681880) for the code and more details.

## Testing it out

Our widget doesn’t paint itself yet, so it’s effectively invisible, but it does have a size now. That means we can wrap it with a colored `Container` as a trick to “see” it.

Replace your **main.dart** file with the following simple layout:
```dart
import 'package:flutter/material.dart';
import 'progress_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            color: Colors.cyan, //      <-- colored Container
            child: ProgressBar(
              barColor: Colors.blue,
              thumbColor: Colors.red,
              thumbSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
```
☝🏼`Run that and you’ll see a cyan colored bar`

Since the `Container` has the same size as our `ProgressBar`, we know that the size is working. That’s good.
![[Pasted image 20231204191201.png]]
On to painting some content in there!

# Painting

All the drawing action of a render object happens in the [paint](https://api.flutter.dev/flutter/rendering/RenderObject/paint.html) method.

Add the following code to the `RenderProgressBar` class:
```dart
double _currentThumbValue = 0.5;
@override
void paint(PaintingContext context, Offset offset) {
  final canvas = context.canvas;
  canvas.save();
  canvas.translate(offset.dx, offset.dy);
  // paint bar
  final barPaint = Paint()
    ..color = barColor
    ..strokeWidth = 5;
  final point1 = Offset(0, size.height / 2);
  final point2 = Offset(size.width, size.height / 2);
  canvas.drawLine(point1, point2, barPaint);
  // paint thumb
  final thumbPaint = Paint()..color = thumbColor;
  final thumbDx = _currentThumbValue * size.width;
  final center = Offset(thumbDx, size.height / 2);
  canvas.drawCircle(center, thumbSize / 2, thumbPaint);
  canvas.restore();
}
```
**Notes**:

- We’ll define `_currentThumbValue` to be a number from `0` to `1` that will represent the thumb position on the progress bar, where `0` means far left and `1` means far right. Using `0.5` will place it in middle of the bar for now.
- The `offset` parameter of the `paint` method tells you where the top left corner of your layout is on the canvas. Saving the canvas and then translating to that position means you don’t need to worry about this offset for any of the other drawing that your about to do. However, at the end of the `paint` method you call `restore` to undo your saved `translate` so that other widgets that may paint later don’t get messed up.
- For the actual painting, first draw the bar that the thumb moves along. The color is taken from the widget parameter `barColor`.
- Then paint the thumb. It’s vertically centered and the horizontal position is based on `_currentThumbValue`. When that value changes and `markNeedsPaint` is called, the new position gets repainted here.

In **main.dart**, comment out the color on the parent `Container` widget:
```dart
child: Container(  
**// color: Colors.cyan,** <-- comment this out  
child: ProgressBar(  
...
```
![[Pasted image 20231204191343.png]]
Nice! You can see it now!

It still isn’t interactive yet, though, so let’s handle that.
# Hit testing

Hit testing just tells Flutter whether or not you want your widget to handle touch events. Since we want to be able to move the thumb on our progress bar, we definitely do want the render object to handle touch events.

Add the following imports to **progress_bar.dart**:

```dart
import 'package:flutter/gestures.dart';  
import 'package:flutter/rendering.dart';
```
And then add the code below to `RenderProgressBar`:

```DART
late HorizontalDragGestureRecognizer _drag;
@override  
bool hitTestSelf(Offset position) => true;
@override  
void handleEvent(PointerEvent event, BoxHitTestEntry entry) {  
  assert(debugHandleEvent(event, entry));  
  if (event is PointerDownEvent) {  
    _drag.addPointer(event);  
  }  
}
```
**Notes**:

- Since you want to be able to move the thumb horizontally along the bar, [HorizontalDragGestureRecognizer](https://api.flutter.dev/flutter/gestures/HorizontalDragGestureRecognizer-class.html) allows you to get notifications about these kind of touch events. You make it `late` to give yourself time to initialize it in the constructor. You’ll do that in just a second.
- Returning `true` in [hitTestSelf](https://api.flutter.dev/flutter/rendering/RenderBox/hitTestSelf.html) tells Flutter that touch events get handled by this widget. They won’t be passed on to any widgets below this one. `hitTestSelf` also provides a `position` parameter, so you could theoretically sometimes return `true` and sometimes return `false` based on the `position` of the touch event. This would be useful if you had a donut-shaped widget where you wanted to let touch events in the hole and on the outside pass through.
- The [docs](https://api.flutter.dev/flutter/rendering/RenderBox/debugHandleEvent.html) say to use `debugHandleEvent` here. So I did. Apparently it does something useful.
- [handleEvent](https://api.flutter.dev/flutter/rendering/RenderBox/handleEvent.html) adds a [PointerDownEvent](https://api.flutter.dev/flutter/gestures/PointerDownEvent-class.html) to the drag gesture recognizer, but you still need to initialize it and handle other events, which you’ll do next.

## Dealing with the gesture recognizer

Replace the `RenderProgressBar` constructor with the following code:
```dart
RenderProgressBar({
  required Color barColor,
  required Color thumbColor,
  required double thumbSize,
})  : _barColor = barColor,
      _thumbColor = thumbColor,
      _thumbSize = thumbSize {
        
  // initialize the gesture recognizer
  _drag = HorizontalDragGestureRecognizer()
    ..onStart = (DragStartDetails details) {
      _updateThumbPosition(details.localPosition);
    }
    ..onUpdate = (DragUpdateDetails details) {
      _updateThumbPosition(details.localPosition);
    };
}
```

And then add the `_updateThumbPosition` method:
```dart
void _updateThumbPosition(Offset localPosition) {
  var dx = localPosition.dx.clamp(0, size.width);
  _currentThumbValue = dx / size.width;
  markNeedsPaint();
  markNeedsSemanticsUpdate();
}
```
**Notes**:

- The `localPosition` is the touch location of the drag event in relation to the top left corner of our widget. This can go out of bounds so you `clamp` it between zero and the width of the widget.
- `_currentThumbValue` needs to be a value between `0` and `1`, so you divide the touch position on the x axis by the total width.
- Call `markNeedsPaint` to repaint the new position of the thumb.
- If the thumb position changes, this represents a new state value of our widget. Calling `markNeedsPaint` tells Flutter to update the visual representation of this new state and calling `markNeedsSemanticsUpdate` tells Flutter to update the textual description of this new state. You haven’t implemented that yet, but you’ll do that in the next step.

Run the app again and try dragging the thumb:
## Do you need a repaint boundary?

To achieve the visual effects you got above, you had to repaint the widget every time there was a touch event update. An interesting thing about Flutter is that when a render object repaints itself, generally the parent render objects repaint themselves, too.

You can observe what parts of your app are getting repainted by turning on the debug repaint rainbow. Let’s do that now. In **main.dart** replace this line:
```dart
void main() => runApp(MyApp());
```
with the following:
```dart
void main() {  
  debugRepaintRainbowEnabled = true;  
  runApp(MyApp());  
}
```
The `debugRepaintRainbowEnabled` flag turns the repaint rainbow on. An alternate way to do it is to use the Dart DevTools as I described [here](https://stackoverflow.com/a/65474341/3681880). The following images are made using the DevTool version. (Sometime the flag version wasn’t adding a rainbow border for me.)

Now restart the app and move the thumb.
![[Pasted image 20231204192920.png]]
The regions that are being repainted have a rainbow border that changes colors on each repaint. As you can see, the entire window is getting repainted every time you update the thumb position.

Now, for widgets that don’t repaint themselves very often, it doesn’t really matter if the whole parent tree repaints. This is the default behavior in Flutter and even the standard Slider widget is the same. However, an audio progress bar is going to be doing a lot of repainting, not just for when users move the thumb but also whenever the music is playing. For that reason it seems to me that it would be good to limit the repainting to just our widget and not make all of the parent widgets repaint themselves, too.

To limit repainting to just our widget, add this single getter to the `RenderProgressBar` class:
```dart
@override  
bool get isRepaintBoundary => true;
```
The default was `false`, but now you’re setting it to `true`.
Run the app again and see the difference:

Now only the progress bar widget is getting repainted. The parent widget tree isn’t.
![[Pasted image 20231204193042.png]]
That’s great isn’t it? Why wouldn’t you always do this? Why isn’t that the default? Well, when you put a repaint boundary around your widget, Flutter makes a new painting layer that is separate from the rest of the tree. Doing so takes more memory resources. If the widget repaints a lot then that’s probably a good use of resources. But if it doesn’t then you’re wasting memory. You need to make that call for your own widget, but in my opinion it makes sense for this one.

Even for widgets that don’t have a repaint boundary, developers can always add one by putting `RepaintBoundary` in their widget tree. Read [the documentation on that](https://api.flutter.dev/flutter/widgets/RepaintBoundary-class.html) and also watch the excellent video [Improve your Flutter Apps performance with a RepaintBoundary](https://youtu.be/Nuni5VQXARo) to learn more.

You can remove the debugging repaint rainbow flag in **main.dart** now:

```dart
void main() {  
  // debugRepaintRainbowEnabled = true; //  <-- delete this  
  runApp(MyApp());  
}
```

There’s one more step before we’re done.

# Semantics

Semantics is about adding the necessary information for Flutter to tell a screen reader what to say when users are interacting with your widget.

## Using the semantics debugger

First of all, let’s see what visually impaired users “see” when they use your app. Go to main.dart and wrap `MaterialApp` with a `SemanticsDebugger` widget.
```dart
class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return SemanticsDebugger(  //      <-- Add this  
      child: MaterialApp(  
        home: Scaffold(...
```
Run app again.
It’s blank. So it looks like our app is completely useless to visually impaired people. Not good. Let’s fix that.

## Adding semantics configuration

In **progress_bar.dart**, add the following methods to `RenderProgressBar`:
`progress_bar.bart`
```dart
@override
void describeSemanticsConfiguration(SemanticsConfiguration config) {
  super.describeSemanticsConfiguration(config);

  // description
  config.textDirection = TextDirection.ltr;
  config.label = 'Progress bar';
  config.value = '${(_currentThumbValue * 100).round()}%';

  // increase action
  config.onIncrease = increaseAction;
  final increased = _currentThumbValue + _semanticActionUnit;
  config.increasedValue = '${((increased).clamp(0.0, 1.0) * 100).round()}%';

  // descrease action
  config.onDecrease = decreaseAction;
  final decreased = _currentThumbValue - _semanticActionUnit;
  config.decreasedValue = '${((decreased).clamp(0.0, 1.0) * 100).round()}%';
}

static const double _semanticActionUnit = 0.05;

void increaseAction() {
  final newValue = _currentThumbValue + _semanticActionUnit;
  _currentThumbValue = (newValue).clamp(0.0, 1.0);
  markNeedsPaint();
  markNeedsSemanticsUpdate();
}

void decreaseAction() {
  final newValue = _currentThumbValue - _semanticActionUnit;
  _currentThumbValue = (newValue).clamp(0.0, 1.0);
  markNeedsPaint();
  markNeedsSemanticsUpdate();
}
```
Here’s what that code does:

- `describeSemanticsConfiguration` is where you set the textual description for your widget by setting properties on the `config` object. This method will be called whenever you call `markNeedsSemanticsUpdate` from elsewhere within the render object.
- The `label` and `value` are what a screen reader would read when describing this widget. Since we don’t really want the screen reader to say “0.3478595746 Progress bar”, we converted the thumb value to a nicer number like 35%. This is what the `Slider` widget does as well.
- Users with a screen reader are able to use custom gestures to perform actions. By adding callbacks for `onIncrease` and `onDecrease` you are supporting those custom gestures. This provides an alternate way to move the thumb since these users can’t see its visual location. The `_semanticActionUnit` of `0.05` just means that whenever the `onIncrease` or `onDecrease` action is triggered, the thumb will increase or decrease by 5%.
It’s hard to see because the font is small, but it says “Progress bar (adjustable)”. You’re widget is now “visible” and interactable to screen readers. Good job.

Remove the `SemanticsDebugger` widget that you added earlier from your widget layout in **main.dart**. Run the app again and everything should be back to normal.

## A few more notes on semantics

First of all, thank you to 

[creativecreatorormaybenot](https://medium.com/u/e03cf4b099b?source=post_page-----a9c01c47c630--------------------------------)

 for help with semantics in the video [A definitive guide to RenderObjects in Flutter](https://www.youtube.com/watch?v=HqXNGawzSbY). Watch that video for a much more in depth guide to making render objects.

I still don’t have much experience using a screen reader so I haven’t actually tested the semantics on a real device. This means there’s a good chance I’m still missing something. Please let me know if you find a bug and I’ll update the article.

Accessibility issues are important to think about. Just recently one of my friends who is visually impaired asked me if I would consider working on a screen reader for traditional Mongolian. That reminded me I need to make sure all of the custom widgets I create are accessible — and semantics is the key to that.

By the way, have you ever tested your app with the system screen reader turned on? Let’s all do that before we publish our next update.

Here’s an introduction to TalkBack, the Android screen reader. It even includes a short discussion about sliders:

talk: https://www.youtube.com/watch?v=0Zpzl4EKCco

# Full code

_main.dart_
```dart
import 'package:flutter/material.dart';
import 'progress_bar.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            // color: Colors.cyan,
            child: ProgressBar(
              barColor: Colors.blue,
              thumbColor: Colors.red,
              thumbSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
```
_progress_bar.dart_
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ProgressBar extends LeafRenderObjectWidget {
  const ProgressBar({
    Key? key,
    required this.barColor,
    required this.thumbColor,
    this.thumbSize = 20.0,
  }) : super(key: key);

  final Color barColor;
  final Color thumbColor;
  final double thumbSize;

  @override
  RenderProgressBar createRenderObject(BuildContext context) {
    return RenderProgressBar(
      barColor: barColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderProgressBar renderObject) {
    renderObject
      ..barColor = barColor
      ..thumbColor = thumbColor
      ..thumbSize = thumbSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('barColor', barColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(DoubleProperty('thumbSize', thumbSize));
  }
}

class RenderProgressBar extends RenderBox {
RenderProgressBar({
  required Color barColor,
  required Color thumbColor,
  required double thumbSize,
})  : _barColor = barColor,
      _thumbColor = thumbColor,
      _thumbSize = thumbSize {
    // initialize the gesture recognizer
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = (DragStartDetails details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onUpdate = (DragUpdateDetails details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  void _updateThumbPosition(Offset localPosition) {
    var dx = localPosition.dx.clamp(0, size.width);
    _currentThumbValue = dx / size.width;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Color get barColor => _barColor;
  Color _barColor;
  set barColor(Color value) {
    if (_barColor == value) return;
    _barColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  double get thumbSize => _thumbSize;
  double _thumbSize;
  set thumbSize(double value) {
    if (_thumbSize == value) return;
    _thumbSize = value;
    markNeedsLayout();
  }

  static const _minDesiredWidth = 100.0;

  @override
  double computeMinIntrinsicWidth(double height) => _minDesiredWidth;

  @override
  double computeMaxIntrinsicWidth(double height) => _minDesiredWidth;

  @override
  double computeMinIntrinsicHeight(double width) => thumbSize;

  @override
  double computeMaxIntrinsicHeight(double width) => thumbSize;

  late HorizontalDragGestureRecognizer _drag;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = thumbSize;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }

  double _currentThumbValue = 0.5;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // paint bar
    final barPaint = Paint()
      ..color = barColor
      ..strokeWidth = 5;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);
    canvas.drawLine(point1, point2, barPaint);

    // paint thumb
    final thumbPaint = Paint()..color = thumbColor;
    final thumbDx = _currentThumbValue * size.width;
    final center = Offset(thumbDx, size.height / 2);
    canvas.drawCircle(center, thumbSize / 2, thumbPaint);

    canvas.restore();
  }
  
  @override
  bool get isRepaintBoundary => true;

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    // description
    config.textDirection = TextDirection.ltr;
    config.label = 'Progress bar';
    config.value = '${(_currentThumbValue * 100).round()}%';

    // increase action
    config.onIncrease = increaseAction;
    final increased = _currentThumbValue + _semanticActionUnit;
    config.increasedValue = '${((increased).clamp(0.0, 1.0) * 100).round()}%';

    // descrease action
    config.onDecrease = decreaseAction;
    final decreased = _currentThumbValue - _semanticActionUnit;
    config.decreasedValue = '${((decreased).clamp(0.0, 1.0) * 100).round()}%';
  }

  static const double _semanticActionUnit = 0.05;

  void increaseAction() {
    final newValue = _currentThumbValue + _semanticActionUnit;
    _currentThumbValue = (newValue).clamp(0.0, 1.0);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void decreaseAction() {
    final newValue = _currentThumbValue - _semanticActionUnit;
    _currentThumbValue = (newValue).clamp(0.0, 1.0);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }
}
```
# Update

Are you still here? Well, since you are, would you like to hear about the progress I made after finishing this article?

After making additional improvements to the widget I finally published it on Pub as `[audio_video_progress_bar](https://pub.dev/packages/audio_video_progress_bar)`. Here is what it looks like:
![[Pasted image 20231204152356.png]]
These are some of the improvements:

- Added a `buffered` duration to show the progress of the download buffer for streamed content.
- Added text labels for the current playing progress and total time. At first I added these as `Text` widgets by wrapping the `ProgressBar` render object widget with a `StatelessWidget` and formed the layout using composition with rows and columns. I wanted to add a repaint boundary, but constantly rebuilding the widget with new values for the `Text` widgets was triggering a new layout and causing all of the parent widgets in the whole UI to get rebuilt (and repainted). You can read about that problem [here](https://stackoverflow.com/questions/65477584/repaintboundary-with-a-streambuilder). I ended up discarding the `StatelessWidget` and solved it by painting the labels directly with a `TextPainter`. That way I could avoid calling `markNeedsLayout` every time the widget rebuilds. This, in combination with setting `isRepaintBoundary` to `true`, solved the problem and the widget no longer causes the whole widget tree to repaint when it rebuilds.
-  Added more parameters for changing the colors and sizes. I also made the colors default to the app theme’s primary color and the labels’ style default to the text theme’s `bodyText1` attribute. This makes the widget still look good when the users switch themes, even to a dark theme.
-  Added an enum parameter to allow showing the text labels on the sides or not at all. That made the painting and touch event position handling especially tricky. But in the end it seems to be working all right.
-  Added some widget tests. For a package that lots of people will be using, it’s especially important to add tests. I need to learn more about widget testing, though, because there was some behavior I didn’t know how to test (like dragging the thumb and checking the new duration).
- Added documentation comments for the public methods, properties and classes. This is also very important for a widget that other developers will be using. I also added some comments to remind the future me about what is happening in some of the tricky parts of the code.
- 

You can browse the source code for the current version of `ProgressBar` [here](https://github.com/suragch/audio_video_progress_bar/blob/master/lib/audio_video_progress_bar.dart).

# Conclusion

Although there is certainly more work that needs to be done on this custom widget, this article took you though all the main steps that you need to think about when building a custom render object. Check out the links below to learn more.

# Further study

- [RenderBox documentation](https://api.flutter.dev/flutter/rendering/RenderBox-class.html) (must read)
- [A definitive guide to RenderObjects in Flutter](https://www.youtube.com/watch?v=HqXNGawzSbY) (video)
- [Drawing Every Line Pixel-perfectly with Custom Render Objects — Pure #FlutterClock face](https://medium.com/flutter-community/pure-flutterclock-face-every-line-customly-drawn-with-pixel-perfect-control-c27cba427801)
- [How to Create a Flutter Widget Using a RenderObject](https://nicksnettravels.builttoroam.com/create-a-flutter-widget/)
- [Gap: A simple example to create your own RenderObject](https://romain-rastel.medium.com/gap-a-simple-example-to-create-your-own-renderobject-88eacca2a4)
- [A deep dive into Flutter’s accessibility widgets](https://medium.com/flutter-community/a-deep-dive-into-flutters-accessibility-widgets-eb0ef9455bc)
- Read the [Flutter source code](https://github.com/flutter/flutter) for any widget that is similar to what you want to make.


-------------------------------------------------
[medium-source](https://medium.com/saugo360/flutters-rendering-engine-a-tutorial-part-1-e9eff68b825d)

Another good read : https://blog.logrocket.com/understanding-renderobjects-flutter/
# Flutter Rendering Widget
### So how does Flutter render our apps?

On a very high level, ==rendering in Flutter goes through four phases:==

1. Layout Phase: in this phase, Flutter determines exactly how big each object is, and where it will be displayed on the screen.
2. Painting Phase: in this phase, Flutter provides each widget with a _canvas_, and tells it to paint itself on it.
3. Compositing Phase: in this phase, Flutter puts everything together into a _scene_, and sends it to the GPU for processing.
4. Rasterizing Phase: in this final phase, the scene is displayed on the screen as a matrix of pixels.

These phases are not exclusive to Flutter; you can find very similar phases in other rendering frameworks ([like web browsers](https://blog.logrocket.com/how-browser-rendering-works-behind-the-scenes-6782b0e8fb10)). What’s special about Flutter, though, is that its rendering process, as we shall see, is very simple, yet very efficient.

In Flutter, the layout phase is constituted of two _linear_ passes: the passing of **_constraints_** down the tree, and the passing of **_layout details_** up the tree.
The process is simple:

1. the parent passes certain _constraints_ to each of its children. Those constraints are the set of rules that the child must respect when laying itself out. It’s as if the parent is telling the child: “OK, do whatever you want, as long as you respect those constraints’. One simple example of constraints is a maximum width constraint; the parent could pass down to its child the maximum width within which it is allowed to render. When the child receives those constraints, it knows not to try to render anything wider than them.
2. The child, then, generates new constraints, and passes them down to its own children, and this keeps going until we reach a leaf widget with no children.
3. This widget, then, determines its _layout details_ based on the constraints passed down to it. For example, if its parent passed down to it a maximum width constraint of 500 pixels. It could say: “Well, I will use all of it up!”, or “I will only use a 100 pixels”. It, thus, determines the details necessary for its layout, and passes them back to its parent.
4. The parent in turn does the same. It uses the details propagated from its children to determine what its own details are going to be, and then passes them up the tree, and we keep going up the tree either until we reach the root, or until certain limits are reached.

But what are those “constraints” and “layout details” that we speak of? That depends on the _layout protocol_ in use. In Flutter, there are two main layout protocols: _the box protocol_, and _the sliver protocol_. The box protocol is used for displaying objects in a simple, 2D Cartesian coordinate system, while the sliver protocol is used for displaying objects that react to scrolling.

In the box protocol, the constraints that the parent passes down to its children are called [**BoxConstraints**](https://docs.flutter.io/flutter/rendering/BoxConstraints-class.html). Those constraints determine the maximum and minimum width and height that each child is allowed to be.
In the sliver protocol, things are a bit more complicated. The parent passes down to its child [**SliverConstraints**](https://docs.flutter.io/flutter/rendering/SliverConstraints-class.html), containing scrolling information and constraints, like the scroll offset, the overlap, etc. The child in turn sends back to its parent a [**SliverGeometry**](https://docs.flutter.io/flutter/rendering/SliverGeometry-class.html). We will explore the sliver protocol in more detail in a later part.

## Afterwards, we paint..

Once the parent knows all the layout details of its children, it can proceed to painting both itself and its children. To do that, Flutter passes it a [**PaintingContext**](https://docs.flutter.io/flutter/rendering/PaintingContext-class.html), which contains a [**Canvas**](https://docs.flutter.io/flutter/dart-ui/Canvas-class.html) on which it can draw. The painting context also allows it to paint its children, and to create new painting layers, for cases where we need to draw things on top of each other.

## We then go through compositing and rasterization..

which we will pass over for now, for the sake of looking at more concrete details of the rendering process..

# The Render Tree

You know about the widget tree, and how your widgets constitute a tree whose root starts with the App widget, and then explodes into branches and branches as you add widgets to your app. What you might not know, however, is that there is another tree that corresponds to your widget tree, called the _render tree_..

You see, you have been introduced to several kinds of widgets; the StatefulWidget, the StatelessWidget, the InheritedWidget, etc. But there is also another kind of widget called the [**RenderObjectWidget**](https://docs.flutter.io/flutter/widgets/RenderObjectWidget-class.html). This widget does not have a **build** method, rather a [**createRenderObject**](https://docs.flutter.io/flutter/widgets/RenderObjectWidget/createRenderObject.html) method that allows it to create a [**RenderObject**](https://docs.flutter.io/flutter/rendering/RenderObject-class.html) and add it to the render tree.

The **RenderObject** is the most important component of the rendering process. It is to the render tree what the Widget is to the widget tree. Everything in the render tree is a RenderObject. And each RenderObject has a lot of properties and methods used to carry out rendering. It has:

- a [**constraints**](https://docs.flutter.io/flutter/rendering/RenderObject/constraints.html) object which represents the constraints passed to it from its parent
- a [**parentData**](https://docs.flutter.io/flutter/rendering/RenderObject/parentData.html) object which allows its parent to attach useful information on it.
- a [**performLayout**](https://docs.flutter.io/flutter/rendering/RenderObject/performLayout.html) method in which we can lay it and its children out.
- a [**paint**](https://docs.flutter.io/flutter/rendering/RenderObject/paint.html) method in which we can use to paint it and paint its children.
- etc.

The RenderObject is an abstract class though. It needs to be extended to do any actual rendering. And the two most important classes that extend RenderOject are [**RenderBox**](https://docs.flutter.io/flutter/rendering/RenderBox-class.html) and, you guessed it, [**RenderSliver**](https://docs.flutter.io/flutter/rendering/RenderSliver-class.html). These two classes are the parents of all render objects that implement the box protocol and the sliver protocol, respectively. Those two classes are also extended by tens and tens of other classes that handle specific scenarios, and implement the details of the rendering process.

```dart
class Stingy extends SingleChildRenderObjectWidget {

  Stingy({Widget child}): super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderStingy();
  }
}
```
- Our widget extends [**SingleChildRenderObjectWidget**](https://docs.flutter.io/flutter/widgets/SingleChildRenderObjectWidget-class.html), which is a RenderObjectWidget that, as the name implies, accepts a single child.
- Our createRenderObject function, which creates and returns the RenderObject, creates an instance of a class that we called **RenderStingy**


-------------------------------------------------
[medium-source](https://medium.com/@chooyan/element-flutter-under-the-hood-3e8937c4eb74)
# Flutter-under-the-hood

In this article, we are going to reveal how `Element` is created first and what it does in the Flutter framework, especially in the build phase, so that we find the build phase isn’t performed by widgets but by `Element`. We are also going to make it clear the relevant programming based on the mechanism of Flutter.

## Widget Creates Element

Although we don’t see it in our widget, every widget has a method named `createElement()`.

Taking a look at the implementation of `StatelessWidget`, for example, we soon find the code below.
```dart
/// Creates a [StatelessElement] to manage this widget's location in the tree.  
///  
/// It is uncommon for subclasses to override this method.  
@override  
StatelessElement createElement() => StatelessElement(this);
```
`StatelessElement` here is a subclass of `Element`, and it’s created by `StatelessWidget` according to the code above.

example dart pad : [override createElement](https://dartpad.dev/?id=ea063238c3356fd8da370b9e081ee168)

Other kinds of widgets, such as `StatefulWidget`, `RenderObjectWidget`, etc, also have their own `createElement()` implementation that returns their corresponding subclasses of `Element`.
```dart
/// Creates a [StatefulElement] to manage this widget's location in the tree.  
///  
/// It is uncommon for subclasses to override this method.  
@override  
StatefulElement createElement() => StatefulElement(this);
```
As we can see the widget passes itself to a constructor of `Element`, `Element` preserves the instance of the corresponding `Widget`in once they are instantiated.
```dart
Element(Widget widget)  
: _widget = widget {  
// ... initialize  
}
```
We now have one question, **“Who calls** `**createElement()**`**, then?”**

The answer is **“the parent** `**Element**`**does”**.

When the Flutter framework is in the build phase, the framework checks widgets returned by `build()` method of `StatelessWidget` or `StatefulWidget` one by one, from parent to child.

In that process, when the framework finds out a certain widget doesn’t have its corresponding `Element` yet, its `createElement()` is called and created `Element` is treated as a `child` ( or one of the `children` ) of the parent `Element`.

By doing that process from the most ancestor `Element` to the very leaf of the tree, `Element` constructs **“Element tree”**.

On the other hand, by the way, widgets DON’T remember their relationship with parent/child in general. When we jump to the definition of `Widget` class, we soon find that they don’t have any field for remembering their parent or children.

Thus, we can say **“**`**Widget**` **doesn’t construct a tree, but** `**Element**` **does”.**
To sum up, `Element` is created by its parent `Element` by calling the corresponding widget’s `createElement()` method in the build phase, and the creation continues until the build comes to the end leaf of the widgets
![[Pasted image 20231209181936.png]]
You can see **Widgets don’t connect to each other while Elements do**, and **Elements also have references to their corresponding widgets** while widgets don’t.

`simplified image of the relations ship between a single widget and element`
![[Pasted image 20231209181857.png]]

The references to their parent or widgets are preserved in each `Element`, and the actual shape of the “tree” is constructed with `Element`.
# What Element Do?

It’s now clear how `Element` is created and how the “Tree” is built.

Our next topic is **“How** `**Element**` **contributes to composing our UI in the Flutter framework? What does it do?”**.

`Element` does a lot of things actually, so let’s pick up a couple of the most important roles in this article.

## Build Widgets

One of the important roles of `Element` is building and updating widgets by `rebuild()` method.

Though `rebuild()` doesn’t have a concrete logic, `performRebuild()` called inside `rebuild()` and overridden by its subclasses does have logic in the implementations of each subclass.

For example, `ComponentElement`, which is a common superclass of `StatelessElement` and `StatefulElement`, implements `performRebuild()` like below. (note that assertion or error handlings are omitted)
```dart
void performRebuild() {  
Widget? built;  
try {  
built = build();  
}  
try {  
_child = updateChild(_child, built, slot);  
}  
}
```
In addition, `build()` method called above is implemented in `StatelessElement` and `StatefulElement`.
```dart
// implementation by StatelessElement  
@override  
Widget build() => (widget as StatelessWidget).build(this);

// implementation by StatefulElement  
@override  
Widget build() => state.build(this);
```
As we can see, `StatelessElement` calls `build()` method of its corresponding widget, while `StatefulElement` calls `build()` of `state`. They are the methods that we implement every day like below.
```dart
@override  
Widget build(BuildContext context) {  
return MyPageWidget();  
}
```
After calling `build()`, the returned widget is passed to `updateChild()` method that creates the child of processing `Element` from the widget if necessary, and the process continues recursively until the build isn’t required anymore.

## Optimize Build

Besides `Element`s build widgets to compose UI, they also consider **what** **Element** should be built.

**The widget tree isn’t rebuilt entirely in all the frames**, which comes 60 (or 120) times per seconds, and **each** `**Element**` **manages whether it should be rebuilt in the next frame and also should rebuild its child(ren) or not**.

`Element` has a flag named `_dirty`, which represents whether the `Element` need to be rebuilt in the next frame or not.
```dart
/// Returns true if the element has been marked as needing rebuilding.  
///  
/// The flag is true when the element is first created and after  
/// [markNeedsBuild] has been called. The flag is reset to false in the  
/// [performRebuild] implementation.  
bool get dirty => _dirty;  
bool _dirty = true;
```
As commented in the code above, this flag changes into `true` when `markNeedsBuild()` is called. The method “marks” the `Element` to be rebuilt in the next frame, with the implementation below.
```dart
/// Marks the element as dirty and adds it to the global list of widgets to  
/// rebuild in the next frame.  
///  
/// Since it is inefficient to build an element twice in one frame,  
/// applications and widgets should be structured so as to only mark  
/// widgets dirty during event handlers before the frame begins, not during  
/// the build itself.  
void markNeedsBuild() {  
if (_lifecycleState != _ElementLifecycle.active) {  
return;  
}  
if (dirty) {  
return;  
}  
_dirty = true;  
owner!.scheduleBuildFor(this);  
}
```
`markNeedsBuild()` is called via various ways that issues rebuilding. Typically, for example, `setState()` of `StatefulWidget` calls the method inside like the code below.
```dart
void setState(VoidCallback fn) {  
final Object? result = fn() as dynamic;  
_element!.markNeedsBuild();  
}
```
As we’ve understood `markNeedsBuild()` only “marks” the `_dirty` flag as `true`, meaning rebuild is required in the next frame, we can now say that **calling** `**setState()**` **multiple times in a single method DOESN’T result in multiple rebuilding**. We don’t need to be nervous trying to refactor not to call `setState()` multiple times within one function call.

**Other state management packages, such as** `**Riverpod**`**,** `**Provider**`**, etc, are also implemented based on this mechanism**. What they are doing, in the end, is calling `markNeedsBuild()` at relevant timings.
`Element` also optimizes rebuild by considering **how much** they rebuild their child.

When we extract a brief implementation of `updateChild()`, we find three conditional branches like below.

Note that `child.widget` here is the widget built last time, and `newWidget` is the widget built in the current build.
```dart
if (hasSameSuperclass && child.widget == newWidget) {  
newChild = child;  
} else if (hasSameSuperclass && Widget.canUpdate(child.widget, newWidget)) {  
final bool isTimelineTracked = !kReleaseMode && _isProfileBuildsEnabledFor(newWidget);  
child.update(newWidget);  
newChild = child;  
} else {  
deactivateChild(child);  
newChild = inflateWidget(newWidget, newSlot);  
}
```
The first condition compares two widgets if they are exactly the same object. This case happens when we write `const` for the widget’s constructor that returns exactly the same object at any time.

In this case, nothing happens and its child is not built but the cache is reused.

The second one compares two widgets with `canUpdate()` method whose implementation is written below.
```dart
static bool canUpdate(Widget oldWidget, Widget newWidget) {  
return oldWidget.runtimeType == newWidget.runtimeType  
&& oldWidget.key == newWidget.key;  
}
```
In the case that the instances of two widgets are different but they have the same `runtimeType` and the same `key` (even if they both are `null` ), `Element` finds there are no changes but the difference of argument at most, as in the difference of `Text('hello')` and `Text('goodbye')`.

In this case, the cached `Element` is reused and the rebuild continues to its child.

The last one is the case that `child.widget` and `newWidget` are completely different, which means the structure of the UI has changed.

In this case, the old `Element` is disposed and a brand new `Element` is created in `inflateWidget()`, and the rebuild continues to its child.

In short, `Element`s checks the difference between the last build and the current rebuild and reuses caches of `Element` as much as possible in order to prevent meaningless computing.

## Find Ancestor Widget

As pointed out above, `Element` preserves the relationships between their parents and children. Using the information, finding other widgets on the tree (typically ancestor widgets) is another important ability.

The mechanism is not only used in the framework but also by us actually.

Before discussing it, we have to check the code calling `build()` method of `StatelessWidget` again.
```dart
// implementation by StatelessElement  
@override  
Widget build() => (widget as StatelessWidget).build(this);
```
We can see `this` is passed to `build()` widget as an argument. As the code is `Element`‘s, `this` is `Element`. Then, let’s take a look at the typical code of `build()` method that we write every day.
```dart
@override  
Widget build(BuildContext context) {  
return MyPage();  
}
```
As we can see the argument is `BuildContext context`, `context` is an `Element`. We can double-check this by looking at the definition of `Element` below.
```dart
abstract class Element extends DiagnosticableTree implements BuildContext {  
}
```
`Element` implements `BuildContext` and its document says `BuildContext` is

> A handle to the location of a widget in the widget tree.

In other words, the type `BuildContext` is an interface for us to perform some methods using the widget tree.

One frequently used example is `Navigator.of(context)`. The static method `of()` of `Navigator` is implemented like below.
```dart
static NavigatorState of(
  BuildContext context, {
  bool rootNavigator = false,
}) {
  NavigatorState? navigator;

  if (context is StatefulElement && context.state is NavigatorState) {
    navigator = context.state as NavigatorState;
  }
  if (rootNavigator) {
    navigator = context.findRootAncestorStateOfType<NavigatorState>() ?? navigator;
  } else {
    navigator = navigator ?? context.findAncestorStateOfType<NavigatorState>();
  }

  return navigator!;
}
```
Where we need to take a closer look is the methods of `context`, `findRootAncestorStateOfType()` and `findAncestorStateOfType()`.

`findAncestorStateOfType()` is, for example, a method to find an ancestor `State` object of `StatefulWidget`, which is implemented in the class `Element` like below.
```dart
@override
T? findAncestorStateOfType<T extends State<StatefulWidget>>() {
  Element? ancestor = _parent;
  while (ancestor != null) {
    if (ancestor is StatefulElement && ancestor.state is T) {
      break;
    }
    ancestor = ancestor._parent;
  }
  final StatefulElement? statefulAncestor = ancestor as StatefulElement?;
  return statefulAncestor?.state as T?;
}
```
The logic is quite simple, just infinitely looping with `while` and searching `ancestor` until the type of `ancestor.state` matches the given `T`.

Similarly, we have `getInheritedWidgetOfExactType()` method for finding `InheritedWidget`.
```dart
@override
InheritedElement? getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
  final InheritedElement? ancestor = _inheritedElements == null ? null : _inheritedElements![T];
  return ancestor;
}
```
This one is more simple that it finds a widget whose type is given `T` from `_inheritedElements` whose type is `PersistendHashMap<Type, InheritedWidget>`.

`_inheritedElements` preserves `InheritedWidget`s that are the ancestor of `context` with key-value pair of `Type` and the instance.

By using this, we can access to `InheritedWidget` with O(1) order, which means the depth of the widget tree doesn’t affect the performance to find the target `InheritedWidgt.`

`Element`, a.k.a `BuildContext`, is provided for us to find ancestor widgets.
# Conclusion

That’s it!

Once we understand what `Element` is and how they work under the hood, many questions can be answered with relevant reasons.

It’s OK to call `setState()` multiple times in a single function, for example, because `setState()` only raises `Element`‘s flag of `_dirty`, and rebuilding only happens once when the next frame comes.

`context` should not be cached with our own logic because `context` is an `Element` and it can be disposed of by the Flutter framework depending on the result of rebuilding.

As long as I understand, many state management packages are also implemented based on this mechanism. `WidgetRef` of `Riverpod` package is exactly the same object with `BuildContext`, or `context.read()` of `Provider` package uses `context.getInheritedWidgetOfExactType()` inside.

If you’ve got interested in this mechanism, I strongly recommend to read the document [Inside Flutter](https://docs.flutter.dev/resources/inside-flutter?source=post_page-----3e8937c4eb74--------------------------------) in docs.flutter.dev and jumping into the implementation of the Flutter framework hitting F12.

















