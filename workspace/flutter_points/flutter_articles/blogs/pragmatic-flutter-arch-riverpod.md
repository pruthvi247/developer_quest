[source](https://medium.com/@mxiskw/flutter-pragmatic-architecture-using-riverpod-123ae11a8267)
A working example is on the git: [https://github.com/ttlg/riverpod_todo](https://github.com/ttlg/riverpod_todo)
![[Pasted image 20231008085419.png]]
# Entity

Entity is a container of data corresponding to the schema of the database. It may be referred to in other ways, but you can convert it as you see fit.  
Entities are used everywhere, from displaying data to retrieving data. This Entity can be made immutable to make it easier to handle.

However, the cost of making it immutable is that it cannot be modified, and you will need to use functions such as copyWith instead. There is a useful package called freezed that generates these functions for you, but it requires you to generate the code, which tends to confuse you during development. For this reason, I do not use freezed now, but instead use IntelliJ plugin called Dart Data Class to create functions such as copyWith / fromMap / toMap.
```dart
class Todo {
  final String content;
  final bool done;
  final DateTime timestamp;
  final String id;

//<editor-fold desc="Data Methods">

  Todo({
    required this.content,
    required this.done,
    required this.timestamp,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          done == other.done &&
          timestamp == other.timestamp &&
          id == other.id);

  @override
  int get hashCode =>
      content.hashCode ^ done.hashCode ^ timestamp.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'Todo{' +
        ' content: $content,' +
        ' done: $done,' +
        ' timestamp: $timestamp,' +
        ' id: $id,' +
        '}';
  }

  Todo copyWith({
    String? content,
    bool? done,
    DateTime? timestamp,
    String? id,
  }) {
    return Todo(
      content: content ?? this.content,
      done: done ?? this.done,
      timestamp: timestamp ?? this.timestamp,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': this.content,
      'done': this.done,
      'timestamp': this.timestamp.toIso8601String(),
      'id': this.id,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      content: map['content'] as String,
      done: map['done'] as bool,
      timestamp: DateTime.parse(map['timestamp']),
      id: map['id'] as String,
    );
  }

//</editor-fold>
}
```
# Repository

In Repository, we write the process to CRUD data. It is convenient to define it in an abstract class (so-called interface) so that you can easily add dummy implementations or connect to an external DB later. In this implementation, we will get the SharedPreferences and CRUD the data. If you are going to use it, you might want to add some error handling.
The important point is the line that defines the **todoRepository**. This will allow you to access it from ProviderReference
```dart
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_riverpod/entity/todo.dart';

final todoRepository =
    Provider.autoDispose<TodoRepository>((ref) => TodoRepositoryImpl(ref.read));

abstract class TodoRepository {
  Future<List<Todo>> getTodoList();
  Future<void> saveTodoList(List<Todo> todoList);
}

const _todoListKey = 'todoListKey';

class TodoRepositoryImpl implements TodoRepository {
  final Reader _read;
  TodoRepositoryImpl(this._read);

  Future<List<Todo>> getTodoList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> todoListJsonList =
        List<Map<String, dynamic>>.from(
            jsonDecode(prefs.getString(_todoListKey) ?? '[]'));
    return todoListJsonList.map((json) => Todo.fromMap(json)).toList();
  }

  Future<void> saveTodoList(List<Todo> todoList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_todoListKey,
        jsonEncode(todoList.map((todo) => todo.toMap()).toList()));
  }
}
```
# State

State is where the state is stored in memory. It is also where you define information such as Getter that is calculated from the values of other States. In this project, we will prepare three states, and by defining them as StateProvider, View and **ref.watch** will be automatically notified when the state variable inside is changed. Of these, **_todoListState** and **_sortOrderState** are defined as private variables since they do not need to be accessed directly by View.

## 1. Todo list value ( _todoListState)  
The reason the initial value of the Todo List is null instead of an empty array is to determine if the value was retrieved and is empty, or if it hasn’t been retrieved yet.
```dart
final _todoListState = StateProvider<List<Todo>?>((ref) => null);
```
## 2. Sort order value (_sortOrderState)  
define sort order as enum
```dart
enum SortOrder {
  ASC,
  DESC,
}

final _sortOrderState = StateProvider<SortOrder>((ref) => SortOrder.ASC);
```
## 3. Sorted Todo list value (sortedTodoListState)

The calculation is based on the values of **_todoListState** and **_sortOrderState**. If they are changed, they are automatically calculated again.
```dart
final sortedTodoListState = StateProvider<List<Todo>?>((ref) {
  final List<Todo>? todoList = ref.watch(_todoListState);

  if (ref.watch(_sortOrderState) == SortOrder.ASC) {
    todoList?.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  } else {
    todoList?.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
  return todoList;
});
```
# ViewController

The **ViewController** takes commands from the View, such as user input, and writes processes that reflect them to the **Repository** and **State**. The modified State is reflected in the View.

```dart
final todoViewController =
    Provider.autoDispose((ref) => TodoViewController(ref.read));

class TodoViewController {
  final Reader _read;
  TodoViewController(this._read);

  Future<void> initState() async {
    _read(_todoListState.notifier).state =
        await _read(todoRepository).getTodoList();
  }

  void dispose() {
    _read(_todoListState)?.clear();
  }

  Future<void> addTodo(TextEditingController textController) async {
    final String text = textController.text;
    if (text.trim().isEmpty) {
      return;
    }
    textController.text = '';
    final now = DateTime.now();
    final newTodo = Todo(
      content: text,
      done: false,
      timestamp: now,
      id: "${now.millisecondsSinceEpoch}",
    );
    final List<Todo> newTodoList = [newTodo, ...(_read(_todoListState) ?? [])];
    _read(_todoListState.notifier).state = newTodoList;
    await _read(todoRepository).saveTodoList(newTodoList);
  }

  Future<void> toggleDoneStatus(Todo todo) async {
    final List<Todo> newTodoList = [
      ...(_read(_todoListState) ?? [])
          .map((e) => (e.id == todo.id) ? e.copyWith(done: !e.done) : e)
    ];
    _read(_todoListState.notifier).state = newTodoList;
    await _read(todoRepository).saveTodoList(newTodoList);
  }

  void toggleSortOrder() {
    _read(_sortOrderState.notifier).state =
        _read(_sortOrderState) == SortOrder.ASC
            ? SortOrder.DESC
            : SortOrder.ASC;
  }
}
```
# View

Finally, let’s take a look at the View, and following is the full code for the View, which extends **HookConsumerWidget** and allows for functions to access a Provider, such as ref.watch. The **useEffect** is a bit trickier to explain, so we’ll follow.

Basically, in the build, we just use **ref.watch** to access **State**, and in the onPressed, we just use **ref.read** to access the **ViewController**.
```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_riverpod/entity/todo.dart';
import 'package:todo_riverpod/provider/todo_providers.dart';

class TodoTile extends HookConsumerWidget {
  final Todo todo;
  const TodoTile({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(todo.content),
        leading: IconButton(
          icon: todo.done
              ? const Icon(Icons.check_box, color: Colors.green)
              : const Icon(Icons.check_box_outline_blank),
          onPressed: () {
            ref.read(todoViewController).toggleDoneStatus(todo);
          },
        ),
        trailing: Text(todo.timestamp.toIso8601String()),
      ),
    );
  }
}

class SimpleTodo extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(todoViewController).initState();
      return ref.read(todoViewController).dispose;
    }, []);
    final textController = useTextEditingController();
    final List<Todo>? todoList = ref.watch(sortedTodoListState);
    if (todoList == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Simple Todo')),
      body: Column(
        children: [
          TextField(controller: textController),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  ref.read(todoViewController).toggleSortOrder();
                },
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, int index) =>
                  TodoTile(todo: todoList[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          ref.read(todoViewController).addTodo(textController);
        },
      ),
    );
  }
}
```

```dart
useEffect(() {
      ref.read(todoViewController).initState();
      return ref.read(todoViewController).dispose;
    }, []);
```
The **useEffect** called within the build method serves as an alternative to the initState and dispose of StatefulWidget. useEffect’s first argument calls a function that causes a side-effect in the body, and the return value is specifying the functions that will be called when the widget is destroyed, **similar to StatefulWidget**. Here, we’re calling initState and dispose, which are defined in the ViewController, similar to StatefulWidget (we’re actually using **.autoDispose**, so we don’t need the dispose function). Then, we can pass an array of keys as the second argument. If the key is changed, the first argument is executed again. Since we didn’t pass anything here, **it won’t be called again** unless the widget is destroyed.

And finally, don’t forget to define a ProviderScope in main.dart.

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_riverpod/view/simple_todo.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: SimpleTodo(),
      ),
    ),
  );
}
```
# Test

One of the merits of building an architecture with Riverpod is that the tests are very easy to write and read. This is where the benefit of defining the TodoRepository in an interface comes in: you can override the Provider’s content by using the Provider’s **overrideWithProvider** function (here, the TodoRepositoryImpl is set to overridden by _TodoRepositoryImplDummy).  
To access each Provider from the test code, the **ProviderContainer** is defined. It is thought that it is enough to confirm that **the State is changed by executing ViewController** for the contents to be tested. The following is the code for testing all of the ViewController functions created this time. It’s minimal, but you can see that it can be written neatly.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_riverpod/entity/todo.dart';
import 'package:todo_riverpod/provider/todo_providers.dart';
import 'package:todo_riverpod/repository/todo_repository.dart';

class _TodoRepositoryImplDummy implements TodoRepository {
  List<Todo> inMemoryTodoList = [];

  Future<List<Todo>> getTodoList() async {
    return inMemoryTodoList;
  }

  Future<void> saveTodoList(List<Todo> todoList) async {
    inMemoryTodoList = todoList;
  }
}

void main() {
  group('test ViewController behaviors:', () {
    final container = ProviderContainer(
      overrides: [
        todoRepository.overrideWithProvider(
            Provider.autoDispose((ref) => _TodoRepositoryImplDummy()))
      ],
    );
    test('initial value of todo list is null', () async {
      expect(container.read(sortedTodoListState), null);
    });

    test('initial load is empty array', () async {
      await container.read(todoViewController).initState();
      expect(container.read(sortedTodoListState), []);
    });

    test('add first todo', () async {
      await container
          .read(todoViewController)
          .addTodo(TextEditingController(text: 'first'));
      expect(container.read(sortedTodoListState)![0].content, 'first');
    });

    test('add second todo', () async {
      await container
          .read(todoViewController)
          .addTodo(TextEditingController(text: 'second'));
      expect(container.read(sortedTodoListState)![1].content, 'second');
    });

    test('toggle status', () async {
      final Todo firstTodo = container.read(sortedTodoListState)![0];
      await container.read(todoViewController).toggleDoneStatus(firstTodo);
      expect(container.read(sortedTodoListState)![0].done, true);
    });

    test('change sort order', () async {
      container.read(todoViewController).toggleSortOrder();
      expect(container.read(sortedTodoListState)![0].content, 'second');
    });

    test('dispose', () async {
      container.read(todoViewController).dispose();
      expect(container.read(sortedTodoListState), []);
    });
  });
}
```
**<<Summary of this architecture>>  
✅ Taking full advantage of **Riverpod  
✅ Entity is corresponding to DB scheme  
✅ Repository fetch the data  
✅ Never write any logic in the **View**  
✅ Make data flow **intuitive**  
✅ Repository is declared as a **interface**  
✅ If it is fine by private then declare as **private**  
✅ Use **StateProvider** to store the data  
✅ Declare the state as the **smallest unit**  
✅ Having a page-by-page **ViewController**  
✅ Basically, use **.autoDispose**  
✅ Use **Hooks** such as useTextEditingController  
✅ Use **useEffect** to initialize the state  
✅ Only ** State ** and **ViewController** communicate with the **View**

