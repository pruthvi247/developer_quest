[Source : https://medium.com/flutter-community/making-sense-all-of-those-flutter-providers-e842e18f45dd]

> examples in this doc are from medium blog link given above, pdf file of the above blog can also be found in "developer_quest/notes/flutter_points/flutter_articles/blogs/provider_package_blogs/medium.com-Makingsense_of_all_those_Flutter_Providers.pdf"
> for value notifier refere [source : https://www.youtube.com/watch?v=Jx7JzP3-KYE]


>>> Example 1 : setup

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My App')),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.green[200],
              child: RaisedButton(
                child: Text('Do something'),
                onPressed: () {},
              ),
            ),

            Container(
              padding: const EdgeInsets.all(35),
              color: Colors.blue[200],
              child: Text('Show something'),
            ),

          ],
        ),
      ),
    );
  }
}
//////////////////////////////////////////

>>> Example 2 : Provider 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<MyModel>( //                                <--- Provider
      create: (context) => MyModel(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('My App')),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.green[200],
                child: Consumer<MyModel>( //                    <--- Consumer
                  builder: (context, myModel, child) {
                    return RaisedButton(
                      child: Text('Do something'),
                      onPressed: (){
                        // We have access to the model.
                        myModel.doSomething();
                      },
                    );
                  },
                )
              ),

              Container(
                padding: const EdgeInsets.all(35),
                color: Colors.blue[200],
                child: Consumer<MyModel>( //                    <--- Consumer
                  builder: (context, myModel, child) {
                    return Text(myModel.someValue);
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class MyModel { //                                               <--- MyModel
  String someValue = 'Hello';
  void doSomething() {
    someValue = 'Goodbye';
    print(someValue);
  }
}
/////////////////////////////////////////

>>> Example 3: ChangeNotifierProvider

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>( //      <--- ChangeNotifierProvider
      create: (context) => MyModel(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('My App')),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.green[200],
                  child: Consumer<MyModel>( //                  <--- Consumer
                    builder: (context, myModel, child) {
                      return RaisedButton(
                        child: Text('Do something'),
                        onPressed: (){
                          myModel.doSomething();
                        },
                      );
                    },
                  )
              ),

              Container(
                padding: const EdgeInsets.all(35),
                color: Colors.blue[200],
                child: Consumer<MyModel>( //                    <--- Consumer
                  builder: (context, myModel, child) {
                    return Text(myModel.someValue);
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class MyModel with ChangeNotifier { //                          <--- MyModel
  String someValue = 'Hello';

  void doSomething() {
    someValue = 'Goodbye';
    print(someValue);
    notifyListeners();
  }
}
////////////////////////////////////
>>> Example 4 : Future Provider

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider<MyModel>( //                      <--- FutureProvider
      initialData: MyModel(someValue: 'default value'),
      create: (context) => someAsyncFunctionToGetMyModel(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('My App')),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.green[200],
                child: Consumer<MyModel>( //                    <--- Consumer
                  builder: (context, myModel, child) {
                    return RaisedButton(
                      child: Text('Do something'),
                      onPressed: (){
                        myModel.doSomething();
                      },
                    );
                  },
                )
              ),

              Container(
                padding: const EdgeInsets.all(35),
                color: Colors.blue[200],
                child: Consumer<MyModel>( //                    <--- Consumer
                  builder: (context, myModel, child) {
                    return Text(myModel.someValue);
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
    
  }
}

Future<MyModel> someAsyncFunctionToGetMyModel() async { //  <--- async function
  await Future.delayed(Duration(seconds: 3));
  return MyModel(someValue: 'new data');
}

class MyModel { //                                               <--- MyModel
  MyModel({this.someValue});
  String someValue = 'Hello';
  Future<void> doSomething() async {
    await Future.delayed(Duration(seconds: 2));
    someValue = 'Goodbye';
    print(someValue);
  }
}
///////////////////////////////////:w
>>> Example 5 : Stream Provider

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyModel>( //                       <--- StreamProvider
      initialData: MyModel(someValue: 'default value'),
      create: (context) => getStreamOfMyModel(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('My App')),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.green[200],
                child: Consumer<MyModel>( //                    <--- Consumer
                  builder: (context, myModel, child) {
                    return RaisedButton(
                      child: Text('Do something'),
                      onPressed: (){
                        myModel.doSomething();
                      },
                    );
                  },
                )
              ),

              Container(
                padding: const EdgeInsets.all(35),
                color: Colors.blue[200],
                child: Consumer<MyModel>( //                    <--- Consumer
                  builder: (context, myModel, child) {
                    return Text(myModel.someValue);
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
    
  }
}

Stream<MyModel> getStreamOfMyModel() { //                        <--- Stream
  return Stream<MyModel>.periodic(Duration(seconds: 1),
          (x) => MyModel(someValue: '$x'))
      .take(10);
}

class MyModel { //                                               <--- MyModel
  MyModel({this.someValue});
  String someValue = 'Hello';
  void doSomething() {
    someValue = 'Goodbye';
    print(someValue);
  }
}
/////////////////////////////////////////
>>> Example 6 : ValueListenable provider

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<MyModel>(//                              <--- Provider
      create: (context) => MyModel(),
      child: Consumer<MyModel>( //                           <--- MyModel Consumer
          builder: (context, myModel, child) {
            return ValueListenableProvider<String>.value( // <--- ValueListenableProvider
              value: myModel.someValue,
              child: MaterialApp(
                home: Scaffold(
                  appBar: AppBar(title: Text('My App')),
                  body: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.green[200],
                          child: Consumer<MyModel>( //       <--- Consumer
                            builder: (context, myModel, child) {
                              return RaisedButton(
                                child: Text('Do something'),
                                onPressed: (){
                                  myModel.doSomething();
                                },
                              );
                            },
                          )
                      ),

                      Container(
                        padding: const EdgeInsets.all(35),
                        color: Colors.blue[200],
                        child: Consumer<String>(//           <--- String Consumer
                          builder: (context, myValue, child) {
                            return Text(myValue);
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class MyModel { //                                             <--- MyModel
  ValueNotifier<String> someValue = ValueNotifier('Hello'); // <--- ValueNotifier
  void doSomething() {
    someValue.value = 'Goodbye';
    print(someValue.value);
  }
}
//////////////////////////////////
>>> Example 7 : Multiprovider

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider( //                                     <--- MultiProvider
      providers: [
        ChangeNotifierProvider<MyModel>(create: (context) => MyModel()),
        ChangeNotifierProvider<AnotherModel>(create: (context) => AnotherModel()),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('My App')),
          body: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.green[200],
                      child: Consumer<MyModel>( //            <--- MyModel Consumer
                        builder: (context, myModel, child) {
                          return RaisedButton(
                            child: Text('Do something'),
                            onPressed: (){
                              // We have access to the model.
                              myModel.doSomething();
                            },
                          );
                        },
                      )
                  ),

                  Container(
                    padding: const EdgeInsets.all(35),
                    color: Colors.blue[200],
                    child: Consumer<MyModel>( //              <--- MyModel Consumer
                      builder: (context, myModel, child) {
                        return Text(myModel.someValue);
                      },
                    ),
                  ),

                ],
              ),

             // SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.red[200],
                      child: Consumer<AnotherModel>( //      <--- AnotherModel Consumer
                        builder: (context, myModel, child) {
                          return RaisedButton(
                            child: Text('Do something'),
                            onPressed: (){
                              myModel.doSomething();
                            },
                          );
                        },
                      )
                  ),

                  Container(
                    padding: const EdgeInsets.all(35),
                    color: Colors.yellow[200],
                    child: Consumer<AnotherModel>( //        <--- AnotherModel Consumer
                      builder: (context, anotherModel, child) {
                        return Text('${anotherModel.someValue}');
                      },
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}

class MyModel with ChangeNotifier { //                        <--- MyModel
  String someValue = 'Hello';
  void doSomething() {
    someValue = 'Goodbye';
    print(someValue);
    notifyListeners();
  }
}

class AnotherModel with ChangeNotifier { //                   <--- AnotherModel
  int someValue = 0;
  void doSomething() {
    someValue = 5;
    print(someValue);
    notifyListeners();
  }
}
//////////////////////////////////////
>>> example 8 : Proxy Provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider( //                              <--- MultiProvider
      providers: [
        ChangeNotifierProvider<MyModel>( //               <--- ChangeNotifierProvider
          create: (context) => MyModel(),
        ),
        ProxyProvider<MyModel, AnotherModel>( //          <--- ProxyProvider
          update: (context, myModel, anotherModel) => AnotherModel(myModel),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('My App')),
          body: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.green[200],
                      child: Consumer<MyModel>( //          <--- MyModel Consumer
                        builder: (context, myModel, child) {
                          return RaisedButton(
                            child: Text('Do something'),
                            onPressed: (){
                              myModel.doSomething('Goodbye');
                            },
                          );
                        },
                      )
                  ),

                  Container(
                    padding: const EdgeInsets.all(35),
                    color: Colors.blue[200],
                    child: Consumer<MyModel>( //            <--- MyModel Consumer
                      builder: (context, myModel, child) {
                        return Text(myModel.someValue);
                      },
                    ),
                  ),

                ],
              ),

              Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.red[200],
                  child: Consumer<AnotherModel>( //          <--- AnotherModel Consumer
                    builder: (context, anotherModel, child) {
                      return RaisedButton(
                        child: Text('Do something else'),
                        onPressed: (){
                          anotherModel.doSomethingElse();
                        },
                      );
                    },
                  )
              ),

            ],
          ),
        ),
      ),
    );

  }
}

class MyModel with ChangeNotifier { //                       <--- MyModel
  String someValue = 'Hello';
  void doSomething(String value) {
    someValue = value;
    print(someValue);
    notifyListeners();
  }
}

class AnotherModel { //                                      <--- AnotherModel
  MyModel _myModel;
  AnotherModel(this._myModel);
  void doSomethingElse() {
    _myModel.doSomething('See you later');
    print('doing something else');
  }
}
/////////////////////////////////

