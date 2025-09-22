[source](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)

When building complex apps, choosing the correct **app architecture** is crucial, as it allows you to **structure** your code and support your codebase as it grows.

Good architecture should help you **handle complexity without getting in the way**. But it's not easy to get it right:

- “Not enough” architecture leads to poorly organized code that lacks clear conventions
- “Too much” of it leads to over-engineering, making it hard to make even simple changes

In practice, things can be quite nuanced, and it can be tricky to get the right balance.

So in this article, I’m sharing a new reference architecture that you can use to:

- **ensure a good separation of concerns** between your **UI code** (1), your **business logic** (2), and your **data access logic** (3)
- **easily fetch and cache data** with minimal boilerplate code
- **perform data mutations** while handling the UI states (data, loading, error) in a predictable way
- **write testable code** and mock dependencies in a breeze

This architecture leans heavily on the Riverpod package, making the most of its **reactive caching** and **data-binding** features.

**But why do we need a reference architecture in the first place?**

## [Riverpod is not very opinionated](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/#riverpod-is-not-very-opinionated)

Riverpod is great. I use it in all my apps and [have written many tutorials about it](https://codewithandrea.com/tags/riverpod/) - but the official docs don’t offer any guidance about how to structure your code.

As a result, you’re on your own when it comes to making important decisions such as:

- How to separate your UI code from your business logic and the data access logic?
- Which classes should you write? What are their responsibilities? And how do they communicate with each other?
- How do you make your code more scalable - so that different team members can work on multiple features independently?
- How should you organize your files?
- What about error handling? Where should it take place, and how should errors propagate to the UI?
- Which providers should you use, and where should they be declared?

These decisions matter. And if you leave them to chance, you’ll end up with performance problems, bugs, and ongoing maintenance issues that will affect your development speed.

And this is where having a very opinionated app architecture makes all the difference. 👇

## [Riverpod + Reference App Architecture = 👌](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/#riverpod-+-reference-app-architecture-=-%F0%9F%91%8C)

While building Flutter apps of varying complexity, I've experimented a lot with app architecture and developed a deep understanding of what works well and what doesn't.

The result is a **reference architecture** that I've used in all my latest projects.

> For lack of a better name, I'll call this Riverpod Architecture - though keep in mind that this is just my take on it and not an "official" architecture endorsed by Remi Rousselet (the author of Riverpod).

This architecture comprises four layers (**data**, **domain**, **application**, and **presentation**).

Here's a preview:
![[Pasted image 20240527090804.png]]
Each of these layers has its own responsibility, and there's a **clear contract** for how communication happens across boundaries.

So let’s take a closer look at each layer. 👇

> Since there is much to cover, this article only includes a conceptual, high-level overview of the four layers. Below you’ll find links to separate articles covering each layer in more detail.

### [The Presentation Layer](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/#the-presentation-layer)

This is often called the UI layer. And [this guide about Android app architecture](https://developer.android.com/topic/architecture/ui-layer) describes it well:

> The role of the UI is to display the application data on the screen and also to serve as the primary point of user interaction. Whenever the data changes, either due to user interaction (like pressing a button) or external input (like a network response), the UI should update to reflect those changes. _Effectively, the UI is a visual representation of the application state as retrieved from the data layer._

In our architecture, the presentation layer contains two main types of components:

- **Widgets**, which are a representation of the data to be displayed on screen.
- **Controllers**, which perform asynchronous data mutations and manage the widget state.
The controllers themselves are usually represented as [`AsyncNotifier` subclasses](https://codewithandrea.com/articles/flutter-riverpod-async-notifier/), and I’ve covered them in detail in this separate article:

- [Flutter App Architecture: The Presentation Layer](https://codewithandrea.com/articles/flutter-presentation-layer/)

### [The Domain Layer](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/#the-domain-layer)

The primary role of the domain layer is to define **application-specific model classes** that represent the data that comes from the data layer.

**Model classes are simple data classes** and have the following requirements:

- They are always immutable.
- They contain serialization logic (such as `fromJson` and `toJson` methods).
- They implement the `==` operator and the `hashCode` method.

Model classes may depend on other model classes (e.g. a `ShoppingCart` class may contain a list of `Products`). But they don’t know where to get the data from and have no other dependencies. As such, model classes can be imported and used everywhere else in your app (widgets, controllers, services, repositories).

> To more easily define the properties and methods in your data classes, you can use packages such as [Freezed](https://pub.dev/packages/freezed) and [Equatable](https://pub.dev/packages/equatable), or tools such as the [Dart Data Class Generator](https://marketplace.visualstudio.com/items?itemName=hzgood.dart-data-class-generator).

To learn more about the domain layer and model classes, read this:

- [Flutter App Architecture: The Domain Model](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/)

### [The Data Layer](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/#the-data-layer)

The data layer contains three types of classes:

- **Data Sources**, which are 3rd party APIs used to communicate with the outside world (e.g. a remote database, a REST API client, a push notification system, a Bluetooth interface).
- **Data Transfer Objects** (or DTOs), which are returned by the data sources. DTOs are often represented as unstructured data (such as JSON) when sending data over the network
- **Repositories**, which are used to access DTOs from various sources, such as a backend API, and make them available as type-safe **model classes** (a.k.a. entities) to the rest of the app.
Note that both data sources and DTOs are **external dependencies.** To use them, you import packages into your app and **consume** their APIs.

On the other hand, repositories are classes that live in your codebase, so it's your job to implement them and **design** their API.

> If your Flutter app talks to a local or remote database, that database is the [**single source of truth**](https://en.wikipedia.org/wiki/Single_source_of_truth) for your data. As far as your app is concerned, **repositories are the gateway** to that source of truth. This app architecture accounts for this by implementing an **unidirectional data flow** from the data layer all the way into the UI.

To learn more about repositories and the data layer, read this:

- [Flutter App Architecture: The Repository Pattern](https://codewithandrea.com/articles/flutter-repository-pattern/)

### [The Application Layer](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/#the-application-layer)

When building complex apps, we may find ourselves writing logic that:

- depends on multiple data sources or repositories
- needs to be used (shared) by more than one widget

In this case, it's tempting to put that logic inside the classes we already have (controllers or repositories).

But this leads to poor separation of concerns, making our code harder to read, maintain, and test.

To address this, we can introduce a new, **optional** layer called the application layer. Inside it, we can add service classes, which act as the middle-man between the controllers (which only manage the widget state) and the repositories (which talk to different data sources).

Here’s an example showing a `CartService` class that mediates between controllers and repositories:
![[Pasted image 20240527090920.png]]
## [Wrap Up](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/#wrap-up)

So far, we’ve learned about the four main layers in my Riverpod architecture and the classes inside them (widgets, controllers, models, services, repositories, data sources).

**But how do all these different classes interact with each other**, and how can we use them to build **working features** in our apps?

This is where Riverpod and all its useful providers come in. And when building mobile apps, most of the work we do boils down to two things:

- Fetch data and show it in the UI
- Perform data mutations in response to input events

To learn more about this, you can read this follow-up article:

- [How to Fetch Data and Perform Data Mutations with the Riverpod Architecture](https://codewithandrea.com/articles/data-mutations-riverpod/)

### [Where to go from here?](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/#where-to-go-from-here?)

If you need help choosing the most appropriate project structure for your Flutter apps, I’ve got you covered:

- [Flutter Project Structure: Feature-first or Layer-first?](https://codewithandrea.com/articles/flutter-project-structure/)

If you want to explore other popular architectures (such as MVP, MVVM, or Clean Architecture) and understand how they compare with the architecture proposed here, read this:

- [A Comparison of Popular Flutter App Architectures](https://codewithandrea.com/articles/comparison-flutter-app-architectures/)

To learn more about each of the four layers in the Riverpod architecture, read the other articles in this series:

- [Flutter App Architecture: The Repository Pattern](https://codewithandrea.com/articles/flutter-repository-pattern/)
- [Flutter App Architecture: The Domain Model](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/)
- [Flutter App Architecture: The Presentation Layer](https://codewithandrea.com/articles/flutter-presentation-layer/)
- [Flutter App Architecture: The Application Layer](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/)
-----------------------------------------
[Source](https://codewithandrea.com/articles/flutter-project-structure/)
## [Feature-first (layers inside features)](https://codewithandrea.com/articles/flutter-project-structure/#feature-first-layers-inside-features)

The feature-first approach demands that we create a new folder for every new feature that we add to our app. And inside that folder, we can add the layers themselves as sub-folders.

I find this approach more logical because we can easily see all the files that belong to a certain feature, grouped by layer.

In comparison to the layer-first approach, there are some advantages:

- whenever we want to add a new feature or modify an existing one, we can focus on just one folder.
- if we want to delete a feature, there's only one folder to remove (two if we count the corresponding `tests` folder)

So it would appear that the **feature-first** approach wins hands down! 🙌

However, things are not so easy in the real world.

## [What about shared code?](https://codewithandrea.com/articles/flutter-project-structure/#what-about-shared-code?)

Of course, when building real apps you'll find that your code doesn't always fit neatly into specific folders as you intended.

What if two or more separate features need to share some widgets or model classes?

In these cases, it's easy to end up with folders called `shared` or `common`, or `utils`.

But how should these folders themselves be organized? And how do you prevent them from becoming a dumping ground for all sorts of files?

If your app has 20 features and has some code that needs to be shared by only two of them, should it really belong to a top-level `shared` folder?

What if it's shared among 5 features? Or 10?

In this scenario, there is no right or wrong answer, and you have to use your best judgement on a case-by-case basis.

---

Aside from this, there is a very common mistake that we should avoid.

## [Feature-first is not about the UI!](https://codewithandrea.com/articles/flutter-project-structure/#feature-first-is-not-about-the-ui!)

When we focus on the UI, we're likely to think of a feature **as a single page** or screen in the app.

I made this mistake myself while building the eCommerce app
## [What is a "feature"?](https://codewithandrea.com/articles/flutter-project-structure/#what-is-a-feature?)

So I took a step back and asked myself: "what is a feature"?

And I realized it's not about what the user **sees**, but what the user **does**:

- authenticate
- manage the shopping cart
- checkout
- view all past orders
- leave a review

In other words, a feature is a **functional requirement** that helps the user **complete a given task**.

And taking some hints from **domain-driven design**, I decided to organize the project structure around the **domain layer**.

Once I figured that out, everything fell into place. And I ended up with seven functional areas:
![[Pasted image 20240527094748.png]]
Note that with this approach is still possible for code inside a given feature to depend on code **from a different feature**. For example:

- the product page shows a list of **reviews**
- the orders page shows some **product** information
- the checkout flow requires the user to **authenticate** first

But we end up with far fewer files that are shared **across all features**, and the entire structure is much more **balanced**

## [How to do feature-first, the right way](https://codewithandrea.com/articles/flutter-project-structure/#how-to-do-feature-first-the-right-way)

In summary, the feature-first approach lets us structure our project around the **functional requirements** of our app.

So here's how to use this correctly in your own apps:

- start from the **domain layer** and identify the model classes and business logic for manipulating them
- create a folder for each model (or group of models) that **belong together**
- within that folder, create the `presentation`, `application`, `domain`, `data` sub-folders as needed
- inside each sub-folder, add all the files you need

>When building Flutter apps, it's very common to have a ratio of 5:1 (or more) between UI code and business logic. If your `presentation` folder ends up with many files, don't be afraid to group them into sub-folders that represent smaller "sub-features".

For reference, here's how my final project structure ended up:
![[Pasted image 20240527095059.png]]
Without even looking inside folders such as `common_widgets`, `constants`, `exceptions`, `localization`, `routing`, and `utils`, we can guess that they all contain code that is **truly shared** across features, or needs to be **centralized** for a good reason (such as localization and routing).

And these folders all contain relatively little code.

## [Bonus: the test folder](https://codewithandrea.com/articles/flutter-project-structure/#bonus-the-test-folder)

I haven't talked about this until now. But it makes a lot of sense for the `test` folder to follow the same project structure as the `lib` folder.

And this is very easy to do by using the "Go to Tests" option in VSCode:

![[Pasted image 20240527095147.png]]
## [Conclusion](https://codewithandrea.com/articles/flutter-project-structure/#conclusion)

When done right, going **feature-first** has many benefits over **layer-first**.

Having built a [medium-sized eCommerce app](https://codewithandrea.com/courses/complete-flutter-bundle/) of 10K LOC with it, I'm confident that this is a scalable approach that should work well for bigger codebases.

Of course, when building very large apps we will face additional constraints. And at some point, we may need to mix and match different approaches, or even break up the codebase into multiple packages that live in a single monorepo.

But if we apply **domain-driven design** from the start, we'll end up with clear boundaries between the different layers and components of our app. And this will make dependencies more manageable later on.

And if you want to learn more about app architecture and the role of each individual layer, check the other articles in this series:

- [Flutter App Architecture with Riverpod: An Introduction](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)
- [Flutter App Architecture: The Repository Pattern](https://codewithandrea.com/articles/flutter-repository-pattern/)
- [Flutter App Architecture: The Domain Model](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/)
- [Flutter App Architecture: The Application Layer](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/)
- [Flutter App Architecture: The Presentation Layer](https://codewithandrea.com/articles/flutter-presentation-layer/)
--------------------------------
# [Repository pattern](https://codewithandrea.com/articles/flutter-repository-pattern/)

![[Pasted image 20240527103527.png]]
In this context, repositories are found in the **data layer**. And their job is to:

- isolate domain models (or **entities**) from the implementation details of the data sources in the **data layer**.
- convert **data transfer objects** to validated entities that are understood by the **domain layer**
- (optionally) perform operations such as **data caching**.

> The diagram above shows just one of many possible ways of architecting your app. Things will look different if you follow a different architecture such as MVC, MVVM, or Clean Architecture, but the same concepts apply.

Also note how the widgets belong to the **presentation layer**, which has nothing to do with business logic or networking code.

> If your widgets work **directly** with key-value pairs from a REST API or a remote database, **you're doing it wrong**. In other words: **do not mix business logic with your UI code**. This will make your code much harder to test, debug, and reason about.

## [When to use the repository pattern?](https://codewithandrea.com/articles/flutter-repository-pattern/#when-to-use-the-repository-pattern?)

The repository pattern is very handy if your app has a **complex data layer** with many different endpoints that return **unstructured data** (such as JSON) that you want to isolate from the rest of the app.

More broadly, here are a few use cases where I feel the repository pattern is most appropriate:

- talking to REST APIs
- talking to local or remote databases (e.g. Sembast, Hive, Firestore, etc.)
- talking to device-specific APIs (e.g. permissions, camera, location, etc.)

One great benefit of this approach is that **if there are breaking changes in any 3rd party APIs you use, you'll only have to update your repository code**.

And that alone makes repositories 100% worth it. 💯

## [The repository pattern in practice](https://codewithandrea.com/articles/flutter-repository-pattern/#the-repository-pattern-in-practice)

As an example, I've built a simple Flutter app (here's the [source code](https://github.com/bizz84/open_weather_example_flutter)) that pulls weather data from the [OpenWeatherMap API](https://openweathermap.org/api).

By reading the [API docs](https://openweathermap.org/current), we can find out how to call the API, along with some examples of response data in JSON format.

And the repository pattern is great for **abstracting away** all the networking and JSON serialization code.

For example, here's an abstract class that defines the **interface** for our repository:
```dart
abstract class WeatherRepository { Future<Weather> getWeather({required String city}); }
```
The `WeatherRepository` above has only one method, but there could be more (for example, if you wanted to support all the CRUD operations).

What matters is that the repository allows us to **define a contract** for how to retrieve the weather for a given city.

And we need to **implement** the `WeatherRepository` with a concrete class that makes the necessary API calls using a networking client such as [http](https://pub.dev/packages/http) or [dio](https://pub.dev/packages/dio):
```dart
import 'package:http/http.dart' as http;

class HttpWeatherRepository implements WeatherRepository {
  HttpWeatherRepository({required this.api, required this.client});
  // custom class defining all the API details
  final OpenWeatherMapAPI api;
  // client for making calls to the API
  final http.Client client;

  // implements the method in the abstract class
  Future<Weather> getWeather({required String city}) {
    // TODO: send request, parse response, return Weather object or throw error
  }
}
```

All these implementation details are concerns of the **data layer**, and the rest of the app shouldn't care or even know about them.
### [Parsing the JSON data](https://codewithandrea.com/articles/flutter-repository-pattern/#parsing-the-json-data)

Of course, we'll also have to define a `Weather` model class (or **entity**), along with the JSON serialization code for parsing the API response data:
```dart
class Weather {
  // TODO: declare all the properties we need
  factory Weather.fromJson(Map<String, dynamic> json) {
    // TODO: parse JSON and return validated Weather object
  }
}
```
Note that while the JSON response may contain many different fields, we **only** need to parse the ones that will be used in the UI.
>We can write the JSON parsing code by hand or use a code generation package such as [Freezed](https://pub.dev/packages/freezed). To learn more about JSON serialization, see my [essential guide about JSON parsing in Dart](https://codewithandrea.com/articles/parse-json-dart/).

### [Initializing repositories in the app](https://codewithandrea.com/articles/flutter-repository-pattern/#initializing-repositories-in-the-app)

Once we have defined a repository, we need a way to initialize it and make it accessible to the rest of the app.

The syntax for doing this changes depending on your DI/state management solution of choice.

Here's an example using [get_it](https://pub.dev/packages/get_it):
```dart
import 'package:get_it/get_it.dart';

GetIt.instance.registerLazySingleton<WeatherRepository>(
  () => HttpWeatherRepository(api: OpenWeatherMapAPI(), client: http.Client(),
);
```
Here's another using a provider from the [Riverpod](https://pub.dev/packages/riverpod) package:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return HttpWeatherRepository(api: OpenWeatherMapAPI(), client: http.Client());
});
```
The bottom line is the same: once you've initialized your repository, you can access it anywhere else in your app (widgets, blocs, controllers, etc.).

## [Abstract or concrete classes?](https://codewithandrea.com/articles/flutter-repository-pattern/#abstract-or-concrete-classes?)

One common question when creating repositories is this: **do you really need an abstract class**, or can you just create a concrete class and do away with all the ceremony?

This is a very valid concern since adding more and more methods across two classes can become quite tedious:

```dart
abstract class WeatherRepository {
  Future<Weather> getWeather({required String city});
  Future<Forecast> getHourlyForecast({required String city});
  Future<Forecast> getDailyForecast({required String city});
  // and so on
}

class HttpWeatherRepository implements WeatherRepository {
  HttpWeatherRepository({required this.api, required this.client});
  // custom class defining all the API details
  final OpenWeatherMapAPI api;
  // client for making calls to the API
  final http.Client client;

  Future<Weather> getWeather({required String city}) { ... }
  Future<Forecast> getHourlyForecast({required String city}) { ... }
  Future<Forecast> getDailyForecast({required String city}) { ... }
  // and so on
}
```
As is often the case in software design, the answer is: **it depends**.

So let's take look at some pros and cons of each approach.

### [Using abstract classes](https://codewithandrea.com/articles/flutter-repository-pattern/#using-abstract-classes)

- **Pro**: it's nice to see the interface of our repository in one place, without all the clutter.
- **Pro**: we can swap the repository with a completely different implementation (e.g. `DioWeatherRepository` rather than `HttpWeatherRepository`), and change just one line in the initialization code, because the rest of the app only knows about `WeatherRepository`.
- **Con**: VSCode will get a bit confused when we "jump to reference" and take us to the method definition in the abstract class, rather than the implementation in the concrete class.
- **Con**: More boilerplate code.
## [Writing tests with repositories](https://codewithandrea.com/articles/flutter-repository-pattern/#writing-tests-with-repositories)

One common requirement during testing is to swap out the networking code with a mock or "fake" so that our tests run faster and more reliably.

However, abstract classes don't give us any advantage here, because in Dart **all classes have an implicit interface**.

This means that we can do this:
```dart
// note: in Dart we can always implement a concrete class
class FakeWeatherRepository implements HttpWeatherRepository {

  // just a fake implementation that returns a value immediately
  Future<Weather> getWeather({required String city}) { 
    return Future.value(Weather(...));
  }
}
```
In other words, there's **no need to create abstract classes** if we intend to mock our repositories in the tests.

In fact, packages like [mocktail](https://pub.dev/packages/mocktail) use this to their advantage and we can use them like so:
```dart
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements HttpWeatherRepository {}

final mockWeatherRepository = MockWeatherRepository();
when(() => mockWeatherRepository.getWeather('London'))
          .thenAnswer((_) => Future.value(Weather(...)));
```
### [Mocking the data source](https://codewithandrea.com/articles/flutter-repository-pattern/#mocking-the-data-source)

As you write your tests, you can mock your repositores and return canned responses like we did above.

But there's another option, and that is to **mock the underlying data source**.

In this case, we can choose to mock the `http.Client` object that is passed to the `HttpWeatherRepository` constructor. Here's an example test showing of how you may do this:
```dart
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  test('repository with mocked http client', () async {
    // setup
    final mockHttpClient = MockHttpClient();
    final api = OpenWeatherMapAPI();
    final weatherRepository =
        HttpWeatherRepository(api: api, client: mockHttpClient);
    when(() => mockHttpClient.get(api.weather('London')))
        .thenAnswer((_) => Future.value(/* some valid http.Response */));
    // run
    final weather = await weatherRepository.getWeather(city: 'London');
    // verify
    expect(weather, Weather(...));
  });
}
```
In the end, you can choose if you want to **mock the repository itself** or the **underlying data source**, depending on what you're trying to test.

Having figured out how to test repositories, let's get back to our initial question about abstract classes.
## [Repositories scale horizontally](https://codewithandrea.com/articles/flutter-repository-pattern/#repositories-scale-horizontally)

As your application grows, you may find yourself adding more and more methods to a given repository.

This is likely to happen if your backend has a **large API surface**, or if your app connects to many different data sources.

In this scenario, consider creating multiple repositories, keeping related methods together. For example, if you're building an eCommerce app, you could have separate repositories for product listings, shopping cart, orders management, authentication, checkout, etc.
## [Keep it Simple](https://codewithandrea.com/articles/flutter-repository-pattern/#keep-it-simple)

As usual, keeping things simple is always a good idea. So don't get too wound up overthinking your APIs.

You can model your repository's interface after the API that you need to use, and call it a day. You can always refactor later if needed. 👍
## [Conclusion](https://codewithandrea.com/articles/flutter-repository-pattern/#conclusion)

If there's one thing I'd like you to take away from this article, it would be this:

> Use the repository pattern to hide away all the implementation details (e.g. JSON serialization) of your data layer. As a result, the rest of your app (domain and presentation layer) can deal directly with **type-safe** model classes/entities. And your codebase will also become more resilient to breaking changes in packages you depend on.

If anything, I hope this overview has encouraged you to think more clearly about app architecture and the importance of having separate **presentation**, **application**, **domain**, and **data** layers, with clear boundaries.

------------------------------------------------
[Domain model pattern](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/)
## [What is a Domain Model?](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/#what-is-a-domain-model?)

Wikipedia defines the domain model like this:

> The domain model is a **conceptual model of the domain that incorporates both behavior and data**.

The **data** can be represented by a set of **entities** along with their **relationships**, while the **behavior** is encoded by some **business logic** for manipulating those entities.

Using an eCommerce application as an example, we could identify the following entities:

- **User**: ID and email
- **Product**: ID, image URL, title, price, available quantity etc.
- **Item**: Product ID and quantity
- **Cart**: List of items, total
- **Order**: List of items, price paid, status, payment details etc.
![[Pasted image 20240527105928.png]]
>When practicing DDD, entities and relationships are not something we produce out of thin air, but rather the end result of a (sometimes long) knowledge discovery process. As part of the process, a domain **vocabulary** is also formalized and used by all parties.

Note how at this stage we are not concerned about where these entities come from or how they are passed around in the system.

What's important is that our entities are at the **heart** of our system, because we need them to solve domain-related problems for our users.

> In DDD, a distinction is often made between **entities** and **value objects**. For more info, see this thread about [Value vs Entity objects on StackOverflow](https://stackoverflow.com/questions/75446/value-vs-entity-objects-domain-driven-design).

Of course, once we start building our app we need to implement those entities and decide where they fit within our architecture.

And this is where the domain layer comes in.

> Going forward, we will refer to entities as **models** that can be implemented as simple classes in Dart.

## [The Domain Layer](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/#the-domain-layer)
 the models belong to the domain layer. They are retrieved by the repositories in the data layer below, and can be modified by the services in the application layer above.
 ![[Pasted image 20240527111038.png]]
 So how do these models look like in Dart?

Well, let's consider a `Product` model class for example:
```dart
/// The ProductID is an important concept in our domain
/// so it deserves a type of its own
typedef ProductID = String;

class Product {
  Product({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.availableQuantity,
  });

  final ProductID id;
  final String imageUrl;
  final String title;
  final double price;
  final int availableQuantity;

  // serialization code
  factory Product.fromMap(Map<String, dynamic> map, ProductID id) {
    ...
  }

  Map<String, dynamic> toMap() {
    ...
  }
}
```
At a very minimum, this class holds all the properties that we need to show in the UI:
![[Pasted image 20240527111159.png]]
And it also contains `fromMap()` and `toMap()` methods that are used for serialization.

> There are various ways to define model classes and their serialization logic in Dart. For more info, see my [essential guide to JSON parsing in Dart](https://codewithandrea.com/articles/parse-json-dart/) and the follow up article about [code generation using Freezed](https://codewithandrea.com/articles/parse-json-dart-codegen-freezed/).

Note how the `Product` model is a **simple data classes** that doesn't have access to repositories, services, or other objects that belong **outside** the domain layer.

## [Business logic in the Model classes](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/#business-logic-in-the-model-classes)

Model classes can however include some business logic to express how they are meant to be modified.

To illustrate this, let's consider a `Cart` model class instead:

```dart
class Cart {
  const Cart([this.items = const {}]);
  /// All the items in the shopping cart, where:
  /// - key: product ID
  /// - value: quantity
  final Map<ProductID, int> items;

  factory Cart.fromMap(Map<String, dynamic> map) { ... }
  Map<String, dynamic> toMap() { ... }
}
```

This is implemented as a map of key-value pairs representing the product IDs and quantities of the items that we have added to the shopping cart.

And since we can add and remove items from the cart, it may be useful to define an **extension** that makes this task easier:

```dart
/// Helper extension used to update the items in the shopping cart.
extension MutableCart on Cart {
  Cart addItem({required ProductID productId, required int quantity}) {
    final copy = Map<ProductID, int>.from(items);
    // * update item quantity. Read this for more details:
    // * https://codewithandrea.com/tips/dart-map-update-method/
    copy[productId] = quantity + (copy[productId] ?? 0);
    return Cart(copy);
  }

  Cart removeItemById(ProductID productId) {
    final copy = Map<ProductID, int>.from(items);
    copy.remove(productId);
    return Cart(copy);
  }
}
```
The methods above make a copy of the items in the cart (using `Map.from()`), modify the values inside, and return a new immutable `Cart` object that can be used to update the underlying data store (via the corresponding repository).

> If you're not familiar with the syntax above, read: [How to update a Map of key-value pairs in Dart](https://codewithandrea.com/tips/dart-map-update-method/).

> Many state management solutions rely on **immutable objects** in order to propagate state changes and ensure that our widgets rebuild only when they should. The rule is that when we need to mutate state in our models, we should do so by making a new, **immutable copy**.

## [Testing the Business Logic inside our Models](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/#testing-the-business-logic-inside-our-models)

Note how the `Cart` class and its `MutableCart` extension don't have dependencies to any objects that live **outside** the domain layer.

This makes them very easy to test.

To prove this point, here's a set of unit tests that we can write to verify the logic in the `addItem()` method:
```dart
void main() {

  group('add item', () {

    test('empty cart - add item', () {
      final cart = const Cart()
          .addItem(productId: '1', quantity: 1);
      expect(cart.items, {'1': 1});
    });

    test('empty cart - add two items', () {
      final cart = const Cart()
          .addItem(productId: '1', quantity: 1)
          .addItem(productId: '2', quantity: 1);
      expect(cart.items, {
        '1': 1,
        '2': 1,
      });
    });

    test('empty cart - add same item twice', () {
      final cart = const Cart()
          .addItem(productId: '1', quantity: 1)
          .addItem(productId: '1', quantity: 1);
      expect(cart.items, {'1': 2});
    });
  });
}
```
Writing unit tests for our business logic is not only easy, but **adds a lot of value**.

If our business logic is incorrect, we are **guaranteed** to have bugs in our app. So we have every incentive to make it easy to test, by ensuring our model classes don't have any dependencies.
## [Conclusion](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/#conclusion)

We have discussed the importance of having a good **mental model** of our system.

We've also seen how to represent our models/entities as **immutable** data classes in Dart, along with any business logic we may need to modify them.

And we've seen how to write some simple unit tests for that business logic, without resorting to mocks or any complex test setup.

Here are some tips you may use as you design and build your apps:

- explore the domain model and figure out what **concepts** and **behaviors** you need to represent
- express those concepts as **entities** along with their **relationships**
- implement the corresponding Dart model classes
- translate the behaviors into working code (business logic) that operates on those model classes
- add unit tests to verify the behaviors are implemented correctly

As you do that, think about what data you need to show in the UI and how the user will interact with it.

But don't worry about how things connect together just yet. In fact, it's the job of the **services** in the **application layer** to work with the models by mediating between the repositories in the data layer and the controllers in the presentation layer.

----------
# [Application-layer-pattern](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/)
 In this article, we're going to focus on the **application layer** and learn how to implement a **shopping cart feature** for an eCommerce app in Flutter.

We'll start with a conceptual overview of this feature, to see how everything fits together at a high level.

And then, we'll dive into some implementation details and implement a `CartService` class that depends on multiple repositories.

We'll also learn to easily manage multiple dependencies with Riverpod (using [`Ref`](https://pub.dev/documentation/riverpod/latest/riverpod/Ref-class.html) inside a service class).
## [Shopping Cart: UI Overview](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#shopping-cart-ui-overview)

Let's consider some example UI we may use to implement a shopping cart feature.

At a very minimum, we need a product page:
![[Pasted image 20240527112346.png]]
*This page lets us **select the desired quantity** (1) and **add the product to the cart** (2). On the top right corner, we also find a shopping cart icon with a badge telling us how many items are in the cart.*
We also need a shopping cart page:
![[Pasted image 20240527112427.png]]
*This page lets us **edit the quantity** or **remove items** from the cart.*
### [Multiple widgets, shared logic?](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#multiple-widgets-shared-logic?)

As we can already see, there are **multiple** widgets (each page is a widget itself) that need access to the shopping cart data to show the correct UI.

In other words, the shopping cart items (and the logic for updating them) need to be **shared** across multiple widgets.

To make things even more interesting, let's add one more requirement.
## [Adding items as a guest or logged-in user](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#adding-items-as-a-guest-or-logged-in-user)

eCommerce sites such as Amazon or eBay will let you add items to the shopping cart **before creating an account**.

This way, you can freely search the product catalog as a guest and only sign in or register when you proceed to checkout.

So how can we replicate the same functionality in our example app?

One way to do it is to have **two shopping carts**:

- a **local** shopping cart used by guests
- a **remote** shopping cart used by signed-in users

With this setup, we can add an item to the correct cart with this logic:
```

if user is signed in, then
    add item to remote cart
else
    add item to local cart
```
What this means in practice is that we need **three repositories** to make things work:

- an **auth** repository, used to sign in and sign out
- a **local cart** repository, used by guest users (backed by local storage)
- a **remote cart** repository, used by authenticated users (backed by a remote database)
### [Shopping Cart: Full Requirements](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#shopping-cart-full-requirements)

In summary, we need to be able to:

- add items to the cart as a guest or authenticated user (using different repositories)
- do so from different widgets/pages

But where should all this logic go?
## [The Application Layer](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#the-application-layer)

In this scenario, the best way to keep our code organized is to introduce an **application layer** that contains a `CartService` to hold all our logic:
As we can see, the `CartService` acts as a middle-man between the controllers (which only manage the widget state) and the repositories (which talk to different data sources).

The `CartService` is **not** concerned about:

- managing and updating the widget state (that's the job of the controller)
- data parsing and serialization (that's the job of the repositories)

All it does is to implement application-specific logic by accessing the relevant repositories as needed.

>Note: other common architectures based on MVC or MVVM keep this application-specific logic (along with the data-layer code) in the model class itself. However, this can lead to models that contain too much code and are difficult to maintain. By creating repositories and services as needed, we get a much better separation of concerns.

And now that we have a clear picture of what we're trying to do, let's implement all the relevant code.

## [Shopping Cart Implementation](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#shopping-cart-implementation)

Our goal is to figure out how to implement the `CartService` class.

Since this depends on multiple data models and repositories, let's define those first.

### [The Cart Data Model](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#the-cart-data-model)

In essence, a shopping cart is a collection of items identified by a product ID and a quantity.

We could implement this using a **list**, a **map**, or even a **set**. What I found works best is to create a class that contains a map of values:
```dart
class Cart {
  const Cart([this.items = const {}]);

  /// All the items in the shopping cart, where:
  /// - key: product ID
  /// - value: quantity
  final Map<ProductID, int> items;
  /// Note: ProductID is just a String
}
```

Since we want the `Cart` class to be **immutable** (to prevent widgets from mutating its state), we can define an **extension** with some methods that modify the current cart, and return a **new** `Cart` object:
```dart

/// Helper extension used to mutate the items in the shopping cart.
extension MutableCart on Cart {
  // implementations omitted for brevity
  Cart addItem(Item item) { ... }
  Cart setItem(Item item) { ... }
  Cart removeItemById(ProductID productId) { ... }
}
```
We can also define an `Item` class that holds the product ID and quantity as a single entity:
```dart
/// A product along with a quantity that can be added to an order/cart
class Item {
  const Item({
    required this.productId,
    required this.quantity,
  });
  final ProductID productId;
  final int quantity;
}
```
### [The Auth and Cart Repositories](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#the-auth-and-cart-repositories)

As discussed, we need an auth repository that we can use to check if we have a signed-in user:
```dart
abstract class AuthRepository {  
  /// returns null if the user is not signed in
  AppUser? get currentUser;

  /// useful to watch auth state changes in realtime
  Stream<AppUser?> authStateChanges();

  // other sign in methods
}
```
When we're using the app as a guest, we can use a `LocalCartRepository` to get and set the cart value:
```dart
abstract class LocalCartRepository {
  // get the cart value (read-once)
  Future<Cart> fetchCart();

  // get the cart value (realtime updates)
  Stream<Cart> watchCart();

  // set the cart value
  Future<void> setCart(Cart cart);
}
```
>The `LocalCartRepository` class can be subclassed and implemented using local storage (with packages such as [Sembast](https://pub.dev/packages/sembast), [ObjectBox](https://pub.dev/packages/objectbox), or [Isar](https://pub.dev/packages/isar)).

And if we're signed in, we can use a `RemoteCartRepository` instead:
```dart
abstract class RemoteCartRepository {
  // get the cart value (read-once)
  Future<Cart> fetchCart(String uid);

  // get the cart value (realtime updates)
  Stream<Cart> watchCart(String uid);

  // set the cart value
  Future<void> setCart(String uid, Cart items);
}
```
> This class is very similar to the `LocalCartRepository`, with one fundamental difference: all methods take a `uid` argument since each authenticated user will have his/her own shopping cart.

If we use Riverpod, we also need to define a provider for each of these repositories:
```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});

final localCartRepositoryProvider = Provider<LocalCartRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});

final remoteCartRepositoryProvider = Provider<RemoteCartRepository>((ref) {
  // This should be overridden in main file
  throw UnimplementedError();
});
```
> Note how all these providers throw an `UnimplementedError`, since we have defined the repositories as **abstract classes**. If you only use **concrete classes**, you can instantiate and return them directly instead. For more info on this, read [this note about abstract or concrete classes](https://codewithandrea.com/articles/flutter-repository-pattern/#abstract-or-concrete-classes) in my article about [Flutter App Architecture: The Repository Pattern](https://codewithandrea.com/articles/flutter-repository-pattern/).

And now that both data models and repositories are out of the way, let's focus on the service class.
## [The CartService class](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#the-cartservice-class)
 The `CartService` class **depends** on three separate repositories:
 ![[Pasted image 20240527122410.png]]
 So we could declare them as `final` properties and pass them as constructor arguments:

```dart
class CartService {
  CartService({
    required this.authRepository,
    required this.localCartRepository,
    required this.remoteCartRepository,
  });
  final AuthRepository authRepository;
  final LocalCartRepository localCartRepository;
  final RemoteCartRepository remoteCartRepository;
  // TODO: implement methods using these repositories
```
Along the same lines, we could define the corresponding provider:

```dart
final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(
    authRepository: ref.watch(authRepositoryProvider),
    localCartRepository: ref.watch(localCartRepositoryProvider),
    remoteCartRepository: ref.watch(remoteCartRepositoryProvider),
  );
});
```
This works and it makes all the dependencies **explicit**.

But if you don't like having so much boilerplate code, there is an alternative. 👇
### [Passing Ref as an argument](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#passing-ref-as-an-argument)

Rather than passing each dependency directly, we can just declare a single [`Ref`](https://pub.dev/documentation/riverpod/latest/riverpod/Ref-class.html) property:
```dart
class CartService {
  CartService(this.ref);
  final Ref ref;
}
```
And when we define the provider, we just pass `ref` as an argument:

```dart
final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref);
});
```
And now that we have declared the `CartService` class, let's add some methods to it.
### [Adding an item using the CartService](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#adding-an-item-using-the-cartservice)

To make our life easier, we can define two private methods that we can use to **fetch** and **set** the cart value:
```dart
class CartService {
  CartService(this.ref);
  final Ref ref;

  /// fetch the cart from the local or remote repository
  /// depending on the user auth state
  Future<Cart> _fetchCart() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).fetchCart(user.uid);
    } else {
      return ref.read(localCartRepositoryProvider).fetchCart();
    }
  }

  /// save the cart to the local or remote repository
  /// depending on the user auth state
  Future<void> _setCart(Cart cart) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(remoteCartRepositoryProvider).setCart(user.uid, cart);
    } else {
      await ref.read(localCartRepositoryProvider).setCart(cart);
    }
  }
}
```
Note how we can read each repository by calling `ref.read(provider)` and invoking the methods we need on them.
>By passing `Ref` as an argument, the `CartService` now depends directly on the Riverpod package and the **actual** dependencies are now **implicit**. If this is not what you want, just pass the dependencies explicitly as shown above. _Note: I'll show how to write unit tests for service classes using `Ref` in a separate article_.

Next up, we can create a public `addItem()` method that calls `_fetchCart()` and `_setCart()` under the hood:
```dart
class CartService {
  CartService(this.ref);
  final Ref ref;
  
  Future<Cart> _fetchCart() { ... }
  Future<void> _setCart(Cart cart) { ... }

  /// adds an item to the local or remote cart
  /// depending on the user auth state
  Future<void> addItem(Item item) async {
    // 1. fetch the cart
    final cart = await _fetchCart();
    // 2. return a copy with the updated data
    final updated = cart.addItem(item);
    // 3. set the cart with the updated data
    await _setCart(updated);
  }
}
```
What this method does is to:

1. fetch the cart (from the local or remote repository depending on the auth state)
2. make a copy and return an updated cart
3. set the cart with the updated data (using the local or remote repository depending on the auth state)
>> Note that the second step calls the `addItem()` method that we have previously defined in the `MutableCart` extension. The logic to mutate the `Cart` should live in the **domain** layer since it doesn't depend on any services or repositories.

### [Adding the remaining methods to the CartService](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#adding-the-remaining-methods-to-the-cartservice)

Just like we have defined the `addItem()` method, we can add the other methods that the controllers will use:
```dart
class CartService {
  ...
  /// removes an item from the local or remote cart depending on the user auth
  /// state
  Future<void> removeItemById(String productId) async {
    // business logic
    final cart = await _fetchCart();
    final updated = cart.removeItemById(productId);
    await _setCart(updated);
  }

  /// sets an item in the local or remote cart depending on the user auth state
  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.setItem(item);
    await _setCart(updated);
  }
}
```
>Note how the second step always **delegates** the cart update to a method in the `MutableCart` extension, which can be easily unit tested since it has no dependencies.

That's it! We've now completed the implementation of the `CartService`.

Next up, let's see how to use this inside a controller.

## [Implementing the ShoppingCartItemController](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#implementing-the-shoppingcartitemcontroller)

Let's consider how we can update or remove items that are already in the shopping cart:
![[Pasted image 20240527123321.png]]
To do this, we'll have a `ShoppingCartItem` widget and a corresponding `ShoppingCartItemController` class with `updateQuantity` and `deleteItem` methods:
```dart
class ShoppingCartItemController extends StateNotifier<AsyncValue<void>> {
  ShoppingCartItemController({required this.cartService})
      : super(const AsyncData(null));
  final CartService cartService;

  Future<void> updateQuantity(Item item, int quantity) async {
    // set loading state
    state = const AsyncLoading();
    // create an updated Item with the new quantity
    final updated = Item(productId: item.productId, quantity: quantity);
    // use the cartService to update the cart
    // and set the state again (data or error)
    state = await AsyncValue.guard(
      () => cartService.updateItemIfExists(updated),
    );
  }

  Future<void> deleteItem(Item item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => cartService.removeItemById(item.productId),
    );
  }
}
```
The methods in this class have two jobs:

- update the widget state
- call the corresponding `CartService` methods to update the cart

>Note how each method has only a few lines of code. This is by design because the `CartService` holds all the complex logic, and this can be reused by other controllers too!

To wrap up, let's define the provider for this controller:

```dart
final shoppingCartItemControllerProvider =
    StateNotifierProvider<ShoppingCartItemController, AsyncValue<void>>((ref) {
  return ShoppingCartItemController(
    cartService: ref.watch(cartServiceProvider),
  );
});
```
>In this case it's ok to call `ref.watch(cartServiceProvider)` and pass it to the constructor directly because `ShoppingCartItemController` has only one dependency. But if we wanted to pass `ref.read` as a `Reader` argument instead, that would be fine too.

That's it. We've now seen how repositories, services, and controllers can serve as building blocks for building a complex shopping cart feature
> For brevity, I won't show how the widgets or the `AddToCartController` are implemented here, but you can read my article about [Flutter App Architecture: The Presentation Layer](https://codewithandrea.com/articles/flutter-presentation-layer/) to better understand how widgets and controllers interact with each other.

## [Note about controllers, services, and repositories](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#note-about-controllers-services-and-repositories)

Terms such as **controller**, **service**, and **repository** are often confused and used with different meanings in different contexts.

Developers like to argue about these things, and we'll never get everyone to agree on a clear definition of these terms, once and for all. 🤷‍♀️

The best thing we can do is to **pick a reference architecture** and **use these terms consistently within our team or organization**:

## [Conclusion](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#conclusion)

We've now completed our overview of the application layer. Since there was a lot to cover, a brief summary is in order.

If you find yourself writing some logic that:

- depends on multiple data sources or repositories
- needs to be used (shared) by more than one widget

Then consider writing a **service class** for it. Unlike controllers that extend [`StateNotifier`](https://pub.dev/documentation/state_notifier/latest/state_notifier/StateNotifier-class.html), service classes don't need to manage any state, as they hold logic that is **not** widget-specific.

Service classes also don't care about data serialization or how to get data from the outside world (that is what the data layer is for).

Lastly, **service classes are often unnecessary**. There's **no point** in creating a service class if all it does is forward method calls from a controller to a repository. In such a case, the controller can depend on the repository and call its methods directly. In other words, the application layer is **optional**.

Finally, if you're following the [feature-first project structure outlined here](https://codewithandrea.com/articles/flutter-project-structure/), you should decide if you need service classes **on a feature-by-feature basis**.

## [Closing notes](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/#closing-notes)

App architecture is a deeply fascinating topic, and I've been able to explore it in depth while building a medium-sized eCommerce app (and many other Flutter apps before that).

By sharing these articles, I hope I have helped you navigate this complex topic so that you can design and build **your** own apps with confidence.

And if there is just one thing you should take away from all this, it is that:

> **Separation of concerns** should be **a primary concern** when building apps. Using a **layered architecture** lets you decide what each layer **should** and **should not** do, and establish **clear boundaries** between various components.

-----------
[Presentation-layer-pattern](https://codewithandrea.com/articles/flutter-presentation-layer/)

we will focus on the **presentation layer** and learn how we can use **controllers** to:

- hold business logic
- manage the widget state
- interact with repositories in the data layer

>This kind of **controller** is the same as the **view model** that you would use in the **MVVM pattern**. If you've worked with [flutter_bloc](https://pub.dev/packages/flutter_bloc) before, it has the same role as a **cubit**.

We will learn about the [`AsyncNotifier`](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncNotifier-class.html) class, which is a replacement for the [`StateNotifier`](https://pub.dev/documentation/state_notifier/latest/state_notifier/StateNotifier-class.html) and the [`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) / [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) classes in the Flutter SDK.

And to make this more useful, we will implement a **simple authentication flow** as an example.

## [A simple authentication flow](https://codewithandrea.com/articles/flutter-presentation-layer/#a-simple-authentication-flow)

Let's consider a very simple app that we can use to **sign in anonymously** and toggle between two screens:
![[Pasted image 20240527124820.png]]
And in this article, we'll focus on how to implement:

- an auth **repository** that we can use to sign in and sign out
- a sign-in **widget** screen that we show to the user
- the corresponding **controller** class that mediates between the two

Here's a simplified version of the reference architecture for this specific example:
![[Pasted image 20240527124932.png]]
>You can find the complete source code for this app [on GitHub](https://github.com/bizz84/simple_auth_flutter_riverpod). For more info about how it is organized

## [The AuthRepository class](https://codewithandrea.com/articles/flutter-presentation-layer/#the-authrepository-class)

As a starting point, we can define a simple **abstract class** that contains three methods that we'll use to sign in, sign out, and check the authentication state:
```dart
abstract class AuthRepository {
  // emits a new value every time the authentication state changes
  Stream<AppUser?> authStateChanges();

  Future<AppUser> signInAnonymously();

  Future<void> signOut();
}
```
>In practice, we also need a concrete class that **implements** `AuthRepository`. This could be based on Firebase or any other backend. We can even implement it with a **fake repository** for now. For more details, see this article about [the repository pattern](https://codewithandrea.com/articles/flutter-repository-pattern/).

For completeness, we can also define a simple `AppUser` model class:

```dart
/// Simple class representing the user UID and email.
class AppUser {
  const AppUser({required this.uid});
  final String uid;
  // TODO: Add other fields as needed (email, displayName etc.)
}
```
And if we use Riverpod, we also need a `Provider` that we can use to access our repository:
```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // return a concrete implementation of AuthRepository
  return FakeAuthRepository();
});
```
Next up, let's focus on the sign-in screen.

## [The SignInScreen widget](https://codewithandrea.com/articles/flutter-presentation-layer/#the-signinscreen-widget)

Suppose we have a simple `SignInScreen` widget defined like so:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign in anonymously'),
          onPressed: () { /* TODO: Implement */ },
        ),
      ),
    );
  }
}
```
This is just a simple `Scaffold` with an `ElevatedButton` in the middle.

Note that since this class extends [`ConsumerWidget`](https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/ConsumerWidget-class.html), in the `build()` method we have an extra **ref** object that we can use to access providers as needed.
### [Accessing the AuthRepository directly from our widget](https://codewithandrea.com/articles/flutter-presentation-layer/#accessing-the-authrepository-directly-from-our-widget)

As a next step, we can use the `onPressed` callback to sign in like so:
```dart
ElevatedButton(
  child: Text('Sign in anonymously'),
  onPressed: () => ref.read(authRepositoryProvider).signInAnonymously(),
)
```
This code works by obtaining the `AuthRepository` with a call to `ref.read(authRepositoryProvider)`. and calling the `signInAnonymously()` method on it.

This covers the happy path (sign-in successful). But we should also account for **loading** and **error** states by:

- disabling the sign-in button and showing a loading indicator while sign-in is in progress
- showing a `SnackBar` or alert if the call fails for any reason
### [The "StatefulWidget + setState" way](https://codewithandrea.com/articles/flutter-presentation-layer/#the-statefulwidget-+-setstate-way)

One simple way of addressing this is to:

- convert our widget into a `StatefulWidget` (or rather, [`ConsumerStatefulWidget`](https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/ConsumerStatefulWidget-class.html) since we're using Riverpod)
- add some local variables to keep track of state changes
- set those variables inside calls to `setState()` to trigger a widget rebuild
- use them to update the UI
Here's how the resulting code may look like:

```dart
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  // keep track of the loading state
  bool isLoading = false;

  // call this from the `onPressed` callback
  Future<void> _signInAnonymously() async {
    try {
      // update the state
      setState(() => isLoading = true);
      // sign in using the repository
      await ref
          .read(authRepositoryProvider)
          .signInAnonymously();
    } catch (e) {
      // show a snackbar if something went wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      // check if we're still on this screen (widget is mounted)
      if (mounted) {
        // reset the loading state
        setState(() => isLoading = false);
      }
    }
  }
  
  ...
}
```
`full code `: [git](https://github.com/bizz84/simple_auth_flutter_riverpod/blob/main/lib/src/features/authentication/presentation/sign_in_screen.dart)
For a simple app like this, this is probably ok.

But this approach gets quickly out of hand when we have more complex widgets, as we are **mixing business logic and UI code** in the same widget class.

And if we want to handle loading in error states **consistently** across multiple widgets, copy-pasting and tweaking the code above is quite error-prone (and not much fun).

Instead, it would be best to move all these concerns into a separate **controller** class that can:

- mediate between our `SignInScreen` and the `AuthRepository`
- manage the widget state
- provide a way for the widget to **observe** state changes and rebuild itself as a result
![[Pasted image 20240527125724.png]]
So let's see how to implement it in practice.

## [A controller class based on AsyncNotifier](https://codewithandrea.com/articles/flutter-presentation-layer/#a-controller-class-based-on-asyncnotifier)

The first step is to create a [`AsyncNotifier`](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncNotifier-class.html) subclass which looks like this:
```dart
class SignInScreenController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // no-op
  }
}
```
Or even better, we can use the new `@riverpod` syntax and let [Riverpod Generator](https://codewithandrea.com/articles/flutter-riverpod-generator/) do the heavy lifting for us:
```dart
part 'sign_in_controller.g.dart';

