import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchatfirebase/services/auth/auth_service.dart';
import 'package:groupchatfirebase/components/my_button.dart';
import 'package:groupchatfirebase/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  // email và pass
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // tap to register
  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  }); // Sửa lại constructor

  // login button
  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text,
        _pwController.text,
      );
    }
    // catch any errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
            ),

            SizedBox(height: 50),

            // welcome back messenger
            Text(
              "Welcome to messenger",
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            SizedBox(height: 25),

            // email
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            SizedBox(height: 10),

            // pass
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            SizedBox(height: 25),

            // login button
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),

            SizedBox(height: 25),

            // register button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? "),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
