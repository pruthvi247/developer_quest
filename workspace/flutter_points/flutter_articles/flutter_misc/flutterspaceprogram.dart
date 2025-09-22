//https://codepen.io/orestesgaolin/pen/qBOxpBK

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//ignore: uri_does_not_exist
import 'dart:html' as html;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Space Program',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Courier New'),
      home: MyHomePage(title: 'Flutter Space Program'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  SpaceSimulation simulation;
  double _scale = 1.0;
  
  @override
  void initState() {
    super.initState();
    simulation = SpaceSimulation(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleUpdate: (scale) {
          if (scale.scale != 1.0) {
            setState(() {
              _scale = scale.scale;
            });
          }
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.scale(
                  scale: _scale,
                  child: AnimatedBuilder(
                    animation: simulation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: SpacePainter(simulation),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: PathsExplanation(simulation: simulation),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                child: ResetButton(simulation: simulation),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: MissionTime(simulation: simulation),
              ),
              Positioned(
                bottom: 40,
                right: 0,
                child: StatsControl(simulation: simulation),
              ),
              CrashedIndicator(simulation: simulation),
              WinIndicator(simulation: simulation),
              IntroLogo(simulation: simulation)
            ],
          ),
        ),
      ),
    );
  }
}

class IntroLogo extends StatelessWidget {
  const IntroLogo({
    Key key,
    @required this.simulation,
  }) : super(key: key);

  final SpaceSimulation simulation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: simulation,
        builder: (context, child) {
          if (simulation.hideIntro) {
            return SizedBox();
          }
          return AnimatedOpacity(
            opacity: simulation.showIntro ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(
                  size: 120,
                  colors: Colors.green,
                ),
                Text(
                  'FLUTTER SPACE PROGRAM',
                  style: TextStyle(
                      fontSize: 80,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
class StatsControl extends StatelessWidget {
  const StatsControl({
    Key key,
    @required this.simulation,
  }) : super(key: key);

  final SpaceSimulation simulation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VelocityIndicator(simulation: simulation),
          Row(
            children: [
              FlatButton(
                  color: Colors.lightGreen,
                  textColor: Colors.black,
                  child: Text('VEL-'),
                  onPressed: simulation.decreaseVelcoity,
                  onLongPress: () {
                    simulation.decreaseVelcoity();
                    simulation.decreaseVelcoity();
                  }),
              SizedBox(width: 12),
              FlatButton(
                color: Colors.lightGreen,
                textColor: Colors.black,
                child: Text('VEL+'),
                onPressed: simulation.increaseVelocity,
                onLongPress: () {
                  simulation.increaseVelocity();
                  simulation.increaseVelocity();
                },
              ),
            ],
          ),
          Container(
            width: 170,
            color: Colors.lightGreen,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'CONTROL PANEL',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            width: 170,
            // color: Colors.lightGreen,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'TAP TO CHNG VEL',
                  style: TextStyle(color: Colors.lightGreen),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({
    Key key,
    @required this.simulation,
  }) : super(key: key);

  final SpaceSimulation simulation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlatButton(
            color: Colors.lightGreen,
            textColor: Colors.black,
            child: Text('RESET'),
            onPressed: () {
              simulation.reset();
            },
          ),
          FlatButton(
            textColor: Colors.lightGreen,
            child: Text('AUTHOR'),
            onPressed: () {
               html.window.open('https://twitter.com/OrestesGaolin', 'Twitter');
            },
          ),
        ],
      ),
    );
  }
}

class PathsExplanation extends StatelessWidget {
  const PathsExplanation({
    Key key,
    this.simulation,
  }) : super(key: key);
  final SpaceSimulation simulation;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 500) return Container();
    return AnimatedBuilder(
      animation: simulation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    'HISTORY TRAIL',
                    style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                    activeColor: Colors.green[800],
                    value: simulation.rocket.showHistory,
                    onChanged: (val) {
                      simulation.toggleHistory();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'TRAJECTORY PREDICTION',
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                    activeColor: Colors.lightBlue,
                    value: simulation.rocket.showPrediction,
                    onChanged: (val) {
                      simulation.togglePrediction();
                    },
                  ),
                ],
              ),
              Text(
                'LIMITED ACCURACY\nOF PREDICTION',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        );
      },
    );
  }
}

class MissionTime extends StatelessWidget {
  const MissionTime({
    Key key,
    @required this.simulation,
  }) : super(key: key);

