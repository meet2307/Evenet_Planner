import 'package:flutter/material.dart';

class GradientAppbar extends StatelessWidget {
  GradientAppbar({
    @required this.start,
    @required this.end,
  });
  final Color start;
  final Color end;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[start, end],
          ),
        ),
    );
  }
}
