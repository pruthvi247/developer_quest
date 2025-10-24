import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html';

void main() => runApp(MaterialApp(home: EmbedWhatsApp(), debugShowCheckedModeBanner: false));

class EmbedWhatsApp extends StatefulWidget {
  @override
  _EmbedWhatsAppState createState() => _EmbedWhatsAppState();
}

// ignore: camel_case_types
class platformViewRegistry {
  static registerViewFactory(String viewId, dynamic cb) {
    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, cb);
  }
}

class _EmbedWhatsAppState extends State<EmbedWhatsApp> {
  final IFrameElement _iFrameElement = IFrameElement();
  final baseUrl = 'https://firebasestorage.googleapis.com/v0/b/';
  Widget _iFrameWidget;

  @override
  void initState() {
    super.initState();
    loadIFrame();
  }

  void loadIFrame() {
    _iFrameElement.height = '100%';
    _iFrameElement.width = '100%';
    _iFrameElement.src = 'https://codepen.io/mkiisoft/debug/BaoWVrQ';
    _iFrameElement.style.border = 'none';
    _iFrameWidget = HtmlElementView(key: UniqueKey(), viewType: 'iframeElement');
    platformViewRegistry.registerViewFactory('iframeElement', (int viewId) => _iFrameElement);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipPath(clipper: CrossPath(), child: Container(color: Color(0xFF296259))),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                transform: Matrix4.identity()..scale(0.85, 0.85),
                alignment: Alignment.center,
                child: SizedBox(
                  height: size.height,
                  width: size.height / 2.12,
                  child: Stack(
                    children: [
                      phoneLayer(Container(color: Colors.white, child: Center(child: CircularProgressIndicator())),
                          shadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 100,
                                spreadRadius: -15,
                                offset: Offset(0, 80))
                          ]),
                      phoneLayer(_iFrameWidget),
                      Image.network('${baseUrl}flutter-yeti.appspot.com/o/oneplus.png?alt=media'),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget phoneLayer(Widget child, {List<BoxShadow> shadow}) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
      decoration: BoxDecoration(boxShadow: shadow),
    );
  }
}

class CrossPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..lineTo(0, size.height)..lineTo(size.width, size.height * 0.3)..lineTo(size.width, 0);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


