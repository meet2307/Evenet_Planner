import 'package:flutter/material.dart';

class CutomeTextWidget extends StatelessWidget {
  CutomeTextWidget({
    @required this.title,
    @required this.size,
  });
  final String title;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
          title,
          style: TextStyle(
            fontSize: size != null ? size : 20,
            color: Colors.black,
          ),
      ),
    );
  }
}
