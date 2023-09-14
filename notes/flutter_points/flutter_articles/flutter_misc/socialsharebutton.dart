//https://codepen.io/kohrongying/pen/ZEQwKOQ

import 'package:flutter/material.dart';

const PAGE_HEIGHT = 600.0;
const PAGE_WIDTH = 350.0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Center(child: ArticleWidget()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ArticleWidget extends StatefulWidget {
  @override
  _ArticleWidgetState createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  int _count = 1; // to force animated switcher to re-render
  bool _showShareButtons = false;
  Icon _shareIcon;

  final double _shareButtonX = 20;
  final double _shareButtonY = 20;

  @override
  void initState() {
    setState(() {
      _shareIcon = Icon(Icons.share, key: ValueKey<int>(_count));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PAGE_WIDTH,
      height: PAGE_HEIGHT,
      child: Scaffold(
          body: Stack(fit: StackFit.expand, children: [
            Center(
              child: Text("Please share my cool article"),
            ),
            AnimatedPositioned(
                right: _showShareButtons ? 10 : _shareButtonX,
                bottom: _showShareButtons ? 90 : _shareButtonY,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutBack,
                child: SocialButton(Icon(Icons.cloud_upload))),
            AnimatedPositioned(
                right: _showShareButtons ? 75 : _shareButtonX,
                bottom: _showShareButtons ? 70 : _shareButtonY,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutBack,
                child: SocialButton(Icon(Icons.call))),
            AnimatedPositioned(
                right: _showShareButtons ? 100 : _shareButtonX,
                bottom: _showShareButtons ? 10 : _shareButtonY,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutBack,
                child: SocialButton(Icon(Icons.face))),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Icon iconToShow =
                  _showShareButtons ? Icon(Icons.share, key: ValueKey<int>(_count)) : Icon(Icons.clear, key: ValueKey<int>(_count));
              setState(() {
                _showShareButtons = !_showShareButtons;
                _shareIcon = iconToShow;
                _count += 1;
              });
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: _shareIcon,
            ),
          )),
    );
  }
}

class SocialButton extends StatelessWidget {
  Icon icon;

  SocialButton(this.icon);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: () {},
        color: Colors.black,
        icon: icon,
        hoverColor: Colors.tealAccent,
      ),
    );
  }
}


