[source: https://medium.com/flutter-community/handling-network-calls-like-a-pro-in-flutter-31bd30c86be1]
> good to read the article

[source: https://stackoverflow.com/questions/60648984/handling-exception-http-request-flutter]

Error handling:

Creating an API base helper class
For making communication between our Remote server and Application we use various APIs which needs some type of HTTP methods to get executed. So we are first going to create a base API helper class, which will be going to help us communicate with our server.

>>>
import 'CustomException.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:connectivity/connectivity.dart';

class APIManager {

  Future<dynamic> postAPICall(String url, Map param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      final response =  await http.post(url,
      body: param);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
   return responseJson;
}

dynamic _response(http.Response response) {
switch (response.statusCode) {
  case 200:
    var responseJson = json.decode(response.body.toString());
    return responseJson;
  case 400:
    throw BadRequestException(response.body.toString());
  case 401:

  case 403:
    throw UnauthorisedException(response.body.toString());
  case 500:

  default:
    throw FetchDataException(
        'Error occured while Communication with Server with StatusCode : 
  ${response.statusCode}');
   }
  }
}

Creating CustomException Class

An HTTP request on execution can return various types of status codes based on its status. We don’t want our app to misbehave if the request fails so we are going to handle most of them in our app. For doing so are going to create our custom app exceptions which we can throw based on the response status code.
>>>
class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
  return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
  : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

Creating a class to fetch data from APIs

Calling API for fetching data from the API

void signIn(Map param)  {
  setState(() {
    _isLoading = true;
  });
  apiManager.postAPICall(BASE_URL + user_login, param).then((value) {
    var status_code = value["statuscode"];
    if (status_code == 200) {
      var userData = value["user_data"];
      Navigator.push(context, PageTransition(type: 
      PageTransitionType.rightToLeftWithFade, child: HouseholderHomeScreen()));

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: new Text(value["msg"]),
            backgroundColor: Colors.red,
            duration: new Duration(seconds: 2),
          )
      );
    }
 }, onError: (error) {
    setState(() {
      _isLoading = false;
    });
    print("Error == $error");
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: new Text('Something went wrong..'),
        duration: new Duration(seconds: 2),
      )
    );
    print(error);
  });
}


what if we wanted to “hide” the widget completely, if person.IsLeaving is false and only display Text(‘goodbye’) if it’s true
>> [
  if(person.IsGreeting) Text('hello'),
  person.isLeaving ? Text(‘goodbye’) 
                   : SizedBox.shrink(),
];
> SizedBox.shrink() is a quick way to return an empty widget. SizedBox has no child, no height or width.

[source : https://www.youtube.com/watch?v=klfVz0dU6j0, https://proandroiddev.com/some-widely-used-override-methods-in-flutter-50696f08d42a]
Stateful widget life cycle :

Create state -> initstate -> didChangeDependencies -> build -> didUpdateWidget -> setState -> deactivate -> dispose

create State:
> Called immediately after flutter is instructed to create a steateful widget
> Can be called multiple times (if you use the same widget in multiple places)
> When this is called a Buildcontext is assigned to the state
> mounted =false 

Initstate:
> Called only once
> Must be called with super.initState()
> Best time to :
	- initialize data that relies on a specific BuildContext
	- initialize properties that rely on this specific widget's parents
	- Subscribe to things that could change data (Streams,changeNotifiers, and async wait stuff)

didchangeDependencies():
> Called right after initState() on the first time the widget is built
> Called whenever an object that a widget depends on changes
> Build method is always called after this
> First chance to call
  BuildContext.inheritFromWidgetOfExactType
	- would make a widget listen to changes from its parent

didUpdateWidget()
> called if a widget needs to be rebuilt due to its parent widget changing and passing it new data
> Rebuilt with the same runtimeType
> Flutter is re-using the state
> Some data is re-initialized
> This is a replacement for initState() if the widget associated with a pre-existing state object is rebuilt
###> Flutter calls the build method after this, so dont bother calling setstate because that's redundant

dispose():
> Called when the state object is removed which is permanent
> mounted =false

 
Examples to use didUpdateWidget():
[source: https://stackoverflow.com/questions/61999838/why-do-we-need-the-didupdatewidget-and-build-method-in-a-statefull-widget
 class MyApp extends StatefulWidget {
  int getInitialValue() {
    return 1;
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentValue = 10;
  @override
  void didUpdateWidget(MyApp oldWidget) {
      if(oldWidget.getInitialValue() != _currentValue) {
        // Perform animation
        // Fetch data from server
      }
  }
 }


[source: https://flutterigniter.com/deconstructing-dart-constructors/]
Dart constructors:

> Imagine that the height field is expressed in feet and we want clients to supply the height in meters. Dart also allows us to initialize fields with computations from static methods (as they don't depend on an instance of the class):

>>
class Robot {
  static mToFt(m) => m * 3.281;
  double height; // in ft
  Robot(height) : this.height = mToFt(height);
}

Example of constructor which uses asserts and super:
>>>
class OnboardingPage1 extends StatelessWidget {
  final int number;
  final Widget lightCardChild;
  final Widget darkCardChild;
  final Widget textColumn;
  final GlobalKey kk;
  static cToInt(double m) => m.toInt();
   OnboardingPage1({
    @required this.kk,
    @required double number1,
    @required this.lightCardChild,
    @required this.darkCardChild,
    @required this.textColumn,
   })  : this.number = number1.toInt(),
  // })  : this.number = cToInt(number1),
        assert(number1 != null),
        assert(lightCardChild != null),
        assert(darkCardChild != null),
        assert(textColumn != null),
        super(key: kk);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
> Keep in mind initializers only assign values to fields and it is therefore not possible to use a setter in an initializer:
class Robot {
  double _height;
  Robot(this.height); // ERROR: 'height' isn't a field in the enclosing class

  get height => _height;
  set height(value) => _height = value;
}
Fix:
> above example doesnt work, below method works
If a setter needs to be called, we'll have to do that in a constructor body:
class Robot {
  double _height;

  Robot(h) {
    height = h;
  }

  get height => _height;
  set height(value) => _height = value;
}

> The following won't work because height, being final, must be initialized. And initialization happens before the constructor body is run:
class Robot {
  final double height;

  Robot(double height) {
    this.height = height; // ERROR: The final variable 'height' must be initialized
  }
}
Fix :
class Robot {
  final double height;
  Robot(this.height);
}

Optional arguments:
class Robot {
  final double height;
  final double weight;
  final List<String> names;

  const Robot(this.height, this.names, [this.weight = 170]);
}

void main() {
  final r = Robot(5, ["Walter"]);
  print(r.weight); // 170
}

Naming arguments along with conditions:
class Robot extends StatelessWidget {
  final double height;
  final double weight;
  final List<String> names;
  final GlobalKey kk;

  Robot({@required this.kk, height, weight, this.names = const []})
      : this.height = height ?? 7,
        this.weight = weight ?? int.parse("100"),
        assert(height > 6),
        super(key: kk);
  // Robot(
  //     {@required this.kk,
  //     @required this.height,
  //     @required this.weight,
  //     this.names = const []})
  //     : super(key: kk);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}



Example to use didUpdateWidget():
>>
@override
  void initState() {
    super.initState();
    print('Widget Lifecycle: initState');
    _animationController = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    print('Widget Lifecycle: didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('Widget Lifecycle: didUpdateWidget');
    if (this.widget.counter != oldWidget.counter) {
      print('Count has changed');
    }
  }

  @override
  void deactivate() {
    print('Widget Lifecycle: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('Widget Lifecycle: dispose');
    _animationController.dispose();
    super.dispose();
  }
