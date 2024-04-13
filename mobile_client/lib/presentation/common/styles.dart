import 'package:flutter/material.dart';

const pinkMain = Color(0xFFFF00C7);
const greenMain = Color(0xFF03FE33);
const bgMain = Color(0xFF222222);
const textInverted = Color(0xFF111111);
const textMain = Color(0xFFFFFFFF);
const textMinor = Color(0xFF6c757d);

const bgGradient = LinearGradient(
  begin: Alignment(-2, -2),
  colors: [pinkMain, greenMain],
  tileMode: TileMode.mirror,
  end: Alignment(2, 2),
);

extension ThemeD on BuildContext {
  ThemeData get theme => Theme.of(this);
}
