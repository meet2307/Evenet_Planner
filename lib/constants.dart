import 'package:flutter/material.dart';

const kPrimaryColor =Color(0xFF6B71DF);

const kEditColor = Colors.blueAccent;
const kDeleteColor = Colors.redAccent;

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

// class GradientColors {
//   final List<Color> colors;
//   GradientColors(this.colors);
//
//   static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
//   static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
//   static List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
//   static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
//   static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
// }
//
// class GradientTemplate {
//   static List<GradientColors> gradientTemplate = [
//     GradientColors(GradientColors.sky),
//     GradientColors(GradientColors.sunset),
//     GradientColors(GradientColors.sea),
//     GradientColors(GradientColors.mango),
//     GradientColors(GradientColors.fire),
//   ];
// }