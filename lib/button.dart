import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  const MyButton({super.key, required this.text, required this.onClicked});

  @override
  Widget build(BuildContext context) => ElevatedButton(
      onPressed: onClicked,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
        shape: StadiumBorder(),
      ),
      child: FittedBox(
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ));
}
