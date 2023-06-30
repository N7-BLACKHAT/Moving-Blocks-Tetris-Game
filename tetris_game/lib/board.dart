import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris_game/piece.dart';
import 'package:tetris_game/pixel.dart';
import 'package:tetris_game/values.dart';
import 'package:audioplayers/audioplayers.dart';

/*

GAME BOARD
  This is 2x2 grid with null represnting empty space.
  A non empty space will have a color to represent the landed pieces.

*/

//create game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

AudioPlayer audioPlayer = AudioPlayer();

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  //curent score
  int currentScore = 0;

  //game over status
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    //start music
    playMusic();
    //start game when app opens
    startGame();
    //playMusic();
  }

  void startGame() {
    currentPiece.initializePiece();

    //frame refresh rate
    Duration frameRate = const Duration(milliseconds: 800); //speed of game
    gameLoop(frameRate);
  }

  //play music in app
  Future<void> playMusic() async {
    await audioPlayer.play('lib/assets/music/bgm.mp3', isLocal: true);
  }

  //game Loop
  void gameLoop(Duration frameRate) {
    //every 400ms move piece down
    Timer.periodic(frameRate, (timer) {
      setState(() {
        //clear lines
        clearLines();

        //check landing
        checkLanding();

        //check if game is over
        if (gameOver == true) {
          timer.cancel();
          showGameOverDialog();
        }
        //move piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  //GAME OVER DIALOG METHOD
  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text("Your Score is: $currentScore"),
        actions: [
          TextButton(
              onPressed: () {
                //reset the game
                resetGame();
                Navigator.pop(context);
              },
              child: const Text('Play Again'))
        ],
      ),
    );
  }

  //reset game
  void resetGame() {
    //clear the game board
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    //new game
    gameOver = false;
    currentScore = 0;

    //create new piece
    createNewPiece();

    //start game again
    startGame();
  }

  //check for collision detection
  //return true -> if collision
  //return flase -> if no collision
  bool checkCollision(Direction direction) {
    //loop through each position of current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      //calculate the row and column of current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      //adjust the row and column based on direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      //check if piece is out of bounds( either too low or far or left or right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
      //check if already occupied by another piece in game board
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }
    //if no collisons detected
    return false;
  }

  void checkLanding() {
    //if going down is occupied
    if (checkCollision(Direction.down)) {
      //mark as occupied on game board
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      //once landed create a new piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    //create random object to generate new Tetromino type
    Random rand = Random();

    //create a new piece with random type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    /*
  Since our game over condition is if there is a piece at the top level,
  you want to check game is over when you create a new piece instaed of
  checking every frame, because new pieces are allowed to go through the top level
  but if there is already a piece int he top level when the new piece is created
  , then the game is over 
   */

    if (isGameOver()) {
      gameOver = true;
    }
  }

  //move left function
  void moveLeft() {
    //make sure the piece is valid before we move there
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  //move right function
  void moveRight() {
    //make sure the piece is valid before we move there
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  //rotate piece  function
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  //clear lines
  void clearLines() {
    //step 1: Loop through each row from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      //step 2: Initialize a variable to check if row id full
      bool rowIsFull = true;

      //step 3: Check if row is full(all columns in the row are full of pieces)
      for (int col = 0; col < rowLength; col++) {
        //if there is a empty column set rowIsFull to false and break the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      //step 4: if the row is full, clear the row and shift rows down
      if (rowIsFull) {
        //step 5: move all the rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          //copy the row above to the current row
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        //step 6: set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);

        //increase the score
        currentScore++;
      }
    }
  }

  //CURRENT SCORE METHOD
  bool isGameOver() {
    //check if any column in the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    //if top row is empty , return false
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: rowLength * colLength, //grid size
                physics:
                    const NeverScrollableScrollPhysics(), //should not scroll
                //making grid
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength),
                itemBuilder: (context, index) {
                  //get row and col of each index
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;

                  //current piece
                  if (currentPiece.position.contains(index)) {
                    return Pixel(
                      color: currentPiece.color,
                      //child: index,
                    );
                  }

                  //landed piece
                  else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(
                      color: tetrominoColors[tetrominoType], //child: '',
                    );
                  }

                  //blank piece
                  else {
                    return Pixel(
                      color: Colors.grey[900],
                      //child: index,
                    );
                  }
                }),
          ),

          //score
          Text(
            "Score: $currentScore",
            style: const TextStyle(color: Colors.white),
          ),

          //GAME CONTROLS
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //left
                IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios)),

                //rotate
                IconButton(
                    onPressed: rotatePiece,
                    color: Colors.white,
                    icon: const Icon(Icons.rotate_right)),

                //right
                IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
