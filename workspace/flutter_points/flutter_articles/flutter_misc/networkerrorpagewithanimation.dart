//https://codepen.io/anirudhk07/pen/ZEQwRKQ


import 'package:flutter/material.dart';

final appHeight = 650.0;
final appWidth = 350.0;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyAnimation(),
      ),
    );
  }
}

class MyClipPath extends AnimatedWidget {
  final Animation<double> animation;

  MyClipPath(this.animation) : super(listenable: animation);

  final Color backgroundColor = Color(0x77899F);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFe4e4e4),
      
      
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.white,
                width: appWidth,
                height: appHeight,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Text(
                      'Hang on a sec..',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 30.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        children: <Widget>[
                          Text('It seems you are in the middle of the ocean'),
                          SizedBox(
                            height: 50,
                          ),
                          
                          MyButton(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 50,
                            right: animation.value,
                            child: ClipPath(
                              clipper: BottomWaveClipper(),
                              child: Opacity(
                                opacity: 0.5,
                                child: Container(
                                  color: Color(0xFF104891),
                                  width: 1000,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 120,
                            left: animation.value,
                            child: ClipPath(
                              clipper: BottomWaveClipper(),
                              child: Opacity(
                                opacity: 1,
                                child: Container(
                                  color: Color(0xFF0a2e5c),
                                  width: 1000,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, 80.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);

    path.lineTo(size.width, 80.0);

    for (int i = 0; i < 10; i++) {
      if (i % 2 == 0) {
        path.quadraticBezierTo(
            size.width - (size.width / 16) - (i * size.width / 8),
            0.0,
            size.width - ((i + 1) * size.width / 8),
            size.height - 160);
      } else {
        path.quadraticBezierTo(
            size.width - (size.width / 16) - (i * size.width / 8),
            size.height - 120,
            size.width - ((i + 1) * size.width / 8),
            size.height - 160);
      }
    }

    path.lineTo(0.0, 80.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class MyAnimation extends StatefulWidget {
  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 2500), vsync: this)
          ..repeat(reverse: true);

    animation = Tween<double>(begin: -199, end: -1).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyClipPath(animation);
  }
}

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class MyButton extends StatefulWidget {
  MyButton({Key key}) : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController _animationController;

  double _containerPaddingLeft = 20.0;
  double _animationValue;
  double _translateX = 0;
  double _translateY = 0;

  double _rotate = 0;
  double _scale = 1;

  bool show;
  bool sent = false;
  Color _color = Colors.lightBlue;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    show = true;
    _animationController.addListener(() {
      setState(() {
        show = false;
        _animationValue = _animationController.value;
        if (_animationValue >= 0.2 && _animationValue < 0.4) {
          _containerPaddingLeft = 100.0;
          _color = Colors.green;
        } else if (_animationValue >= 0.4 && _animationValue <= 0.5) {
          _translateX = 80.0;
          _rotate = -20.0;
          _scale = 0.1;
        } else if (_animationValue >= 0.5 && _animationValue <= 0.8) {
          _translateY = -20.0;
        } else if (_animationValue >= 0.81) {
          _containerPaddingLeft = 20.0;
          sent = true;
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(50.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                _animationController.forward();
              },
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: [
                    BoxShadow(
                      color: _color,
                      blurRadius: 21,
                      spreadRadius: -15,
                      offset: Offset(
                        0.0,
                        20.0,
                      ),
                    )
                  ],
                ),
                padding: EdgeInsets.only(
                    left: _containerPaddingLeft,
                    right: 20.0,
                    top: 10.0,
                    bottom: 10.0),
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    (!sent)
                        ? AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            child: Icon(Icons.send),
                            curve: Curves.fastOutSlowIn,
                            transform: Matrix4.translationValues(
                                _translateX, _translateY, 0)
                              ..rotateZ(_rotate)
                              ..scale(_scale),
                          )
                        : Container(),
                    AnimatedSize(
                      vsync: this,
                      duration: Duration(milliseconds: 600),
                      child: show ? SizedBox(width: 10.0) : Container(),
                    ),
                    AnimatedSize(
                      vsync: this,
                      duration: Duration(milliseconds: 200),
                      child: show ? Text("Refresh") : Container(),
                    ),
                    AnimatedSize(
                      vsync: this,
                      duration: Duration(milliseconds: 200),
                      child: sent ? Icon(Icons.done) : Container(),
                    ),
                    AnimatedSize(
                      vsync: this,
                      alignment: Alignment.topLeft,
                      duration: Duration(milliseconds: 600),
                      child: sent ? SizedBox(width: 10.0) : Container(),
                    ),
                    AnimatedSize(
                      vsync: this,
                      duration: Duration(milliseconds: 200),
                      child: sent ? Text("Done") : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
