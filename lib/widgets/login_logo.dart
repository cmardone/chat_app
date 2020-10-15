import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  final String title;

  const LoginLogo({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset('assets/images/tag-logo.png'),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 30)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 100),
    );
  }
}
