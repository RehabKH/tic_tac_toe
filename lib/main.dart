import 'package:flutter/material.dart';
import 'package:tic_tac_toe/ui/theme/color.dart';
import 'package:tic_tac_toe/utils/game_logic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> scoreBoard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; // score of different combination of game [Row1,2,3, col1,2,3, diagnose 1, 2,3]
  String lastValue = "X";
  Game game = new Game();
  bool gameOver = false;
  int turn = 0;
  String result = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It's ${lastValue} Turn".toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 58),
          ),
          SizedBox(
            height: 20,
          ),
          //here draw board
          Container(
            width: boardWidth,
            height: boardWidth,
            child: GridView.count(
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: EdgeInsets.all(16),
              crossAxisCount:
                  Game.boardLength ~/ 3, // ~/ operator to return integer result
              children: List.generate(Game.boardLength, (index) {
                return InkWell(
                  onTap: gameOver
                      ? null
                      : () {
                          if (game.board![index] == "") {
                            setState(() {
                              game.board![index] = lastValue;
                              turn++;
                              gameOver =game.winnerCheck(lastValue, index, scoreBoard, 3);
                              if (gameOver) {
                                result = "$lastValue is The Winner";
                              }
                              (lastValue == "X")
                                  ? lastValue = "O"
                                  : lastValue = "X";
                            });
                          }
                          // if (game.board!.length == Game.boardLength) {
                          //   setState(() {
                          //     gameOver = true;
                          //   });
                          // }
                        },
                  child: Container(
                    height: Game.blocSize,
                    width: Game.blocSize,
                    decoration: BoxDecoration(
                        color: MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Text(
                        game.board![index],
                        style: TextStyle(
                            fontSize: 58,
                            color: game.board![index] == "X"
                                ? Colors.blue
                                : Colors.pink),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 25),
          Text(
            result,
            style: TextStyle(color: Colors.purple, fontSize: 52),
          ),
          SizedBox(height: 25),

          ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  game.board = Game.initGameBoard();
                  gameOver = false;
                  turn = 0;
                  result = "";
                  scoreBoard = [0, 0, 0, 0, 0, 0, 0, 0];
                });
              },
              icon: Icon(Icons.replay),
              label: Text("Repeat The Game"))
          // building winner check algorith
          // to do that declare scoreboard in our main file
        ],
      ),
    );
  }
}