  final SpaceSimulation simulation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AnimatedBuilder(
        animation: simulation,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR GOAL IS TO STAY FOR ${SpaceSimulation.requiredTime} SEC\nWITHIN ${SpaceSimulation.requiredDistance} UNITS OF DARTOOINE',
                style: TextStyle(color: Colors.lightGreen),
              ),
              SizedBox(height: 10),
              Text(
                'DON\'T GET TOO CLOSE OR YOU WILL CRASH',
                style: TextStyle(color: Colors.lightGreen),
              ),
              SizedBox(height: 10),
              Text(
                'MISSION TIME ${simulation.missionTime}',
                style: TextStyle(color: Colors.lightGreen),
              ),
              Text(
                'TARGET DSTNC ${simulation.targetDistance}',
                style: TextStyle(color: Colors.lightGreen),
              ),
              if (simulation.countTime != null)
                Text(
                  'TARGET TIME ${simulation.countTime}',
                  style: TextStyle(color: Colors.lightGreen),
                ),
            ],
          );
        },
      ),
    );
  }
}

class CrashedIndicator extends StatelessWidget {
  const CrashedIndicator({
    Key key,
    this.simulation,
  }) : super(key: key);

  final SpaceSimulation simulation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: simulation,
      builder: (context, child) {
        if (simulation.crashed) {
          return child;
        } else
          return SizedBox();
      },
      child: Center(
        child: Text(
          'GAME OVER',
          style: TextStyle(
            fontSize: 60,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class WinIndicator extends StatelessWidget {
  const WinIndicator({
    Key key,
    this.simulation,
  }) : super(key: key);

  final SpaceSimulation simulation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: simulation,
      builder: (context, child) {
        if (simulation.win) {
          return child;
        } else
          return SizedBox();
      },
      child: Center(
        child: Text(
          'YOU WIN',
          style: TextStyle(
            fontSize: 60,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class VelocityIndicator extends StatelessWidget {
  const VelocityIndicator({
    Key key,
    @required this.simulation,
  }) : super(key: key);

  final SpaceSimulation simulation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: simulation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Text(
                  '${simulation.rocket.velocity.x.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(height: 6),
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: 10,
                  // height: 50,
                  color: Colors.lightGreen,
                  height: simulation.rocket.velocity.x.abs(),
                ),
                SizedBox(height: 6),
                Text(
                  'VEL X',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            SizedBox(width: 12),
            Column(
              children: [
                Text(
                  '${simulation.rocket.velocity.y.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(height: 6),
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: 10,
                  height: simulation.rocket.velocity.y.abs(),
                  color: Colors.lightGreen,
                  // height: simulation.rocket.velocity.x,
                ),
                SizedBox(height: 6),
                Text(
                  'VEL Y',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            SizedBox(width: 12),
            Column(
              children: [
                Text(
                  '${simulation.rocket.fuelLevel.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(height: 6),
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: 10,
                  height: simulation.rocket.fuelLevel.clamp(0.0, 100.0),
                  color: getColor(simulation.rocket.fuelLevel),
                  // height: simulation.rocket.velocity.x,
                ),
                SizedBox(height: 6),
                Text(
                  'FUEL',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Color getColor(double level) {
    if (level > 80.0) {
      return Colors.lightGreen;
    } else if (level > 50.0) {
      return Colors.yellow;
    } else if (level > 20.0) {
      return Colors.orange;
    } else {
      return Colors.red[600];
    }
  }
}

class SpacePainter extends CustomPainter {
  final SpaceSimulation simulation;
  final border = Paint()
    ..color = Colors.green[800]
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  final yellow = Paint()
    ..color = Colors.yellow[700]
    ..style = PaintingStyle.fill;

  SpacePainter(this.simulation);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    canvas.drawCircle(Offset(0, 0), 400, border);
    for (var i = 0; i < 4; i++) {
      canvas.save();
      canvas.rotate(2.0 * math.pi / 4.0 * i);
      canvas.translate(0, -400);
      canvas.drawRect(Rect.fromLTRB(0, 0, 1, 20), border);
      canvas.restore();
    }
    for (var i = 0; i < 60; i++) {
      canvas.save();
      canvas.rotate(2.0 * math.pi / 60.0 * i);
      canvas.translate(0, -400);
      canvas.drawRect(Rect.fromLTRB(0, 0, 1, 5), border);
      canvas.restore();
    }
    canvas.drawCircle(Offset(0, 0), 20, yellow);

    simulation.planet.drawPlanet(canvas);
    simulation.planet.drawPrediction(canvas);
    simulation.rocket.drawHistory(canvas);
    simulation.rocket.drawPrediction(canvas);
    simulation.rocket.drawRocket(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SpaceSimulation extends ChangeNotifier {
  static double g = 10.0;
  static double centerMass = 10000.0;
  static double softeningConstant = 0.0;
  static double requiredDistance = 50.0;
  static double requiredTime = 10.0;

  bool crashed = false;
  bool win = false;

  Rocket rocket;
  Planet planet;
  double _time = 0.0;
  double _targetDistance = 999.99;
  double startTime;
  int countTime;
  String get missionTime => _time.toStringAsFixed(2);
  String get targetDistance => _targetDistance.toStringAsFixed(2);
  bool get showIntro => _time < 2.0;
  bool get hideIntro => _time > 3.0;
  Ticker _ticker;
  TickerProvider _tickerProvider;

  SpaceSimulation(TickerProvider tickerProvider) {
    _tickerProvider = tickerProvider;
    _init(tickerProvider);
  }

  void _init(TickerProvider tickerProvider) {
    crashed = false;
    win = false;
    _time = 0.0;
    startTime = null;
    rocket = Rocket()
      ..position = SpacePosition(0, 200, 0.0)
      ..velocity = Velocity(22.360679775, 0);
    planet = Planet(300.0);
    _ticker = tickerProvider.createTicker(_onTick)..start();
  }

  void _onTick(Duration deltaTime) {
    final lastFrameTime = deltaTime.inMilliseconds.toDouble() / 1000.0;
    planet.update(lastFrameTime - _time);
    rocket.update(lastFrameTime - _time, otherPlanets: [planet]);
    _time = lastFrameTime;
    _checkCollision();
    notifyListeners();
  }

  void _checkCollision() {
    final distance = math.sqrt(rocket.position.x * rocket.position.x +
        rocket.position.y * rocket.position.y);
    if (distance < 20.0 || distance > 800) {
      _crash();
    }
    final dx = rocket.position.x - planet.position.x;
    final dy = rocket.position.y - planet.position.y;
    _targetDistance = math.sqrt(dx * dx + dy * dy);
    if (_targetDistance <= SpaceSimulation.requiredDistance) {
      if (startTime == null) {
        startTime = _time;
      } else {
        rocket.showDash = true;
        countTime = (_time - startTime).round();
        if (countTime >= 10) {
          _gameWin();
        }
      }
    } else {
      rocket.showDash = false;
      startTime = null;
    }
    if (_targetDistance < 10.0) {
      _crash();
    }
    if (rocket.fuelLevel < 0.0) {
      _crash();
    }
  }

  void _crash() {
    crashed = true;
    _ticker.stop();
  }

  void _gameWin() {
    win = true;
    rocket.showDash = true;
    _ticker.stop();
  }

  void increaseVelocity() {
    rocket.increaseVelocity();
  }

  void decreaseVelcoity() {
    rocket.decreaseVelocity();
  }

  void reset() {
    _ticker.stop();
    _init(_tickerProvider);
  }

  void togglePrediction() {
    rocket.showPrediction = !rocket.showPrediction;
  }

  void toggleHistory() {
    rocket.showHistory = !rocket.showHistory;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

class SpaceObject {
  SpacePosition position = SpacePosition(0, 0, 0);
  Velocity velocity = Velocity(0, 0);
  Acceleration acceleration = Acceleration(0, 0);
  final List<SpacePosition> positionHistory = [];
  final List<SpacePosition> positionPrediction = [];
  final List<Velocity> velocityPrediction = [];
  final paint = Paint()
    ..color = Colors.white
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5);
  final predictionPaint = Paint()
    ..color = Colors.lightBlue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
  final historyPaint = Paint()
    ..color = Colors.green[800]
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  void update(double deltaTime, {List<Planet> otherPlanets}) {
    position = _getPosition(deltaTime, position, velocity);
    acceleration = _getAcceleration(position, otherPlanets);
    velocity = _getVelocity(deltaTime, velocity, acceleration);
    _updateHistory();
    _updatePrediction(otherPlanets ?? []);
  }

  void _updateHistory() {
    if (positionHistory.length > 1) {
      final last = positionHistory.last;
      if ((position.x - last.x).abs() > 10 ||
          (position.y - last.y).abs() > 10) {
        positionHistory.add(position);
      }
    } else {
      positionHistory.add(position);
    }
    if (positionHistory.length > 30) {
      positionHistory.removeAt(0);
    }
  }

  void _updatePrediction(List<Planet> otherPlanets) {
    positionPrediction.clear();
    velocityPrediction.clear();
    for (var i = 0; i < 80; i++) {
      SpacePosition previousPosition = position;
      Velocity previousVelocity = velocity;
      if (positionPrediction.length > 1) {
        previousPosition = positionPrediction[i - 1];
        previousVelocity = velocityPrediction[i - 1];
      }
      final newPosition =
          _getPosition(i / 100, previousPosition, previousVelocity);
      final otherObjectsnewPositions = otherPlanets
          .map(
            (e) {
              return Planet(e.radius)
              ..position = SpacePosition(
                e.positionPrediction[i].x,
                e.positionPrediction[i].y,
                0,
              );
            },
          )
          .toList();
      final newAcceleration =
          _getAcceleration(newPosition, otherObjectsnewPositions);
      final newVelocity =
          _getVelocity(i / 100, previousVelocity, newAcceleration);
      positionPrediction.add(newPosition);
      velocityPrediction.add(newVelocity);
    }
  }

  SpacePosition _getPosition(
      double deltaTime, SpacePosition position, Velocity velocity) {
    final x = position.x + velocity.x * deltaTime;
    final y = position.y + velocity.y * deltaTime;
    return SpacePosition(x, y, math.atan2(y, x));
  }

  Velocity _getVelocity(
      double deltaTime, Velocity velocity, Acceleration acceleration) {
    final vx = velocity.x + acceleration.x * deltaTime;
    final vy = velocity.y + acceleration.y * deltaTime;
    return Velocity(vx, vy);
  }

  Acceleration _getAcceleration(
      SpacePosition position, List<Planet> otherPlanets) {
    final dx = 0.0 - position.x;
    final dy = 0.0 - position.y;
    final distanceSquared = dx * dx + dy * dy;
    final force = (SpaceSimulation.g * SpaceSimulation.centerMass) /
        (distanceSquared *
            math.sqrt(distanceSquared + SpaceSimulation.softeningConstant));

    var ax = force * dx;
    var ay = force * dy;

    if (otherPlanets != null && otherPlanets.isNotEmpty) {
      for (var planet in otherPlanets) {
        final odx = planet.position.x - position.x;
        final ody = planet.position.y - position.y;
        final oDistanceSquared = odx * odx + ody * ody;
        final oForce = (SpaceSimulation.g * planet.mass) /
            (oDistanceSquared *
                math.sqrt(
                    oDistanceSquared + SpaceSimulation.softeningConstant));
        ax += odx * oForce;
        ay += ody * oForce;
      }
    }

    return Acceleration(ax, ay);
  }
}

class Planet extends SpaceObject {
  final double radius;
  final double mass = 100.0;

  final textPainer = TextPainter(
    text: TextSpan(
      text: 'DARTOOINE',
      style: TextStyle(
        color: Colors.green[800],
        fontSize: 12,
      ),
    ),
    textDirection: TextDirection.ltr,
  );

  Planet(this.radius) {
    position = SpacePosition(radius, 0, 0);
    velocity = Velocity(
        0, -math.sqrt(SpaceSimulation.g * SpaceSimulation.centerMass / radius));
  }

  @override
  void update(double deltaTime, {List<Planet> otherPlanets}) {
    super.update(deltaTime);
  }

  void drawPlanet(Canvas canvas) {
    canvas.save();
    canvas.drawCircle(
        Offset(0, 0),
        radius,
        Paint()
          ..color = Colors.white.withOpacity(0.4)
          ..style = PaintingStyle.stroke);
    canvas.drawCircle(
        Offset(position.x, position.y), 10, Paint()..color = Colors.green[800]);

    textPainer.layout();
    textPainer.paint(canvas, Offset(position.x + 10, position.y));

    canvas.restore();
  }

  void drawPrediction(Canvas canvas) {
    // if (showPrediction) {
    canvas.save();
    if (positionPrediction.length > 1) {
      for (var i = 0; i < positionPrediction.length; i += 10) {
        canvas.drawCircle(
            Offset(positionPrediction[i].x, positionPrediction[i].y),
            10,
            Paint()..color = Colors.green[800].withOpacity(0.3));
      }
    }

    canvas.restore();
    // }
  }
}

class Rocket extends SpaceObject {
  final textPainter = TextPainter(
      text: TextSpan(text: '🚀', style: TextStyle(fontSize: 20)),
      textDirection: TextDirection.ltr);

  final rect = Rect.fromLTWH(0, 0, 5, 20);

  double fuelLevel = 100.0;
  bool showHistory = true;
  bool showPrediction = true;
  bool showDash = false;

  void drawRocket(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);
    if (showDash) {
      canvas.save();
      canvas.translate(-25, -25);
      canvas.scale(0.5);
      _getDash(canvas);
      canvas.restore();
    } else {
      canvas.rotate(position.alpha);
      textPainter.layout();
      // canvas.drawRect(rect, paint);
      canvas.rotate(-math.pi / 4);
      textPainter.paint(canvas, Offset(-20, -6));
    }

    canvas.restore();
  }

  void drawHistory(Canvas canvas) {
    if (showHistory) {
      canvas.save();
      if (positionHistory.length > 1) {
        final points = <Offset>[];
        for (var history in positionHistory) {
          points.add(Offset(history.x, history.y));
        }
        canvas.drawPoints(
          PointMode.points,
          points,
          historyPaint,
        );
      }

      canvas.restore();
    }
  }

  void drawPrediction(Canvas canvas) {
    if (showPrediction) {
      canvas.save();
      if (positionPrediction.length > 1) {
        final points = <Offset>[];
        for (var position in positionPrediction) {
          points.add(Offset(position.x, position.y));
        }
        canvas.drawPoints(PointMode.points, points, predictionPaint);
      }

      canvas.restore();
    }
  }

  @override
  void update(double deltaTime, {List<Planet> otherPlanets}) {
    super.update(deltaTime, otherPlanets: otherPlanets);
  }

  void increaseVelocity() {
    velocity = Velocity(velocity.x * 1.01, velocity.y * 1.01);
    fuelLevel -= 2.0;
  }

  void decreaseVelocity() {
    velocity = Velocity(velocity.x * 0.99, velocity.y * 0.99);
    fuelLevel -= 2.0;
  }

  void _getDash(Canvas canvas) {
    final body = Path()
      ..addOval(Rect.fromLTWH(
        10,
        10,
        100,
        100,
      ));
    final tail = Path()
      ..moveTo(0, 20)
      ..lineTo(40, 40)
      ..lineTo(40, 80)
      ..lineTo(0, 50);
    final wing = Path()
      ..moveTo(0, 40)
      ..lineTo(45, 40)
      ..relativeArcToPoint(Offset(0, 40), radius: Radius.circular(20))
      ..lineTo(15, 80)
      ..close();
    final tip = Path()
      ..moveTo(90, 50)
      ..lineTo(140, 60)
      ..lineTo(90, 60);
    final eye = Path()..addOval(Rect.fromLTWH(80, 40, 10, 10));
    final eyeWhite = Path()..addOval(Rect.fromLTWH(82.5, 42.5, 3, 3));
    final top = Path()..addOval(Rect.fromLTWH(50, 6, 20, 10));

    final faceWhite = Path()
      ..moveTo(90, 50)
      ..relativeArcToPoint(Offset(-0, 50),
          radius: Radius.circular(15), clockwise: false)
      ..lineTo(100, 90)
      ..lineTo(110, 80);

    canvas.drawPath(body, Paint()..color = Colors.blue[300]);
    canvas.drawPath(tail, Paint()..color = Colors.teal[400]);
    canvas.drawPath(faceWhite, Paint()..color = Colors.white.withOpacity(0.8));
    canvas.drawPath(wing, Paint()..color = Colors.blue[500]);
    canvas.drawPath(tip, Paint()..color = Colors.brown[400]);
    canvas.drawPath(eye, Paint()..color = Colors.black);
    canvas.drawPath(eyeWhite, Paint()..color = Colors.white);
    canvas.drawPath(top, Paint()..color = Colors.blue[400]);
  }
}

class Acceleration {
  final double x;
  final double y;

  Acceleration(this.x, this.y);
}

class Velocity {
  final double x;
  final double y;

  Velocity(this.x, this.y);
}

class SpacePosition {
  final double x;
  final double y;
  final double alpha;

  SpacePosition(this.x, this.y, this.alpha);

  @override
  String toString() => '${x.toStringAsFixed(2)} ${y.toStringAsFixed(2)}';
}

class Maneuver {
  Maneuver(this.velocity, this.position);

  double get deltaV =>
      math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y);
  final Velocity velocity;
  final SpacePosition position;
}


