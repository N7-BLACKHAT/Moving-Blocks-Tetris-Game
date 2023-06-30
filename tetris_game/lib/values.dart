//grid dimensions
import 'package:flutter/material.dart';

int rowLength = 10;
int colLength = 15;

enum Direction {
  left,
  right,
  down,
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L:Color(0xFFFFA500),//Orange
  Tetromino.J:Color.fromARGB(255, 0, 102, 255),//blue
  Tetromino.I:Color.fromARGB(255, 242, 0, 255),//pink
  Tetromino.O:Color(0xFFFFFF00),//yellow
  Tetromino.S:Color(0xFF008000),//green
  Tetromino.Z:Color(0xFFFF0000),//red
  Tetromino.T:Color.fromARGB(255, 144, 0,255),//purple
};
