import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Color color;
  final double fontSize;
  final Function onPressed;
  final String text;
  final Color textColor;

  const LoginButton({
    this.color = Colors.blue,
    this.fontSize = 18,
    @required this.onPressed,
    @required this.text,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      child: Container(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ),
        height: 50,
        width: double.infinity,
      ),
      elevation: 2,
      highlightElevation: 5,
      onPressed: onPressed,
      shape: StadiumBorder(),
    );
  }
}
