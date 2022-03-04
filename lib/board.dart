import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'snake.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int x = 0;
  int y = 0;
  int xVel = 1;
  int yVel = 0;
  bool isCompleted = false;
  late final Timer timer;
  late int foodX;
  late int foodY;
  int length = 1;
  List<int> snakeX = [0];
  List<int> snakeY = [0];

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    x = 0;
    y = 0;
    xVel = 1;
    yVel = 0;
    isCompleted = false;
    length = 1;
    snakeX = [0];
    snakeY = [0];
    getFood();
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      moveSnake();
      eatFood();
    });
  }

  void moveSnake() {
    x += xVel * size;
    y += yVel * size;
    if (x >= width) {
      x = 0;
    }
    if (y >= height) {
      y = 0;
    }
    if (x < 0) {
      x = width;
    }
    if (y < 0) {
      y = height;
    }

    snakeX.insert(0, x);
    snakeY.insert(0, y);

    if (snakeX.length > length) {
      snakeX.removeLast();
      snakeY.removeLast();
    }
    checkDeath();
    setState(() {});
  }

  void getFood() {
    setState(() {
      foodX = Random().nextInt((width / size).floor()) * size;
      foodY = Random().nextInt((height / size).floor()) * size;
    });
  }

  void eatFood() {
    if (x == foodX && y == foodY) {
      length++;
      snakeX.add(snakeX.last);
      snakeY.add(snakeY.last);

      getFood();
      while (snakeX.contains(foodX) && snakeY.contains(foodY)) {
        getFood();
      }
    }
  }

  void checkDeath() {
    for (int i = 1; i < length; i++) {
      if (snakeX[0] == snakeX[i] && snakeY[0] == snakeY[i]) {
        isCompleted = true;
        timer.cancel();
      }
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (isCompleted) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        reset();
      }
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (yVel != 1) {
        xVel = 0;
        yVel = -1;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (yVel != -1) {
        xVel = 0;
        yVel = 1;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (xVel != 1) {
        xVel = -1;
        yVel = 0;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (xVel != -1) {
        xVel = 1;
        yVel = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: _handleKeyEvent,
        child: SafeArea(
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Score: ${length - 1}',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: height.toDouble(),
                  width: width.toDouble(),
                  color: Colors.black,
                  child: Stack(children: [
                    Positioned(
                        top: foodY.toDouble(),
                        left: foodX.toDouble(),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          width: size.toDouble() - 4,
                          height: size.toDouble() - 4,
                        )),
                    ...List.generate(
                        length,
                        (index) => Snake(
                              x: snakeX[index],
                              y: snakeY[index],
                            )),
                    Snake(
                      x: x,
                      y: y,
                    ),
                    Visibility(
                      visible: isCompleted,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'GAME OVER',
                              style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Press SPACE to restart',
                              style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
