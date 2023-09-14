//https://codepen.io/aflutterdev/pen/WNrzerP


import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Game(),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
    ),
  );
}

class InheritedGame extends InheritedWidget {

  final _GameState state;

  InheritedGame({this.state, Widget child}): super(child:child);

  static InheritedGame of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<InheritedGame>();

  bool updateShouldNotify(InheritedGame oldWidget) {
    if(oldWidget.state != state) {
      return true;
    }
    if(oldWidget.state.aiScore != state.aiScore) {
      return true;
    }
    if(oldWidget.state.playerScore != state.playerScore) {
      return true;
    }
    return false;
  }

}

class Game extends StatefulWidget {

  @override
  _GameState createState() => _GameState();

}

class _GameState extends State<Game> {

  List board;

  int _playerScore = 0;
  int _aiScore = 0;
  bool _playerTurn = true;
  bool isOver = false;
  bool aiWon = false;
  bool playerWon = false;

  String get aiScore {
    return _aiScore.toString();
  }
  String get playerScore {
    return _playerScore.toString();
  }
  bool get playerTurn {
    return _playerTurn;
  }
  void buildBoard() {
    setState(() {
      board = [];
      for(int i=0; i<PenConfig.mapSize; i++) {
        board.add([]);
        for(int j=0; j<PenConfig.mapSize; j++) {
          board.elementAt(i).add(0);
        }
      }
    });
  }
  void resetBoard() {
    for(int i=0; i<PenConfig.mapSize; i++) {
      for(int j=0; j<PenConfig.mapSize; j++) {
        board[i][j] = 0;
      }
    }
  }
  void incrementScore([int by=1]) {
    setState(() {
      if(_playerTurn) {
        _playerScore += by;
      } else {
        _aiScore += by;
      }
    });
  }
  void incrementPlayerScore([int by=1]) {
    setState(() {
      _playerScore += by;
    });
  }
  void incrementAiScore([int by=1]) {
    setState(() {
      _aiScore += by;
    });
  }
  void toggleTurn() {
    setState(() {
      _playerTurn = !_playerTurn;
      if(!isOver && !_playerTurn && checkBoard()) {
        Timer(Duration(milliseconds: 500+math.Random().nextInt(1986)), () {playAI();});
      }
    });
  }
  void modifyBoard(Offset at) {
    setState(() {
      board[at.dx.toInt()][at.dy.toInt()] = _playerTurn?1:-1;
      isOver = checkGameOver();
      if(!isOver) {
        isOver = !checkBoard();
      } else { 
        playerWon=_playerTurn?true:false;
        aiWon = !playerWon;
        toggleTurn();
      }
      if(isOver) {
        gameOver();
      } else {
        if(_playerTurn) {
          toggleTurn();
        }
      }
    });
  }
  bool checkGameOver() {
    int sumDiag1 = 0;
    int sumDiag2 = 0;
    for(int i=0; i<PenConfig.mapSize; i++) {
      int sumRow = 0;
      int sumCol = 0;
      sumDiag1 += board[i][i];
      sumDiag2 += board[i][(PenConfig.mapSize-1)-i];
      for(int j=0; j<PenConfig.mapSize; j++) {
        sumRow += board[i][j];
        sumCol += board[j][i];
      }
      if(sumRow.abs() == PenConfig.mapSize || sumCol.abs() == PenConfig.mapSize) {
        return true;
      }
    }
    if(sumDiag1.abs() == PenConfig.mapSize || sumDiag2.abs() == PenConfig.mapSize) {
      return true;
    }
    return false;
  }
  bool checkBoard() {
    for(int i=0; i<PenConfig.mapSize; i++) {
      for(int j=0; j<PenConfig.mapSize; j++) {
        if(board[i][j] == 0) return true;
      }
    }
    return false;
  }
  bool checkBoardAt(Offset position) {
    return board[position.dx.toInt()][position.dy.toInt()] != 0;
  }
  int boardAt(Offset position) {
    return board[position.dx.toInt()][position.dy.toInt()];
  }
  void playAI([bool random=true]) {
    // should implement a proper AI
    List options = [];
    for(int i=0; i<PenConfig.mapSize; i++) {
      for(int j=0; j<PenConfig.mapSize; j++) {
        if(board[i][j] == 0) options.add(Offset(i.toDouble(),j.toDouble()));
      }
    }
    Offset randomOption = options.elementAt(0);
    if(options.length > 1) {
      randomOption = options.elementAt(math.Random().nextInt(options.length-1));
    }
    modifyBoard(randomOption);
    incrementScore();
    toggleTurn();
  }
  void gameOver() {
    if(aiWon) {
      incrementAiScore(PenConfig.winPoints);
    } else if(playerWon) {
      incrementPlayerScore(PenConfig.winPoints);
    } else {
      incrementAiScore(PenConfig.tiePoints);
      incrementPlayerScore(PenConfig.tiePoints);
    }
    Timer(const Duration(seconds: 5), () {reset();});
  }
  void reset() {
    setState(() {
      resetBoard();
      isOver = false;
      aiWon = false;
      playerWon = false;
      if(!_playerTurn && checkBoard()) {
        Timer(Duration(milliseconds: 500+math.Random().nextInt(1986)), () {playAI();});
      }
    });
  }

  @override
  void initState() {
    buildBoard();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return InheritedGame(
      state: this,
      child: TicTacToePen(),
    );
  }

}

class TicTacToePen extends StatefulWidget {

  @override
  _TicTacToePenState createState() => _TicTacToePenState();

}

class _TicTacToePenState extends State<TicTacToePen> {

