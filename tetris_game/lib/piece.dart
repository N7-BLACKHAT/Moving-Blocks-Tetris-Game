import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris_game/board.dart';
import 'package:tetris_game/values.dart';

class Piece {
  //type of tetris piece
  Tetromino type;

  Piece({required this.type});

  //the piece is list of integers
  List<int> position = [];

  //color of tetris piece
  Color get color {
    return tetrominoColors[type] ?? const Color(0xFFFFFFFF);
  }

  //generate the integers
  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [
          -26,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.J:
        position = [
          -25,
          -15,
          -5,
          -6,
        ];
        break;
      case Tetromino.I:
        position = [
          -4,
          -5,
          -6,
          -7,
        ];
        break;
      case Tetromino.O:
        position = [
          -15,
          -16,
          -5,
          -6,
        ];
        break;
      case Tetromino.S:
        position = [
          -15,
          -14,
          -6,
          -5,
        ];
        break;
      case Tetromino.Z:
        position = [
          -17,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.T:
        position = [
          -26,
          -16,
          -6,
          -15,
        ];
        break;
      default:
    }
  }

  //move piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  //rotate piece
  int rotationState = 1;
  void rotatePiece() {
    //new position
    List<int> newPosition = [];
    //rotate the piece based on it's type
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            /*
          
          o
          o
          o o

           */
            //get new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];

            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*

          o o o
          o 

          */
            //get new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*

          o o
            o
            o

           */
            //get new position
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*

              o        
          o o o

           */
            //get new position
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      case Tetromino.J:
        switch (rotationState) {
          case 0:
            /*
          
            o
            o
          o o

           */
            //get new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];

            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*
          
          o
          o o o
          */
            //get new position
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*

          o o
          o
          o

           */
            //get new position
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*
       
          o o o
              o

           */
            //get new position
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLength + 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.I:
        switch (rotationState) {
          case 0:
            /*
          
          o o o o

           */
            //get new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];

            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*

          o
          o
          o
          o 

          */
            //get new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*
          
          o o o o

           */
            //get new position
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*

          o
          o
          o
          o 

          */
            //get new position
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - 2 * rowLength,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      case Tetromino.O:
        /*
      O does not need rotation
       */
        break;

      case Tetromino.S:
        switch (rotationState) {
          case 0:
            /*
          
            o o
          o o

           */
            //get new position
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];

            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*
          
          o 
          o o
            o

           */
            //get new position
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*
          
            o o
          o o

           */
            //get new position
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*
          
          o 
          o o
            o

           */
            //get new position
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            /*
          
          o o
            o o

           */
            //get new position
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];

            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*

            o
          o o 
          o 

          */
            //get new position
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*
          
          o o
            o o

           */
            //get new position
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*

            o
          o o 
          o 

          */
            //get new position
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            /*
          
          o
          o o
          o 

           */
            //get new position
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[2] + 1,
              position[2] + rowLength,
            ];

            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*

          o o o
            o 

          */
            //get new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*

            o
          o o
            o

           */
            //get new position
            newPosition = [
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + rowLength,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*

            o        
          o o o

           */
            //get new position
            newPosition = [
              position[2] - rowLength,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            //check this new position is valid move before assigning it to real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
      default:
    }
  }

  //check valid position
  bool positionIsValid(int position) {
    //get row and col of  position
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    //if position is taken return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }
    //otherwise posution is valid return true
    else {
      return true;
    }
  }

  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      //return false is position is already taken
      if (!positionIsValid(pos)) {
        return false;
      }

      //get col of position
      int col = pos % rowLength;

      //if first and last column is occupied
      if (col == 0) {
        //first column
        firstColOccupied = true;
      }
      if (col == rowLength - 1) {
        //last column
        lastColOccupied = true;
      }
    }
    //if there is a piece in the first and last col, it is going through wall
    return !(firstColOccupied && lastColOccupied);
  }
}
