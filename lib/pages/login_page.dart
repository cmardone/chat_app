import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/themes/app_theme.dart';
import 'package:chat_app/widgets/custom_text_input.dart';
import 'package:chat_app/widgets/login_button.dart';
import 'package:chat_app/widgets/login_labels.dart';
import 'package:chat_app/widgets/login_logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LoginLogo(title: 'Messenger'),
                _LoginForm(),
                LoginLabels(route: 'register'),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.9,
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      child: Column(
        children: [
          CustomTextInput(
            icon: Icons.email_outlined,
            placeholder: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomTextInput(
            icon: Icons.vpn_key_outlined,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.text,
            textController: passwordController,
            isPassword: true,
          ),
          LoginButton(
            text: 'Ingresar',
            onPressed: authService.isLoggingIn
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    if (loginOk) {
                      await socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else
                      showAlert(context, 'Login incorrecto',
                          'Favor revise sus credenciales');
                  },
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
    );
  }
}
