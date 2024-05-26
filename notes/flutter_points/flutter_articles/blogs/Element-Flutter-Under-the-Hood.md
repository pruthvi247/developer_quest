[source](https://medium.com/@chooyan/element-flutter-under-the-hood-3e8937c4eb74) -   Tsuyoshi Chujo

Element is one of the key concepts in the Flutter framework for its rendering pipeline. However, it’s usually hidden behind `Widget` and we have few chances to see the name of `Element` on our VS Code.

Although `Element` is always behind widgets and never appears in front of us, **we still need to understand how they work in the mechanism of the Flutter framework in order for us to find the proper usage of widgets**.

Moreover, this knowledge is useful for understanding how state management packages, such as Riverpod, GetX, etc, are working.

In this article, we are going to reveal how `Element` is created first and what it does in the Flutter framework, especially in the build phase, so that we find the build phase isn’t performed by widgets but by `Element`. We are also going to make it clear the relevant programming based on the mechanism of Flutter.

So, let’s get started!
# How `Element` Is Created?

First of all, we start with discussing when, and where `Element` is created.

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
A simplified image of the relationship between a single `Widget` and `Element` is shown below.
![[Pasted image 20240324005821.png]]
## Element Tree

We now have one question, **“Who calls** `**createElement()**`**, then?”**

The answer is **“the parent** `**Element**`**does”**.

When the Flutter framework is in the build phase, the framework checks widgets returned by `build()` method of `StatelessWidget` or `StatefulWidget` one by one, from parent to child.

In that process, when the framework finds out a certain widget doesn’t have its corresponding `Element` yet, its `createElement()` is called and created `Element` is treated as a `child` ( or one of the `children` ) of the parent `Element`.

By doing that process from the most ancestor `Element` to the very leaf of the tree, `Element` constructs **“Element tree”**.

On the other hand, by the way, widgets DON’T remember their relationship with parent/child in general. When we jump to the definition of `Widget` class, we soon find that they don’t have any field for remembering their parent or children.

Thus, we can say **“**`**Widget**` **doesn’t construct a tree, but** `**Element**` **does”.**

Though we usually talk about the “Widget tree”, the actual appearance of the tree is like below.
![[Pasted image 20240324005841.png]]
You can see **Widgets don’t connect to each other while Elements do**, and **Elements also have references to their corresponding widgets** while widgets don’t.
To sum up, `Element` is created by its parent `Element` by calling the corresponding widget’s `createElement()` method in the build phase, and the creation continues until the build comes to the end leaf of the widgets.

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
```
```dart
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

Besides `Element`s build widgets to compose UI, they also consider **what** `**Element**` **should be built**.

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
Omitting assertions, **all** `**setState()**` **does is to call** `**markNeedsBuild()**` **of the corresponding** `**Element**` after calling `fn` that maintains state. That’s the mechanism under the hood that `setState()` causes rebuilding with the maintained state.

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

If you’ve got interested in this mechanism, I strongly recommend to read the document “Inside Flutter” in docs.flutter.dev and jumping into the implementation of the Flutter framework hitting F12.
reference : [flutter-doc](https://docs.flutter.dev/resources/inside-flutter?source=post_page-----3e8937c4eb74--------------------------------)
