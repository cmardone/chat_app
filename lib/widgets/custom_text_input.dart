import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController textController;

  const CustomTextInput({
    this.icon = Icons.input_outlined,
    this.placeholder = '',
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5)
        ],
        color: Colors.white,
      ),
      child: TextField(
        autocorrect: false,
        controller: textController,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: placeholder,
          prefixIcon: Icon(icon),
        ),
        keyboardType: keyboardType,
        obscureText: isPassword,
      ),
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
    );
  }
}