  String get gameStatus {
    _GameState game = InheritedGame.of(context).state;
    if(game.isOver) {
      if(game.playerWon) {
        return 'You won!!!';
      }
      if(game.aiWon) {
        return 'You lost!';
      }
      return 'TIE';
    }
    return game.playerTurn?'Your turn...':'AI\'s turn...';
  } 
  
  @override
  Widget build(BuildContext context) {
    _GameState game = InheritedGame.of(context).state;
    return Scaffold(
      backgroundColor: PenColors.scaffold,
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height*0.05,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text('Tic-Tac-Toe', style: TextStyle(fontSize: 30), textAlign: TextAlign.center,),
            ),
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: PenConfig.mapSize*(PenConfig.tileSize+PenConfig.tileGap),
                height: PenConfig.mapSize*(PenConfig.tileSize+PenConfig.tileGap),
                child: Isometric(
                  child: Stack( 
                    alignment: Alignment.center,
                    children: [
                      ...List.generate(math.pow(PenConfig.mapSize, 2), (index) { 
                        Offset position = Offset((index~/PenConfig.mapSize).toDouble(), index%PenConfig.mapSize);
                        return Positioned(
                          top: position.dx * (PenConfig.tileSize+PenConfig.tileGap/2),
                          left: position.dy * (PenConfig.tileSize+PenConfig.tileGap/2),
                          child: IsoTile(position, index),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            left: game.playerTurn||game.isOver?MediaQuery.of(context).size.width*0.15:10, 
            bottom: game.playerTurn||game.isOver?MediaQuery.of(context).size.height*0.25:10,
            child: Column(
              children: [
                Text('You', style: TextStyle(fontSize: 24)),
                SizedBox(height: PenConfig.tileGap),
                Score(true)
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: !game.playerTurn||game.isOver?MediaQuery.of(context).size.width*0.15:10, 
            bottom: !game.playerTurn||game.isOver?MediaQuery.of(context).size.height*0.25:10,
            child: Column(
              children: [
                Text('The AI', style: TextStyle(fontSize: 24)),
                SizedBox(height: PenConfig.tileGap),
                Score(false),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height*0.15,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(gameStatus, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            ),
          ),
        ],
      ),
    );
  }
}

class IsoTile extends StatefulWidget {

  final Offset position;
  final int index;

  IsoTile(this.position, this.index);

  @override
  _IsoTileState createState() => _IsoTileState();
}

class _IsoTileState extends State<IsoTile> {
  
  bool used;
  Color color;
  String value;

  @override
  void initState() {
    used = false;
    color = Colors.white.withAlpha(125);
    value = '';
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    _GameState game = InheritedGame.of(context).state;
    setState(() {
      used = game.checkBoardAt(widget.position);
      if(used) {
        int usedBy = game.boardAt(widget.position);
        if(usedBy == 1) {
          color = PenColors.playerColor;
          value=PenConfig.playerSymbol;
        } else {
          color = PenColors.aiColor;
          value=PenConfig.aiSymbol;
        }
      } else {
        color = Colors.white60;
        value = '';
      }
    });
    return GestureDetector(
      onTap: () {
        setState(() {
          if(!game.isOver && game.playerTurn && !used) {
            value=game.playerTurn?PenConfig.playerSymbol:PenConfig.aiSymbol;
            color = game.playerTurn?PenColors.playerColor:PenColors.aiColor;
            game.incrementScore();
            game.modifyBoard(widget.position);
            used = true;
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: PenConfig.tileSize,
        height: PenConfig.tileSize,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: color,
          borderRadius: used?BorderRadius.circular(PenConfig.tileRadius):BorderRadius.circular(PenConfig.tileRadius*5),
        ),
        child: Unisometric(
          child: Text('$value', style: TextStyle(color: Colors.black, fontSize:30, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    super.dispose();
  }
}

class Isometric extends StatelessWidget {

  final Widget child;

  Isometric({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..rotateX(math.pi/3)
        ..rotateZ(math.pi/4),
      child: child
    );
  }

}

class Unisometric extends StatelessWidget {

  final Widget child;

  Unisometric({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..rotateZ(-math.pi/4)
        ..translate(0,0,20)
        ..rotateX(-math.pi/3),
      child: child
    );
  }

}

class Score extends StatefulWidget {

  final bool playerScore;
  Score(this.playerScore);

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {

  String get score {
    _GameState game = InheritedGame.of(context).state;
    return widget.playerScore?game.playerScore:game.aiScore;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.playerScore?'YOUR SCORE':'AI\'S SCORE',
      child: CircleAvatar(
        radius: PenConfig.tileSize/3,
        backgroundColor: widget.playerScore?PenColors.playerColor:PenColors.aiColor,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('$score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),),
        ),
      ),
    );
  }

}

class PenColors {
  static const scaffold = const Color(0xFF1a1b1d);
  static int playerColorIndex = math.Random().nextInt(Colors.primaries.length);
  static int aiColorIndex = differentColorIndex;
  static Color playerColor = Colors.primaries[playerColorIndex];//Colors.green[300];
  static Color aiColor = Colors.primaries[aiColorIndex];//Colors.blue[300];

  static int get differentColorIndex {
    var index;
    do {
      index = math.Random().nextInt(Colors.primaries.length);
    } while(index == playerColorIndex);
    return index;
  }
}

class PenConfig {
  static const num mapSize = 3;
  static const num tileSize = 100;
  static const num tileGap = 10;
  static const num tileRadius = 10;
  static const num winPoints = 10;
  static const num tiePoints = 5;
  //static const String playerSymbol = 'X';
  //static const String aiSymbol = 'O';
  static const String playerSymbol = '🌸';
  static const String aiSymbol = '🐝';
}
