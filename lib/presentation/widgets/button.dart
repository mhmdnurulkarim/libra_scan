import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onPressed;
  final Color color;
  final String text;
  final double size;

  const Button({
    required this.onPressed,
    required this.color,
    required this.text,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        maximumSize: Size(double.infinity, 50),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}