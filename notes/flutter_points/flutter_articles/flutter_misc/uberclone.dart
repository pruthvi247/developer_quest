import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:js_util' as js_util;
import 'dart:ui' as ui;
import 'dart:html';

typedef void CurrentLocation(double lat, double lng);
typedef void MapCallback();

void main() => runApp(UberApp());

class CarRoute {
  final double lat;
  final double lng;
  final int rotation;
  final int delay;

  CarRoute(this.lat, this.lng, this.rotation, this.delay);

  @override
  String toString() {
    return 'Lat: $lat Lng: $lng Rotation: $rotation Delay: $delay';
  }
}

class UberApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class MapSection extends StatelessWidget {
  static int _mapRegisterId = 1;
  static final _mapId = '_good_map_${_mapRegisterId++}';
  final _iframe;
  final _callback;

  MapSection(this._iframe, this._callback);

  static Widget _loadMap(IFrameElement _iframe, MapCallback _callback) {
    _iframe.id = _mapId;
    _iframe.width = '100%';
    _iframe.height = '100%';
    _iframe.src = 'https://cdpn.io/mkiisoft/debug/06e9cbdfd0beb7f1129ad2e71639adb4';
    _iframe.style.border = 'none';
    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_mapId, (int viewId) => _iframe);
    final done = _iframe.onLoad.matches('onLoad');
    Future.delayed(Duration(seconds: 2), () => _callback());
    return HtmlElementView(key: UniqueKey(), viewType: _mapId);
  }

  @override
  Widget build(BuildContext context) {
    return _loadMap(_iframe, _callback);
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _iframe = IFrameElement();
  MapCallback _mapCallback;

  List<CarRoute> _routes = [];

  bool _isAnim = false;
  bool _initPath = false;

  @override
  void initState() {
    super.initState();
    _loadMap(_mapCallback = () {
      /** Get User Location **/
      _getLocation((lat, lng) {
        _setUserMarker(lat, lng);
      });

      /** Car Route Path **/
      _mapListener((lat, lng) {
        if (!_isAnim) {
          if (_routes.isNotEmpty) {
            _routes.add(CarRoute(
              lat,
              lng,
              Utils.angle(lat, lng, _routes[_routes.length - 1].lat, _routes[_routes.length - 1].lng),
              Utils.timeFromDistance(lat, lng, _routes[_routes.length - 1].lat, _routes[_routes.length - 1].lng)
                  .floor(),
            ));
          } else {
            _routes.add(CarRoute(lat, lng, 0, 0));
            _initPath = true;
          }
          print(_routes);
        }
      });
    });
  }

  MapCallback _loadMap(MapCallback callback) {
    return callback;
  }

  void _mapListener(CurrentLocation location) {
    final contentWindow = js_util.getProperty(_iframe, 'contentWindow');
    final map = js_util.getProperty(contentWindow, 'map');
    js_util.callMethod(contentWindow, 'addMapListener', [
      map,
      "click",
      location,
    ]);
  }

  void _updateUserLocation() {
    _getUpdatedLocation((lat, lng) {
      _setUserMarker(lat, lng);
    });
  }

  void _getUpdatedLocation(CurrentLocation location) {
    if (window.navigator.geolocation != null) {
      _getLocation(location);
      Timer.periodic(Duration(seconds: 5), (timer) {
        _getLocation(location);
      });
    }
  }

  void _getLocation([CurrentLocation location]) {
    window.navigator.geolocation.getCurrentPosition(enableHighAccuracy: true).then((geo) {
      _setCenter(geo.coords.latitude, geo.coords.longitude);
      if (location != null) location(geo.coords.latitude, geo.coords.longitude);
    });
  }

  void _setCenter(double lat, double lng, [int zoom = 17]) {
    final contentWindow = js_util.getProperty(_iframe, 'contentWindow');
    js_util.callMethod(contentWindow, 'setCenter', [
      js_util.jsify({'lat': lat, 'lng': lng}),
      zoom
    ]);
  }

  void _setUserMarker(double lat, double lng) {
    final contentWindow = js_util.getProperty(_iframe, 'contentWindow');
    js_util.callMethod(contentWindow, 'setUserMarker', [
      js_util.jsify({'lat': lat, 'lng': lng}),
    ]);
  }

  void _animateCar() async {
    _setCarMarker(_routes[0].lat, _routes[0].lng);
    await Future.forEach<CarRoute>(_routes.skip(1), (route) async {
      _updateCarPosition(route.lat, route.lng, route.rotation);
      await Future.delayed(Duration(seconds: route.delay));
    });
    await Future.delayed(Duration(seconds: 0), () {
      _isAnim = false;
      _initPath = false;
      _routes.clear();
    });
  }

  void _setCarMarker(double lat, double lng, [int rotation = 0]) {
    final contentWindow = js_util.getProperty(_iframe, 'contentWindow');
    js_util.callMethod(contentWindow, 'setCarMarker', [
      js_util.jsify({'lat': lat, 'lng': lng}),
      rotation,
    ]);
  }

  void _clearCarMarker() {
    final contentWindow = js_util.getProperty(_iframe, 'contentWindow');
    js_util.callMethod(contentWindow, 'clearCarMarker', []);
  }

  void _updateCarPosition(double lat, double lng, int rotation) {
    final contentWindow = js_util.getProperty(_iframe, 'contentWindow');
    js_util.callMethod(contentWindow, 'updateCarPosition', [
      js_util.jsify({'lat': lat, 'lng': lng}),
      rotation,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: MapSection(_iframe, _mapCallback)),
                  Container(
                    height: size.height * 0.35,
                    width: size.width,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _searchSection(size),
                        _locationSection(
                            size, Icons.location_on, 'GooglePex', 'CA 94043, 1600 Amphitheatre Pkwy, Mountain View', true),
                        _locationSection(size, Icons.star, 'Golden Gate', 'Golden Gate Bridge, San Francisco, CA', false),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    color: Colors.grey[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _bottomItem(Icons.directions_car, 'Ride', true),
                        _bottomItem(Icons.restaurant, 'Order food', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: InkResponse(
                  child: Icon(Icons.menu, color: Colors.black, size: 30),
                ),
              ),
            )
          ],
        ));
  }

  Widget _requestLocation(bool isMobile, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isMobile ? 40 : 50,
        width: isMobile ? 40 : 50,
        decoration:
        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(isMobile ? 20 : 25), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 2,
            offset: Offset(0, 0),
          )
        ]),
        child: Icon(_initPath ? Icons.play_arrow : Icons.my_location, color: Colors.black, size: isMobile ? 20 : 25),
      ),
    );
  }

  Widget _bottomItem(IconData icon, String title, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: active ? Colors.grey[400] : Colors.grey[800]),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 12, color: active ? Colors.grey[400] : Colors.grey[800])),
      ],
    );
  }

  Widget _searchSection(Size size) {
    final isMobile = size.width < 400;
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              width: size.width,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Text('Where to?', style: TextStyle(fontSize: isMobile ? 14 : 20)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.black.withOpacity(0.08),
                    width: 1,
                  ),
                  SizedBox(width: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 15, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.black, size: isMobile ? 15 : 18),
                        SizedBox(width: 8),
                        Text('Now', style: TextStyle(fontSize: isMobile ? 12 : 14)),
                        SizedBox(width: 4),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _requestLocation(isMobile, () {
              if (_initPath) {
                _clearCarMarker();
                _animateCar();
              } else {
                _getLocation();
              }
            }),
          )
        ],
      ),
    );
  }

  Widget _locationSection(Size size, IconData icon, String title, String address, bool underline) {
    return Expanded(
        child: Container(
          width: size.width,
          margin: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(icon, color: Colors.black, size: 18),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(title, style: TextStyle(fontSize: 17)),
                            SizedBox(height: 5),
                            Text(
                              address,
                              style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Colors.black.withOpacity(0.5)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (underline) Container(height: 1, color: Colors.grey[300], margin: const EdgeInsets.only(left: 55)),
            ],
          ),
        ));
  }
}

