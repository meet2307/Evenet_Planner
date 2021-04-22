import 'package:flutter/material.dart';

class PopUpMenuItem extends StatelessWidget {
  PopUpMenuItem({
    this.child,
    this.color,
    this.borderRadius: 2.0,
    this.height: 50.0,
    this.onPressed,
    this.icon,
    this.title,
  }) : assert(borderRadius != null);
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;
  final Icon icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      child: Row(
        children: [
          Icon(
            icon.icon,
            color: Colors.black54,
            size: 22.0,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
