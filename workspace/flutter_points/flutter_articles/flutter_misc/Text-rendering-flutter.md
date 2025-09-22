[source](https://www.kodeco.com/4562681-flutter-text-rendering)
## A Journey Through the Framework

As a Flutter developer, you’re already quite familiar with _stateless_ and _stateful_ widgets, but they’re not the only ones. Today you’re going to learn a little about a third kind, `RenderObjectWidget`, and the low level classes of the Flutter framework that support it.

The following diagram shows the `Widget` subclasses, where the ones in blue are the ones I want to focus on most in this lesson.
![[Pasted image 20231205195847.png]]
`RenderObjectWidget` is a blueprint. It holds the configuration information for `RenderObject`, which does all the hard work of hit testing and painting the UI.

The following diagram shows some of the subclasses of `RenderObject`. The most common one is `RenderBox`, which defines a rectangular area of the screen to paint on. One of its many subclasses, `RenderParagraph`, is what Flutter uses to paint text.
![[Pasted image 20231205195930.png]]
As you know, layouts in Flutter are made by composing widgets into trees. Behind the scenes there is a corresponding _render object tree_. But widgets and render objects don’t know how to interact with each other. Widgets can’t make a render object tree, and render objects don’t know when the widget tree changes.

That’s where _elements_ come in. There is a corresponding element tree that has an `Element` for every `Widget` in the widget tree. The elements hold a reference to both the widgets and the corresponding render objects. They are the managers or intermediaries between the widgets and the render objects. Elements know when to create render objects, where to put them in a tree, how to update them when there are changes, and when to inflate (create) new elements from child widgets.

The following diagram shows the main `Element` subclasses. Every widget has a corresponding element, so you’ll notice the similarity in names to the `Widget` subclasses.
![[Pasted image 20231205200053.png]]
>_Fun fact_: You’ve been interacting directly with elements all along, but you might not have realized it. You know `BuildContext`? That’s really just a nickname for `Element`. Or to put it more technically, `BuildContext` is an abstract class that `Element` implements.

### Stepping in: The Text Widget

You’re going to step into the Flutter source code now to see how widgets, elements, and render objects are actually used. You’ll follow a `Text` widget all the way to the creation of its render object, that is, `RenderParagraph`.
```dart
child: Align(
  alignment: Alignment.bottomCenter,
  child: Text( // TODO: Start your journey here
    Strings.travelMongolia,
```
The widget tree here has an `Align` widget with a `Text` widget child. As you step through the source code, you can refer to the diagram below:
![[Pasted image 20231205200207.png]]
Perform the following steps:

1. Command-click (or Control-click on a PC) _Text_ to go to the widget’s source code definition. Note that `Text` is a stateless widget.
2. Scroll down to the `build` method. What does the method return? Surprise! It’s a `RichText` widget. It turns out that `Text` is just `RichText` in disguise.
3. Command-click _RichText_ to go to its source code definition. Note that `RichText` is a `MultiChildRenderObjectWidget`. Why _multi_-child? In previous versions of Flutter before 1.7, it actually used to be a `LeafRenderObjectWidget`, which has no children, but now `RichText` supports inline widgets with [widget spans](https://api.flutter.dev/flutter/widgets/WidgetSpan-class.html).
4. Scroll down to the `createRenderObject` method. There it is. This is where it creates `RenderParagraph`.
5. Add a breakpoint to the _return RenderParagraph_ line.
6. Run the app again in debug mode.

In Android Studio if you have the _Debug_ and _Variables_ tabs selected, you should see something similar to the following:
![[Pasted image 20231205200420.png]]
You should also have the following stack trace with these lines at the top. I added the widget or element type in parentheses. The numbers on the far right refer to the comments below.
```
RichText.createRenderObject             (RichText)    // 8
RenderObjectElement.mount               (RichText)    // 7
MultiChildRenderObjectElement.mount     (RichText)
Element.inflateWidget                   (Text)        // 6
Element.updateChild                     (Text)
ComponentElement.performRebuild         (Text)        // 5
Element.rebuild                         (Text)
ComponentElement._firstBuild            (Text)
ComponentElement.mount                  (Text)        // 4
Element.inflateWidget                   (Align)       // 3
Element.updateChild                     (Align)       // 2
SingleChildRenderObjectElement.mount    (Align)       // 1
```
Let’s follow how `RenderParagraph` was created. You won’t click every line, but starting at the 12th line from the top:

1. Click _SingleChildRenderObjectElement.mount_. You are in the element for the `Align` widget. In your layout the child of `Align` is a `Text` widget. So the `widget.child` that is getting passed into `updateChild` is the `Text` widget.
2. Click _Element.updateChild_. At the end of a long method your `Text` widget, called `newWidget`, is being passed into `inflateWidget`
3. Click _Element.inflateWidget_. Inflating a widget means creating an element from it, as you can see happens with _Element newChild = newWidget.createElement()_. At this point you are still in the `Align` element, but you are about to step into the `mount` method of the `Text` element that was just inflated.
4. Click _ComponentElement.mount_. You are now in the `Text` element. Component elements (like `StatelessElement`) don’t create render objects directly, but they create other elements, which will eventually create render objects.
5. The next exciting thing is a few methods up the stack trace. Click _ComponentElement.performRebuild_. Find the _built = build()_ line. That right there, folks, is where the `build` method of the `Text` widget gets called. [`StatelessElement`](https://github.com/flutter/flutter/blob/38f849015ce9d38362b41feb8163d33f6c94a7af/packages/flutter/lib/src/widgets/framework.dart#L3974) uses a setter to add a reference to itself as the `BuildContext` argument. The `built` variable is your `RichText` widget.
6. Click _Element.inflateWidget_. This time `newWidget` is `RichText`, and it’s used to create a `MultiChildRenderObjectElement`. You’re still in the `Text` element, but you’re about to step into the `mount` method of the `RichText` element.
7. Click _RenderObjectElement.mount_. Will you look at that? What a beautiful sight: _widget.createRenderObject(this)_. Finally, this is where `RenderParagraph` gets created. The argument `this` is the `MultiChildRenderObjectElement` that you are in.
8. Click _RichText.createRenderObject_. And here you are out the other side. Notice that the `MultiChildRenderObjectElement` was rebranded as `BuildContext`.

What you did in the last section was at the Widgets layer. In this section you are going to step down into the _Rendering_, _Painting_, and _Foundation_ layers. Even though you’re going deeper, things are actually simpler at the lower levels of the Flutter framework because there aren’t multiple trees to deal with.

Are you still at the breakpoint that you added? Command-click _RenderParagraph_ to see what’s inside.

Take a few minutes to scroll up and down the `RenderParagraph` class. Here are a few things to watch out for:

- `RenderParagraph` extends `RenderBox`. That means this render object is rectangular in shape and has some intrinsic width and height based on the content. For a render paragraph, the content is the text.
- It handles hit testing. Hey, kids, no hitting each other! If you are going to hit something, hit `RenderParagraph`. It can take it.
- The `performLayout` and `paint` methods are also interesting.

Did you notice that `RenderParagraph` hands off its text painting work to something called `TextPainter`? Find the definition of __textPainter_ near the top of the class. Let’s leave the Rendering layer and go down to the Painting layer. Command-click _TextPainter_.

Take a minute to view the scenery.

- There is an important member variable called `_paragraph` of type `ui.Paragraph`. The `ui` part is a common way to prefix classes that are from the `dart:ui` library, the very lowest level of the Flutter framework.
- The `layout` method is really interesting. You can’t instantiate `Paragraph` directly. You have to use a `ParagraphBuilder` class to do it. It takes a default paragraph style that applies to the whole paragraph. This can be further modified with styles that are included in the `TextSpan` tree. Calling `TextSpan.build()` adds those styles to the `ParagraphBuilder` object.
- You can see that the `paint` method is pretty simple here. `TextPainter` just hands the paragraph off to _canvas.drawParagraph()_. If you Control-click that, you’ll see that it calls _paragraph._paint_.

You’ve come to the Foundation layer of the Flutter framework. From within the `TextPainter` class, Control-click the following two classes:

- _ParagraphBuilder_: It adds text and pushes and pops styles, but the actual work is handed off to the native layer.
- _Paragraph_: Not much to see here. Everything is handed down to the native layer.

Go ahead and stop the running app now.

Here is a diagram to summarize what you saw above:
![[Pasted image 20231205202802.png]]
### Way Down: Flutter’s Text Engine

It can be a little scary leaving your homeland and going to a place where you can’t speak the native language. But it’s also adventurous. You’re going to leave the land of Dart and go visit the native text engine. They speak C and C++ down there. The good thing is that there are a lot of signs in English.

You can’t Command-click anymore in your IDE, but the code is all on GitHub as a part of the Flutter repository. The text engine is called LibTxt. Go there now at [this link](https://github.com/flutter/engine/tree/master/third_party/txt).

We’re not going to spend a long time here, but if you like exploring, have a look around the `src` folder later. For now, though, let’s all go to the native class that _Paragraph.dart_ passed its work off to: [_txt/paragraph_txt.cc_](https://github.com/flutter/engine/blob/master/third_party/txt/src/txt/paragraph_txt.cc). Click that link.

You may enjoy checking out the `Layout` and `Paint` methods in your free time, but for now scroll down just a little and take a look at the imports:

continue reading blog ... [here](https://www.kodeco.com/4562681-flutter-text-rendering?page=2)