@riverpod
class SignInScreenController extends _$SignInScreenController {
  @override
  FutureOr<void> build() {
    // no-op
  }
}

// A signInScreenControllerProvider will be generated by build_runner
```
Either way, we need to implement a `build` method, which returns the **initial value** that should be used when the controller is first loaded.
>If desired, we can use the `build` method to do some asynchronous initialization (such as loading some data from the network). But if the controller is "ready to go" as soon as it is created (just like in this case), we can leave the body empty and set the return type to `Future<void>`.

### [Implementing the method to sign in](https://codewithandrea.com/articles/flutter-presentation-layer/#implementing-the-method-to-sign-in)

Next up, let's add a method that we can use to sign in:
```dart
@riverpod
class SignInScreenController extends _$SignInScreenController {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<void> signInAnonymously() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signInAnonymously());
  }
}
```
A few notes:

- We obtain the `authRepository` by calling `ref.read` on the corresponding provider (`ref` is a property of the base `AsyncNotifier` class)
- Inside `signInAnonymously()`, we set the state to `AsyncLoading` so that the widget can show a loading UI
- Then, we call `AsyncValue.guard` and `await` for the result (which will be either `AsyncData` or `AsyncError`)
>`AsyncValue.guard` is a handy alternative to `try`/`catch`. For more info, read this: [Use AsyncValue.guard rather than try/catch inside your AsyncNotifier subclasses](https://codewithandrea.com/tips/async-value-guard-try-catch/)

And as an extra tip, we can use a method **tear-off** to simplify our code even further:

```dart
// pass authRepository.signInAnonymously directly using tear-off
state = await AsyncValue.guard(authRepository.signInAnonymously);
```
This completes the implementation of our controller class, in just a few lines of code:

```dart
@riverpod
class SignInScreenController extends _$SignInScreenController {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<void> signInAnonymously() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(authRepository.signInAnonymously);
  }
}