enum Unit { MI, KM, MT }

class Utils {
  static double bearing(double lat1, double lng1, double lat2, double lng2) {
    double dLon = (lng2 - lng1);
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = radsToDegrees((atan2(y, x)));
    return (360 - ((bearing + 360) % 360));
  }

  static angle(double lat1, double lng1, double lat2, double lng2) {
    return reverseAngle(roundAngle(bearing(lat1, lng1, lat2, lng2)));
  }

  static reverseAngle(int angle) {
    return angle >= 180 ? angle - 180 : angle + 180;
  }

  static int roundAngle(double heading) {
    double bearing = double.parse(heading.toStringAsFixed(0));
    int angle = 0;
    if (bearing >= 0 && bearing <= 45) {
      angle = closerAngle(0, 45, bearing);
    } else if (bearing > 45 && bearing <= 90) {
      angle = closerAngle(45, 90, bearing);
    } else if (bearing > 90 && bearing <= 135) {
      angle = closerAngle(90, 135, bearing);
    } else if (bearing > 135 && bearing <= 180) {
      angle = closerAngle(135, 180, bearing);
    } else if (bearing > 180 && bearing <= 225) {
      angle = closerAngle(180, 225, bearing);
    } else if (bearing > 225 && bearing <= 270) {
      angle = closerAngle(225, 270, bearing);
    } else if (bearing > 270 && bearing <= 315) {
      angle = closerAngle(270, 315, bearing);
    } else if (bearing > 315 && bearing <= 365) {
      angle = closerAngle(315, 365, bearing);
    }
    return angle;
  }

  static int closerAngle(int min, int max, double bearing) => (bearing - min).abs() < (bearing - max).abs() ? min : max;

  static double timeFromDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = distFrom(lat1, lng1, lat2, lng2, Unit.MT);
    return routeTime(distance);
  }

  static double routeTime(double distance) {
    return 10;
  }

  static double distFrom(double lat1, double lng1, double lat2, double lng2, Unit unit) {
    double theta = lng1 - lng2;

    double distance = (sin(radians(lat1)) * sin(radians(lat2))) +
        (cos(radians(lat1)) * cos(radians(lat2)) * cos(radians(theta)));
    distance = acos(distance);
    distance = radsToDegrees(distance);
    distance = distance * 60 * 1.1515;

    switch (unit) {
      case Unit.MI:
        break;
      case Unit.KM:
        distance = distance * 1.609344;
        break;
      case Unit.MT:
        distance = (distance * 1.609344) * 1000;
        break;
    }
    distance = round(distance);
    return distance;
  }

  static double radians(double degrees) => degrees * degreesToRads(degrees);

  static double radsToDegrees(double rad) {
    return (rad * 180.0) / pi;
  }

  static double degreesToRads(double degree) {
    return 2 * (pi / 180);
  }

  static double round(double unrounded) {
    int decimals = 2;
    int fac = pow(10, decimals);
    return (unrounded * fac).round() / fac;
  }
}


