// https://codepen.io/team/codepen/pen/LYpGWBx

import 'package:flutter/material.dart';

void main() {
  runApp(YetiApp());
}

enum ArmAnim {
  normal,
  hi,
  hide,
}

class YetiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Yeti',
      home: YetiScreen(),
    );
  }
}

class YetiScreen extends StatefulWidget {
  @override
  _YetiScreenState createState() => _YetiScreenState();
}

class _YetiScreenState extends State<YetiScreen> with TickerProviderStateMixin {
  static String baseUrl = 'https://firebasestorage.googleapis.com/';
  static String baseRepo = 'v0/b/flutter-yeti.appspot.com/o/';

  Offset hoverPos = Offset.zero;
  String eyesPath = baseUrl + baseRepo + 'eye.png?alt=media';
  double mouthLocation = -0.05;

  ArmAnim _leftArmAnim = ArmAnim.normal;
  ArmAnim _rightArmAnim = ArmAnim.normal;

  double animateHandHi = 0.15;
  AnimationController _hiController;
  Animation<double> _hiAnimation;

  double animateHandHide = 0.25;
  AnimationController _hideController;
  Animation<double> _hideAnimation;

  bool _armsOpen = true;

  Widget powered() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 150,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 20,
            top: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Powered by',
                style: TextStyle(
                  fontFamily: 'Sans',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 5),
              Semantics(
                child: FlutterLogo(),
                label: "Flutter",
                readOnly: true,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _changeImage() {
    setState(() {
      eyesPath = baseUrl + baseRepo + 'eye_happy.png?alt=media';
      mouthLocation = -0.08;
      _armsOpen = false;
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        eyesPath = baseUrl + baseRepo + 'eye.png?alt=media';
        mouthLocation = -0.05;
        _armsOpen = true;
      });
    });
  }

  void _animateHi() {
    setState(() => _leftArmAnim = ArmAnim.hi);

    _hiAnimation = Tween<double>(
      begin: 0.15,
      end: 0.45,
    ).animate(_hiController);

    _hiController.forward();

    _hiAnimation.addListener(() {
      setState(() => animateHandHi = _hiAnimation.value);
    });

    Stream.periodic(Duration(milliseconds: 500), (value) => value)
        .take(5)
        .listen((event) {
      event % 2 == 0 ? _hiController.reverse() : _hiController.forward();
    }).onDone(() => setState(() => _leftArmAnim = ArmAnim.normal));
  }

  void _animateHide() {
    setState(() {
      _leftArmAnim = ArmAnim.hide;
      _rightArmAnim = ArmAnim.hide;
    });
    _hideAnimation =
        Tween<double>(begin: 0.25, end: -0.15).animate(_hideController);
    _hideAnimation.addListener(() {
      setState(() => animateHandHide = _hideAnimation.value);
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      _hideController.forward();
    });

    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        _leftArmAnim = ArmAnim.normal;
        _rightArmAnim = ArmAnim.normal;
      });

      _hideController.value = 0.0;
    });
  }

  Widget hiAnimation() {
    return Align(
      alignment: Alignment(-0.5, 0.7),
      child: Transform(
        transform: Matrix4.identity()..setRotationX(135),
        child: Transform(
          transform: Matrix4.rotationZ(animateHandHi),
          alignment: Alignment.topLeft,
          child: Image.network(
            baseUrl + baseRepo + 'left_arm.png?alt=media',
            width: 180,
          ),
        ),
      ),
    );
  }

  Widget hideLeftAnimation() {
    return Align(
      alignment: Alignment(-0.5, 0.7),
      child: Transform(
        transform: Matrix4.identity()..setRotationX(135),
        child: Transform(
          transform: Matrix4.rotationZ(-0.25),
          alignment: Alignment.topLeft,
          child: Image.network(
            baseUrl + baseRepo + 'left_arm.png?alt=media',
            width: 180,
          ),
        ),
      ),
    );
  }

  Widget hideRightAnimation() {
    return Align(
      alignment: Alignment(0.5, 0.7),
      child: Transform(
        transform: Matrix4.identity()..setRotationX(135),
        child: Transform(
          transform: Matrix4.rotationZ(animateHandHide),
          alignment: Alignment.topRight,
          child: Image.network(
            baseUrl + baseRepo + 'right_arm.png?alt=media',
            width: 180,
          ),
        ),
      ),
    );
  }

  Widget hideAnimation(bool leftArm) =>
      leftArm ? hideLeftAnimation() : hideRightAnimation();

  Widget leftArm() {
    return GestureDetector(
      onTap: () => _animateHi(),
      child: Align(
        alignment: Alignment(-0.5, 0.5),
        child: TweenAnimationBuilder<Matrix4>(
          duration: Duration(milliseconds: 500),
          tween: _armsOpen
              ? Matrix4Tween(
                  begin: Matrix4.rotationZ(-0.3),
                  end: Matrix4.rotationZ(0.0),
                )
              : Matrix4Tween(
                  begin: Matrix4.rotationZ(0.0),
                  end: Matrix4.rotationZ(-0.3),
                ),
          builder: (context, value, child) {
            return Transform(
              transform: value,
              child: child,
              alignment: Alignment.topRight,
            );
          },
          child: Image.network(
            baseUrl + baseRepo + 'left_arm.png?alt=media',
            width: 180,
          ),
        ),
      ),
    );
  }

  Widget rightArm() {
    return Align(
      alignment: Alignment(0.5, 0.5),
      child: TweenAnimationBuilder<Matrix4>(
        duration: Duration(milliseconds: 500),
        tween: _armsOpen
            ? Matrix4Tween(
                begin: Matrix4.rotationZ(0.3),
                end: Matrix4.rotationZ(0.0),
              )
            : Matrix4Tween(
                begin: Matrix4.rotationZ(0.0),
                end: Matrix4.rotationZ(0.3),
              ),
        builder: (context, value, child) {
          return Transform(
            transform: value,
            child: child,
          );
        },
        child: Image.network(
          baseUrl + baseRepo + 'right_arm.png?alt=media',
          width: 180,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _hiController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _hideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _hiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            baseUrl + baseRepo + 'forest.jpg?alt=media',
            fit: BoxFit.cover,
          ),
          Opacity(
            opacity: 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF512DA8), Color(0xFFF57C00)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          powered(),
          MouseRegion(
            onHover: (details) {
              setState(() {
                final size = context.size;
                final center = size.center(Offset.zero);
                hoverPos = Offset(
                  (details.position.dx - center.dx) / size.width,
                  (details.position.dy - center.dy) / size.height,
                );
              });
            },
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final size = context.size;
                  final center = size.center(Offset.zero);
                  hoverPos = Offset(
                    (details.localPosition.dx - center.dx) / size.width,
                    (details.localPosition.dy - center.dy) / size.height,
                  );
                });
              },
              onPanEnd: (_) => setState(() => hoverPos = Offset.zero),
              onPanCancel: () => setState(() => hoverPos = Offset.zero),
              child: Transform.scale(
                scale: 0.8,
                child: FittedBox(
                  child: SizedBox(
                    height: 800,
                    width: 800,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _changeImage(),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                              baseUrl + baseRepo + 'body.png?alt=media'),
                          Align(
                            alignment: Alignment(
                              hoverPos.dx * 0.1,
                              hoverPos.dy * 0.1 - 0.22,
                            ),
                            child: GestureDetector(
                              onTap: () => _animateHide(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(eyesPath, width: 40),
                                  SizedBox(width: 120),
                                  Image.network(eyesPath, width: 40),
                                ],
                              ),
                            ),
                          ),
                          AnimatedAlign(
                            duration: Duration(milliseconds: 500),
                            alignment: Alignment(0.0, mouthLocation),
                            child: Image.network(
                              baseUrl + baseRepo + 'mouth.png?alt=media',
                              width: 60,
                            ),
                          ),
                          if (_leftArmAnim == ArmAnim.normal)
                            leftArm()
                          else if (_leftArmAnim == ArmAnim.hi)
                            hiAnimation()
                          else
                            hideAnimation(true),
                          if (_rightArmAnim == ArmAnim.normal)
                            rightArm()
                          else
                            hideAnimation(false),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