// A signInScreenControllerProvider will be generated by build_runner
```

### [Note about the relationship between types](https://codewithandrea.com/articles/flutter-presentation-layer/#note-about-the-relationship-between-types)

Note that there is a clear relationship between the return type of the `build` method and the type of the `state` property:
![[Pasted image 20240527130315.png]]
In fact, using `AsyncValue<void>` as the state allows us to represent three possible values:

- **default** (not loading) as [`AsyncData`](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncData-class.html) (same as `AsyncValue.data`)
- **loading** as [`AsyncLoading`](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncLoading-class.html) (same as `AsyncValue.loading`)
- **error** as [`AsyncError`](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncError-class.html) (same as `AsyncValue.error`)
>If you're not familiar with `AsyncValue` and its subclasses, read this: [How to handle loading and error states with StateNotifier & AsyncValue in Flutter](https://codewithandrea.com/articles/loading-error-states-state-notifier-async-value/)

Time to get back to our widget class and wire everything up!
```dart
class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch and rebuild when the state changes
    final AsyncValue<void> state = ref.watch(signInScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          // conditionally show a CircularProgressIndicator if the state is "loading"
          child: state.isLoading
              ? const CircularProgressIndicator()
              : const Text('Sign in anonymously'),
          // disable the button if the state is loading
          onPressed: state.isLoading
              ? null
              // otherwise, get the notifier and sign in
              : () => ref
                  .read(signInScreenControllerProvider.notifier)
                  .signInAnonymously(),
        ),
      ),
    );
  }
}
```
Note how in the `build()` method we **watch** our provider and rebuild the widget when the state changes.

And in the `onPressed` callback we **read** the provider's **notifier** and call `signInAnonymously()`.  
And we can also use the `isLoading` property to conditionally disable the button while sign-in is in progress.

We're almost done, and there's only one thing left to do.
### [Listening to state changes](https://codewithandrea.com/articles/flutter-presentation-layer/#listening-to-state-changes)

Right at the top of the build method, we can add this:
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen<AsyncValue>(
    signInScreenControllerProvider,
    (_, state) {
      if (!state.isLoading && state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error.toString())),
        );
      }
    },
  );
  // rest of the build method
}
```
We can use this code to call a **listener** callback whenever the state changes.

