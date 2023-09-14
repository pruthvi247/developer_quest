//https://codepen.io/joshuadeguzman/pen/BaojbKo


// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _nikeLogoScaleAnimation;
  Animation<Offset> _nikeLogoOffsetAnimation;
  Animation<double> _leftBackgroundWidthAnimation;
  Animation<double> _rightBackgroundWidthAnimation;
  Animation<Offset> _productNameOffsetAnimation;
  Animation<Offset> _productPriceOffsetAnimation;
  Animation<Offset> _productSliderOffsetAnimation;
  Animation<Offset> _productDescriptionOffsetAnimation;
  Animation<Offset> _ctaOffsetAnimation;
  Animation<Offset> _productShowcaseOffsetAnimation;
  Animation<Offset> _display1OffsetAnimation;
  Animation<Offset> _display2OffsetAnimation;
  Animation<Offset> _display3OffsetAnimation;
  Animation<Offset> _display4OffsetAnimation;

  double _shoeSize = 39;

  bool _isAnimationTriggered = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this,
    );

    _nikeLogoScaleAnimation = Tween<double>(
      begin: 2.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0,
          1,
          curve: Curves.ease,
        ),
      ),
    );
    _nikeLogoOffsetAnimation = Tween<Offset>(
      begin: Offset(150, 110),
      end: Offset(20, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.125,
          1,
          curve: Curves.ease,
        ),
      ),
    );

    _leftBackgroundWidthAnimation = Tween<double>(
      begin: 0,
      end: 400,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0,
          1,
          curve: Curves.ease,
        ),
      ),
    );

    _rightBackgroundWidthAnimation = Tween<double>(
      begin: 900,
      end: 500,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0,
          1,
          curve: Curves.ease,
        ),
      ),
    );

    _productNameOffsetAnimation = Tween<Offset>(
      begin: Offset(0, 1000),
      end: Offset(0, 125),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0,
          0.750,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _productPriceOffsetAnimation = Tween<Offset>(
      begin: Offset(0, 1000),
      end: Offset(0, 200),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.125,
          0.800,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _productSliderOffsetAnimation = Tween<Offset>(
      begin: Offset(0, 1000),
      end: Offset(0, 300),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.250,
          0.900,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _productDescriptionOffsetAnimation = Tween<Offset>(
      begin: Offset(0, 1000),
      end: Offset(0, 375),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.350,
          0.950,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _ctaOffsetAnimation = Tween<Offset>(
      begin: Offset(0, 1000),
      end: Offset(0, 500),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.450,
          1,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _productShowcaseOffsetAnimation = Tween<Offset>(
      begin: Offset(3000, 20),
      end: Offset(0, 20),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0,
          0.750,
          curve: Curves.ease,
        ),
      ),
    );

    _display1OffsetAnimation = Tween<Offset>(
      begin: Offset(3000, 450),
      end: Offset(60, 450),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.125,
          0.500,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _display2OffsetAnimation = Tween<Offset>(
      begin: Offset(3000, 450),
      end: Offset(160, 450),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.350,
          0.850,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _display3OffsetAnimation = Tween<Offset>(
      begin: Offset(3000, 450),
      end: Offset(260, 450),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.450,
          0.950,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _display4OffsetAnimation = Tween<Offset>(
      begin: Offset(3000, 450),
      end: Offset(360, 450),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.550,
          1,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF040404),
      body: Stack(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Color(0xFF0D0D0D),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Color(0xFF101010),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Color(0xFF202020),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Color(0xFFFF2D4C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (BuildContext context, Widget child) {
                      return Stack(
                        children: <Widget>[
                          Container(
                            height: 650,
                            width: 900,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  color: Color(0xFF121212),
                                  width: _leftBackgroundWidthAnimation.value,
                                ),
                                Container(
                                  color: Color(0xFF0D0D0D),
                                  width: _rightBackgroundWidthAnimation.value,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 650,
                            width: 900,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 650,
                                  width: 400,
                                  padding: const EdgeInsets.only(left: 32),
                                  child: Stack(
                                    children: <Widget>[
                                      Transform.translate(
                                        offset:
                                            _productNameOffsetAnimation.value,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SelectableText(
                                              "LEBRON SOLDIER XIII",
                                              style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SelectableText(
                                              "BUILT FOR SPEED",
                                              style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Transform.translate(
                                        offset:
                                            _productPriceOffsetAnimation.value,
                                        child: SelectableText(
                                          "\$150",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 48,
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset:
                                            _productSliderOffsetAnimation.value,
                                        child: AppSlider(
                                          min: 39,
                                          max: 45,
                                          divisions: 6,
                                          sliderValue: _shoeSize,
                                          sliderSteps: [
                                            39,
                                            40,
                                            41,
                                            42,
                                            43,
                                            44,
                                            45
                                          ],
                                          onChangedValue: (double value) {
                                            setState(() {
                                              _shoeSize = value;
                                            });
                                          },
                                        ),
                                      ),
                                      Transform.translate(
                                        offset:
                                            _productDescriptionOffsetAnimation
                                                .value,
                                        child: SelectableText(
                                          "There's no player more battle-tested than LeBron James. Build for speed, with responsive cushioning and lightweight lockdown, the Lebron Soldier XIII is the next iteration of custom reinforcement for on-court dominance.",
                                          style: TextStyle(
                                            color: Color(0xFF909090),
                                            fontSize: 10,
                                            height: 2,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: _ctaOffsetAnimation.value,
                                        child: AppCtaButton(
                                          title: 'Buy Now',
                                          onCtaTap: (bool isTapped) {
                                            // TODO: UX/logic setup for demo only :)
                                            // Show some delay
                                            Future.delayed(
                                              Duration(seconds: 1),
                                              () {
                                                setState(() {
                                                  _isAnimationTriggered =
                                                      !_isAnimationTriggered;
                                                });

                                                _animationController.reverse();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 500,
                                  height: 650,
                                  child: Stack(
                                    children: <Widget>[
                                      Transform.translate(
                                        offset: _productShowcaseOffsetAnimation
                                            .value,
                                        child: Container(
                                          height: 450,
                                          child: Stack(
                                            children: <Widget>[
                                              Center(
                                                child: AppShowCaseProduct(
                                                  productSize: _shoeSize,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: _display1OffsetAnimation.value,
                                        child: Container(
                                          height: 75,
                                          width: 75,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 5,
                                              color: Colors.black87,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(37.5),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(37.5),
                                            ),
                                            child: Image.network(
                                              AssetConstants.nikeShowcase1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: _display2OffsetAnimation.value,
                                        child: Container(
                                          height: 75,
                                          width: 75,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 5,
                                              color: Colors.black87,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(37.5),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(37.5),
                                            ),
                                            child: Image.network(
                                              AssetConstants.nikeShowcase2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: _display3OffsetAnimation.value,
                                        child: Container(
                                          height: 75,
                                          width: 75,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 5,
                                              color: Colors.black87,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(37.5),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(37.5),
                                            ),
                                            child: Image.network(
                                              AssetConstants.nikeShowcase3,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: _display4OffsetAnimation.value,
                                        child: Container(
                                          height: 75,
                                          width: 75,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 5,
                                              color: Colors.black87,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(37.5),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(37.5),
                                            ),
                                            child: Image.network(
                                              AssetConstants.nikeShowcase4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform.scale(
                            scale: _nikeLogoScaleAnimation.value,
                            child: Transform.translate(
                              offset: _nikeLogoOffsetAnimation.value,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isAnimationTriggered =
                                        !_isAnimationTriggered;
                                  });

                                  if (_isAnimationTriggered) {
                                    _animationController.forward();
                                  } else {
                                    _animationController.reverse();
                                  }
                                },
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.network(AssetConstants.nikeLogo),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class AppCtaButton extends StatefulWidget {
  final String title;
  final Function(bool isTapped) onCtaTap;

  const AppCtaButton({
    Key key,
    @required this.title,
    this.onCtaTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppCtaButtonState();
  }
}

class _AppCtaButtonState extends State<AppCtaButton> {
  String get _title => widget.title;
  Function get _onCtaTap => widget.onCtaTap;
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.red,
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;
        });

        if (_onCtaTap != null) _onCtaTap(_isTapped);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        height: 40,
        width: 150,
        decoration: _getDecoration(),
        child: Center(
          child: Text(
            _title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    if (_isTapped) {
      return BoxDecoration(
        color: Color(0xFFFF2D4C),
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.5),
            color: Colors.red.shade600,
            blurRadius: 10,
          ),
        ],
      );
    } else {
      return BoxDecoration(
        border: Border.all(width: 2, color: Colors.white),
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      );
    }
  }
}

class AppShowCaseProduct extends StatelessWidget {
  final double productSize;

  const AppShowCaseProduct({
    Key key,
    @required this.productSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: productSize * 10,
      curve: Curves.fastLinearToSlowEaseIn,
      child: Image.network(
        AssetConstants.nikeSb1,
      ),
    );
  }
}


class AppSlider extends StatelessWidget {
  final double min;
  final double max;
  final int divisions;
  final double sliderValue;
  final List<double> sliderSteps;
  final Function(double value) onChangedValue;

  const AppSlider({
    Key key,
    @required this.min,
    @required this.max,
    @required this.divisions,
    @required this.sliderValue,
    @required this.sliderSteps,
    this.onChangedValue,
  })  : assert(
          min != null,
          'Min must not be null!',
        ),
        assert(
          max != null,
          'Max must not be null!',
        ),
        assert(
          divisions != null,
          'Discrete division must not be null!',
        ),
        assert(
          sliderValue != null,
          'Slider value must not be null!',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 325,
          child: SliderTheme(
            data: SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
              activeTrackColor: Color(0xFF484848),
              inactiveTrackColor: Color(0xFF484848),
              activeTickMarkColor: Color(0xFF484848),
              inactiveTickMarkColor: Color(0xFF484848),
              valueIndicatorColor: Color(0xFF484848),
              thumbColor: Color(0xFFFF2D4C),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 8),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
            ),
            child: Slider(
              value: sliderValue <= 0 ? min : sliderValue,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: (double value) => onChangedValue(value),
            ),
          ),
        ),
        Container(
          height: 40,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: sliderSteps.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 40,
                width: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedDefaultTextStyle(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: Duration(milliseconds: 100),
                      child: Text(
                        sliderSteps[index].toString(),
                      ),
                      style: _getSliderStyle(
                        sliderSteps[index] == sliderValue,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  TextStyle _getSliderStyle(bool isSelected) {
    if (isSelected) {
      return TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );
    } else {
      return TextStyle(
        fontSize: 16,
        color: Colors.white,
      );
    }
  }
}

// Constants
class AssetConstants {
  static const nikeLogo = "https://user-images.githubusercontent.com/20706361/78786145-db760e00-79da-11ea-8750-43ca2a895339.png";
  static const nikeSb1 =
      "https://user-images.githubusercontent.com/20706361/78779717-f5f6ba00-79cf-11ea-9957-c3876e5094b4.png";
  static const nikeShowcase1 = "https://user-images.githubusercontent.com/20706361/79439348-4d67dc00-8007-11ea-85cb-a1b5a488acc5.jpg";
  static const nikeShowcase2 = "https://user-images.githubusercontent.com/20706361/79439335-4b058200-8007-11ea-8329-cdf718fa81d3.jpg";
  static const nikeShowcase3 = "https://user-images.githubusercontent.com/20706361/79439350-4e990900-8007-11ea-986b-ed01f7f51522.jpg";
  static const nikeShowcase4 = "https://user-images.githubusercontent.com/20706361/79439352-4f319f80-8007-11ea-9624-ba067c9c0920.jpg";
}


