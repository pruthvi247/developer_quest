[source-medium](https://medium.com/@chooyan/reinventing-provider-understand-flutter-and-inheritedwidget-underhood-4c833e37a636)
State management is one of the most complicated topics in Flutter especially for **state shared with several widgets, in other words, “app state”.** `InheritedWidget` is one of the core widgets of Flutter, which exposes value to descendant widgets as app state.

When thinking of exposing value to multiple widgets, we tend to think of using [Riverpod](https://pub.dev/packages/riverpod), [Provider](https://pub.dev/packages/provider), [Bloc](https://pub.dev/packages/bloc), or other “state management” packages.

[A list of different approaches to managing state](https://docs.flutter.dev/data-and-backend/state-mgmt/options?source=post_page-----4c833e37a636--------------------------------)

However, we actually can do the same thing _without_ using any packages but `InheritedWidget`.

[API docs for the InheritedWidget class from the widgets library, for the Dart programming language](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html?source=post_page-----4c833e37a636--------------------------------)

It’s obvious that `InheritedWidget` is not powerful enough to build more than medium-sized apps with keeping robustness or flexibility, and it requires some boilerplate codes for each state, so it’s almost always relevant to use those packages for production apps.

But still, **understanding how** `**InheritedWidget**` **works in the Flutter framework helps us understand the mechanism of those packages underhood and consider appropriate usages of them**, or we might even have chances NOT using those packages is relevant to build tiny apps.

In this article, we are going to take a look at **how we use** `**InheritedWidget**` first. Then, we abstract the code so that we can use the mechanism with several purposes with less code.

As `Provider` package is a wrapper of `InheritedWidgt`, we soon find that **our abstracted code is quite similar to** `**Provider**`, in other words, **reinventing** `**Provider**`. Though the package is almost deprecated and it’s recommended to use `Riverpod`instead, **understanding the basic concept and mechanism of** `**Provider**` **package is valuable for understanding** `**Riverpod**` **package or other state-management packages**.

So, let’s get started with using `InheritedWidget`.

# How to use InheritedWidget

We are going to build a simple app showing the list of articles
We can add the article in `ArticleAddPage` and list them in `ArticlesPage` shown above.
Now, let’s take a look at the code of this app. Note that the entire code is not written in this article, but important pieces of the code are focused on.

## **Implement InheritedWidget**

First, we write the widget named `ArticlesContainer`extending `InheritedWidget` that preserves `List<Article>`.
```dart
class ArticlesContainer extends InheritedWidget {
  const ArticlesContainer(
    this.articles, {
    super.key,
    required super.child,
  });

  final List<Article> articles;

  @override
  bool updateShouldNotify(covariant ArticlesContainer oldWidget) {
    return true; // always notifies when ArticlesContainer is rebuilt.
  }
}
```
What `InheritedWidget` (or `ArticlesContainer` ) do is just preserve `List<Article>` as its field named `articles`.

`InheritedWidget` has the functionality to notify its changes to the descendant widgets that depend on it when it is rebuilt.

However, as `InheritedWidget` is a widget, it must be immutable and `articles` can’t be updated by itself.

## Implement Parent StatefulWidget

So how can we maintain the data of `articles`? The simplest way is to use `StatefulWidget` as its parent, named `ArticlesProvider` and `ArticleProviderState`.
```dart
class ArticlesProvider extends StatefulWidget {
  const ArticlesProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ArticlesProvider> createState() => ArticlesProviderState();
}

class ArticlesProviderState extends State<ArticlesProvider> {
  final articles = <Article>[];

  @override
  Widget build(BuildContext context) {
    return ArticlesContainer(
      articles,
      child: widget.child,
    );
  }
```
As `ArticleProviderState` is extending `State`, it can cause a rebuild with calling`setState()` method, which also rebuilds `ArticlesContainer`.

## Place ArticlesProvider above MaterialApp

`ArticlesProvider` is also a widget, and it must be placed as an ancestor of `ArticlesPage` and `AddArticlePage` for the reason expressed later.

So, we update the code like below to make `MaterialApp` a child of `ArticlesProvider`.
```dart
@override
Widget build(BuildContext context) {
  return const ArticlesProvider(
    child: MaterialApp(
      home: ArticlesPage(),
    ),
  );
}
```
## **Method to Maintain the List**

What we have to do next is define a method to maintain `articles` with calling `setState()` in `ArticlesProviderState`.
```dart
void add(Article newArticle) {
  setState(() {
    articles.add(newArticle);
  });
}
```
The `add()` method above simply adds the given `Article` object to `articles` with calling `setState()` method. This causes the rebuilding itself and its child, `ArticlesContainer`, passing the updated articles list.

## Providing the Method to Access ArticlesProviderState

How can we access to `ArticlesProviderState` object and how can we call `add()` method from descendant widgets like `AddArticlePage`?

The answer is calling `context.findAncestorStateOfType<T>()` method. What the method will do is find the nearest ancestor `State` object whose type matches the given type `T`.

Usually, calling the long-named method at any time is verbose and additional logics, such as error handling when no `T` is found, is required as boilerplate codes. So providing the static `of()` method is often used.
```dart
static ArticlesProviderState of(BuildContext context) {
  final state = context.findAncestorStateOfType<ArticlesProviderState>();
  assert(state != null, 'No ArticlesProviderState found');
  return state!;
}
```
Now, we can access to relevant `ArticlesProviderState` object with `ArticlesProviderState.of(context)`. You might find that the interface is similar to `Navigator.of(context)` or `Scaffold.of(context)`, the latter one is deprecated though. Yeah, it’s the frequently used pattern in the Flutter framework!

## Updating the List

With the method defined above, we can now simply update `articles` and cause rebuild when tapping “ADD” button in `AddArticleScreen` with the code below.
`ArticlesProviderState.of(context).add(newArticle);`
## Reading the List

What we have to think of next is how we can access `articles` and observe its update.

`context` has the similar method to `findAncestorStateOfType<T>()`, whose name is `dependOnInheritedWidgetOfExactType<T>()`. The method finds the nearest ancestor `InheritedWidget` of given type `T` **with O(1) order**.

Like `ArticlesProviderState.of(context)`, we can provide the logic to find `ArticlesContainer` object with the code below.
```dart
static ArticlesContainer of(BuildContext context) {
  final widget = context.dependOnInheritedWidgetOfExactType<ArticlesContainer>();
  assert(widget != null, 'No ArticlesContainer found');
  return widget!;
}
```
Because `dependOnInheritedWidgetOfExactType<T>()` method has the functionality to remember what `context` is used to call this method and rebuild them when `InheritedWidget` is rebuilt, we can not only access to `articles` but also observe its updates with the code below.
`final articles = ArticlesContainer.of(context).articles;`
Congratulations!

We’ve built the app sharing `articles` object, an “app state”, using `InheritedWidget`. `ArticlesPage` and `AddArticlePage` can now access or observe it via their `context` and `of()` method. You can check the entire code in the `minimum_inheritedwidget` branch of the GitHub repository below.
**[state_management_practice](https://github.com/chooyan-eng/state_management_practice)**
# Refactor with ValueNotifier

We’ve achieved building state management functionality with `InheritedWidget` so far, yet we have a problem with this code.

Users of `ArticleProvider` have to know which method should be used, `ArticlesProviderState.of()` or `ArticlesContainer.of()`, depending on what they want to do, observing value or calling method. They would wish they could just call the same `.of()` method regardless of the usage of receiving object.

The problem causes because they must access to `ArticlesContainer` widget to observe `articles` field with O(1) order, while they must access to `ArticlesProviderState` to call `add()` method that calls `setState` inside. We have currently no object that achieves both features.

Fortunately, however, we can solve the problem with some refactoring using `ValueNotifier` and `ListenableBuilder`, both are standard classes of Flutter.

## Defining a Subclass of ValueNotifier

First, we define a subclass of `ValueNotifier` that notifies updates of its `value` field. Our subclass is named `ArticlesState` and preserves `articles` as its field.
```dart
class ArticlesState extends ValueNotifier<List<Article>> {
  ArticlesState() : super([]);
}
```
Then, we move `add()` method of `ArticlesProviderState` to this class.
```dart
void add(Article newArticle) {
  value = [...value, newArticle];
}
```
Note that calling `setState()` isn’t necessary anymore because `ArticlesState` is not a subclass of `State` of `StatefulWidget`. In spite of `setState()`, rebuilds can occur by calling the setter of `value` giving a different object from the previous `value`; I believe most of the Flutter users are already used to this concept.

## Preserve ArticlesState Object in ArticlesProviderState

Next, what we have to do is change `ArticlesProviderState's` field from `List<Article> articles` to `ArticlesState state`.
`final state = ArticlesState();`
And also we need to pass `state` object to `ArticlesContainer` widget.
```dart
const ArticlesContainer(
  this.state, {
  super.key,
  required super.child,
});

final ArticlesState state;
```
## Listen Update with ListenableBuilder

`ListenableBuilder` builds a widget that causes rebuilds when `state`, which is passed to `Listenable` argument, calls `notifyListeners()` method, in other words, its setter of `value` receives another object.
```dart
Widget build(BuildContext context) {
  return ListenableBuilder(
    listenable: state,
    builder: (context, child) => ArticlesContainer(
      state,
      child: widget.child,
    ),
  );
}
```
## Provide of() Method of ArticlesState

Finally, we can access `articles` and update it via `ArticlesState`, so we have to do is to provide `of()` method that returns `ArticlesState` object preserved by `ArticlesContainer`.
```dart
static ArticlesState of(BuildContext context) {
  final widget = context.dependOnInheritedWidgetOfExactType<ArticlesContainer>();
  assert(widget != null, 'No ArticlesContainer found');
  return widget!.state;
}
```
The suitable class that defines the static `of()` method would be `ArticlesProvider` because the detailed implementation can be capsuled and users can just call it by `ArticlesProvider.of(context)` without thinking of what object (`State`, `InheritedWidget,` or some other) they should receive. `ArticlesProvider` is the only interface to use the state.

## User the Refactored State

The usage of the new system is simpler than before.

If we want to observe the state, we can just code like below.
`final articles = ArticlesProvider.of(context).value;`
Or, calling `add()` can be done with the code below.
`ArticlesProvider.of(context).add(newArticle);`
## One More Fix

I’d like to say the refactoring is all done, however, there remains one problem.

Even when we only want to call `add()` method, our `AddArticlePage` would be rebuilt when `ArticlesState` is updated, even though we don’t need it, because `ArticlesProvider.of()` will find `ArticlesContainer` widget using `dependOnInheritedWidgetOfExactType<T>()` which remembers given `context` as what associated widget have to be rebuilt when necessary.

This problem can be solved by switching the method `dependOnInheritedWidgetOfExactType<T>()` and `getInheritedWidgetOfExactType<T>()` by separating `of()` method into `read()` and `watch()`.

```dart
static ArticlesState watch(BuildContext context) {
  final widget =
      context.dependOnInheritedWidgetOfExactType<ArticlesContainer>();
  assert(widget != null, 'No ArticlesContainer found');
  return widget!.state;
}

static ArticlesState read(BuildContext context) {
  final widget = context.getInheritedWidgetOfExactType<ArticlesContainer>();
  assert(widget != null, 'No ArticlesContainer found');
  return widget!.state;
}
```
`getInheritedWidgetOfExactType<T>()` is almost the same as `dependOnInheritedWidgetOfExactType<T>()` in terms of finding the nearest object whose type is `T` on the descendant of the widget tree. One difference is that `getInheritedWidgetOfExactType<T>()` only returns the object and does NOT remember `context` to be rebuilt.

So it’s better to be called this method when we only need to call `add()` method.
Refactoring using `ValueNotifier` and `ListenableBuilder` is all done. You can check the entire changes below.
[Refactoring using valuenotifier and listenablebuilderby chooyan-eng](https://github.com/chooyan-eng/state_management_practice/pull/1/files)
# Reinventing Provider

Finally, we are heading to the step of reinventing `Provider` package, of course, we don’t reinvent the entire package at all but just minimum codes though.

What we are going to do is to abstract `ArticlesProvider` and related classes, considering the situation that we need a similar app state that preserves `List<User>`. There is no doubt that coding similar classes again is too verbose.

## Rename Classes

Our `ArticlesProvider` and related classes are NOT for articles anymore, so let’s rename them into abstract ones. `ArticlesProvider` and `ArticlesProviderState`will become `Provider` and `ProviderState`, `ArticlesContainer` is `Container`, etc.
`class Provider extends StatefulWidget {`
`class ProviderState extends State<Provider> {`
`class StateContainer extends InheritedWidget {`
## Generics for ArticlesState

What to do next for `ArticlesState`? It’s the only concrete class that preserves concrete state `List<Article>` and it can’t be abstracted.

In this case, generic type `T extends ValueNotifier>`is available for abstracting type. In addition, concrete object, such as `ArticlesState` object, should be passed to the constructor of `Provider`.

Note that the type of argument is NOT `T` but `T Function()` because the object itself should not be passed again when `Provider`‘s parent rebuilds. `create` function will be called in `initState()` of `ProviderState` and the result will be preserved in `state` field.

```dart
class Provider<T extends ValueNotifier> extends StatefulWidget {
  const Provider({
    super.key,
    required this.create,
    required this.child,
  });

  final T Function() create;
  final Widget child;
```

```dart
class ProviderState<T extends ValueNotifier> extends State<Provider> {
  late final ValueNotifier state;

  @override
  void initState() {
    super.initState();
    state = widget.create();
  }
```

```dart
class StateContainer<T> extends InheritedWidget {  
const StateContainer(  
this.state, {  
super.key,  
required super.child,  
});  
  
final T state;
```
Using generics, `read()` and `watch()` methods are also changed.
```dart
static T watch<T>(BuildContext context) {
  final widget =
      context.dependOnInheritedWidgetOfExactType<StateContainer<T>>();
  assert(widget != null, 'No ArticlesContainer found');
  return widget!.state;
}

static T read<T>(BuildContext context) {
  final widget = context.getInheritedWidgetOfExactType<StateContainer<T>>();
  assert(widget != null, 'No ArticlesContainer found');
  return widget!.state;
}
```
They no longer return `ArticlesState` but `T` which is returned by `context.dependOnInheritedWidgetOfExactType<StateContainer<T>>()`.

## Usage of Abstracted Provider

Abstracting `Provider` class is done now. So how can we use the class?

The code below is snipped to use our `Provider` class for `ArticlesState`.
```dart
@override
Widget build(BuildContext context) {
  return Provider(
    create: () => ArticlesState(),
    child: const MaterialApp(
      home: ArticlesPage(),
    ),
  );
}

```
`final articles = Provider.watch<ArticlesState>(context).value;`
`Provider.read<ArticlesState>(context).add(newArticle);`

You will soon find that its interface is surprisingly similar to that of `Provider` package, isn’t it? `Provider` package, of course, does more and more things considering various situations and error handling, but we can say that the basic (really basic) concept can be reinvented with only tens of lines of code only using the fundamental classes of the Flutter framework.

That’s it! I believe you can hot-restart the project to confirm our app works fine.
You can check the entire diffs in the PR below.
[Abstract provider #2](https://github.com/chooyan-eng/state_management_practice/pull/2?source=post_page-----4c833e37a636--------------------------------)
# One More Bonus and Conclusion

You may know that `Provider` package doesn’t support multiple providers of the same type. It is because of the limitation of `dependOnInheritedWidgetOfExactType<T>()`.

As mentioned before, `dependOnInheritedWidgetOfExactType<T>()` would find **the** **nearest ancestor** `**InheritedWidget**` whose type is `T` on the widget tree. Thus, even if we have multiple objects `T` on the widget tree, what we can get is only “the nearest” one.

It’s not the problem of `Provider` but of Flutter framework itself. In other words, `Provider` package can’t solve it as long as wrapping `InheritedWidget`. That is one of the reasons that “reimplementation of `InheritedWidget`” is required as`Riverpod` package.

We hardly use `InheritedWidget` as is and even `Provider` package is not encouraged to use anymore. But we found one of the reasons why `Riverpod` package has to be built, based on the knowledge of the Flutter framework underhood.

Discussions in this article would also help us understand how other state management packages work and what package we should use and how.

Thank you for reading this long and boring article. I’ll finish it by introducing a package named `Providable`, which I made `Provider` class, explained above, a package published as a GitHub repository.
[chooyan-eng-providable](https://github.com/chooyan-eng/providable)