This is useful for showing an error alert or a `SnackBar` if an error occurs when signing in.
## [Bonus: An AsyncValue extension method](https://codewithandrea.com/articles/flutter-presentation-layer/#bonus-an-asyncvalue-extension-method)

The listener code above is quite useful and we may want to reuse it in multiple widgets.

To do that, we can define this `AsyncValue` **extension**:
```dart
extension AsyncValueUI on AsyncValue {
  void showSnackbarOnError(BuildContext context) {
    if (!isLoading && hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }
}
```
And then, in our widget, we can just import our extension and call this:

```
ref.listen<AsyncValue>(
  signInScreenControllerProvider,
  (_, state) => state.showSnackbarOnError(context),
)
```
## [Conclusion](https://codewithandrea.com/articles/flutter-presentation-layer/#conclusion)

By implementing a custom **controller** class based on `AsyncNotifier`, we've **separated our business logic from the UI code**.

As a result, our widget class is now completely **stateless** and is only concerned with:

- **watching** state changes and rebuilding as a result (with `ref.watch`)
- responding to user input by calling methods in the controller (with `ref.read`)
- **listening** to state changes and showing errors if something goes wrong (with `ref.listen`)

Meanwhile, the job of our controller is to:

- **talk to the repository** on behalf of the widget
- **emit state changes** as needed

And since the controller doesn't **depend** on any UI code, it can be easily **unit tested**, and this makes it an ideal place to store any **widget-specific** business logic.

---------------------
# [update map in dart](https://codewithandrea.com/tips/dart-map-update-method/)

A common requirement when working with maps is to:

- **Update** the value if a given key **already exists**
- **Set** the value if it **doesn't**

You may be tempted to implement some conditional logic to handle this:
```dart
class ShoppingCart {
  final Map<String, int> items = {};

  void add(String key, int quantity) {
    if (items.containsKey(key)) {
      // item exists: update it
      items[key] = quantity + items[key]!;
    } else {
      // item does not exist: set it
      items[key] = quantity;
    }
  }
}
```
the code is not very readable.
And the `update()` method offers a simpler (and more expressive) way of doing the same thing: 👇
```dart
class ShoppingCart {
  final Map<String, int> items = {};

  void add(String key, int quantity) {
    items.update(
      key,
      (value) => quantity + value,
      ifAbsent: () => quantity,
    );
  }
}
```

//TODO
https://codewithandrea.com/articles/data-mutations-riverpod/#handling-mutations-with-controller-classes
