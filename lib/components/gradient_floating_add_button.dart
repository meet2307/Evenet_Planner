import 'package:flutter/material.dart';

class GradientFloatingAddButton extends StatelessWidget {
  GradientFloatingAddButton({
    @required this.start,
    @required this.end,
    @required this.searchState,
  });
  final Color start;
  final Color end;
  final bool searchState;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Icon(!searchState ? Icons.add : Icons.clear),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [start, end],
        ),
      ),
    );
  }
}
