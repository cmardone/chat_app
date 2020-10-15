import 'package:flutter/material.dart';

class LoginLabels extends StatelessWidget {
  final String route;
  final String questionText;
  final String actionText;

  const LoginLabels({
    @required this.route,
    this.questionText = '¿No tienes una cuenta?',
    this.actionText = 'Crea una ahora!',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          questionText,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => Navigator.pushReplacementNamed(context, route),
        ),
      ],
    );
  }
}
