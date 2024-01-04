import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/bomb.dart';
import 'package:flutter_application_2/numberbox.dart';
import 'package:quiver/async.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'minesweep',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MineSweeper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // variables
  int numberOfSquares = 9 * 9;
  int numberInEachRow = 9;
  var squareStatus = [];
  final List<int> bomblocation = [
    1,
    5,
    8,
    45,
    22,
    9,
    44,
    34,
    11,
    74,
    33,
    55,
  ];
  bool bombsRevealed = false;
  void randList() {
    final random = new Random();
    bomblocation.removeRange(0, bomblocation.length);
    for (var i = 0; i < 20; i++) {
      final intValue = random.nextInt(numberOfSquares);
      bomblocation.add(intValue);
    }
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add([0, false]);
    }
    scanBombs();
  }

  void restartGame() {
    setState(() {
      bombsRevealed = false;
      for (int i = 0; i < numberOfSquares; i++) {
        squareStatus[i][1] = false;
      }
    });
    randList();
    startTimer();
  }

  void revealBoxNumbers(int index) {
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });
    } else if (squareStatus[index][0] == 0) {
      setState(() {
        squareStatus[index][1] = true;
        //left box
        if (index % numberInEachRow != 0) {
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }
          squareStatus[index - 1][1] = true;
        }

        //top-left box
        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
              squareStatus[index - 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }

          squareStatus[index - 1 - numberInEachRow][1] = true;
        }

        //top box
        if (index >= numberInEachRow) {
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }
          squareStatus[index - numberInEachRow][1] = true;
        }

        //top-right box
        if (index >= numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
              squareStatus[index + 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 - numberInEachRow);
          }
          squareStatus[index + 1 - numberInEachRow][1] = true;
        }

        //right box
        if (index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }
          squareStatus[index + 1][1] = true;
        }

        //bottom-right box
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
              squareStatus[index + 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 + numberInEachRow);
          }
          squareStatus[index + 1 + numberInEachRow][1] = true;
        }

        //bottom box
        if (index < numberOfSquares - numberInEachRow) {
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }
          squareStatus[index + numberInEachRow][1] = true;
        }

        //bottom-left box
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != 0) {
          if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
              squareStatus[index - 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 + numberInEachRow);
          }
          squareStatus[index - 1 + numberInEachRow][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      int numberOfBombsAround = 0;

      //left
      if (bomblocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }
      //top-left
      if (bomblocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }
      //top
      if (bomblocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }
      //top-right
      if (bomblocation.contains(i + 1 - numberInEachRow) &&
          i >= numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }
      //right
      if (bomblocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }
      //bottom-right
      if (bomblocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }
      //bottom
      if (bomblocation.contains(i + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }
      //bottom-left
      if (bomblocation.contains(i - 1 + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow &&
          i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }
      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerlost() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: Center(
              child: Text('oh no, YOU LOST ツ',
                  style: TextStyle(color: Colors.red[200])),
            ),
            actions: [
              MaterialButton(
                color: Colors.grey[100],
                onPressed: () {
                  restartGame();
                  Navigator.pop(context);
                },
                child: Icon(Icons.refresh),
              )
            ],
          );
        });
  }

  void playerwon() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: Center(
              child: Text('Suey,YOU WON, i guess :-/',
                  style: TextStyle(color: Colors.green[200])),
            ),
            actions: [
              MaterialButton(
                color: Colors.grey[100],
                onPressed: () {
                  restartGame();
                  Navigator.pop(context);
                },
                child: Icon(Icons.refresh),
              )
            ],
          );
        });
  }

  void checkwinner() {
    int unrevealedBoxes = 0;
    for (int i = 0; i < numberOfSquares; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }
    if (unrevealedBoxes == bomblocation.length) {
      playerwon();
    }
  }

  late Timer _timer;
  int _start = 50;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _start = 50;
    _timer.cancel();
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          playerlost();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100),

            //Gamestat
            Container(
              height: 150,
              //color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //DISPLAY NUMBER OF BOMBS
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(bomblocation.length.toString(),
                          style: TextStyle(fontSize: 40)),
                      Text('B O M B'),
                    ],
                  ),

                  //BUTTON TO REFRESH THE GAME
                  GestureDetector(
                    onTap: restartGame,
                    child: Card(
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 40,
                      ),
                      color: Colors.grey[700],
                    ),
                  ),

                  //DISPLAY TIME TAKENs
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$_start', style: TextStyle(fontSize: 40)),
                      Text('T I M E'),
                    ],
                  ),
                ],
              ),
            ),
            //grid
            Expanded(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: numberInEachRow),
                  itemBuilder: (context, index) {
                    if (bomblocation.contains(index)) {
                      return MyBomb(
                        revealed: bombsRevealed,
                        function: () {
                          //whe the bomb is tapped the player loses
                          setState(() {
                            bombsRevealed = true;
                          });
                          playerlost();
                        },
                      );
                    } else {
                      return MyNumberBox(
                        child: squareStatus[index][0],
                        revealed: squareStatus[index][1],
                        function: () {
                          //reveal current box
                          revealBoxNumbers(index);
                          checkwinner();
                        },
                      );
                    }
                  }),
            ),

            //branding
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child:
                  Text('C R E A T E D B Y W A L T E R D A C O N C E I C A O'),
            )
          ],
        ),
      ),
    );
  }
}
