import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchatfirebase/components/my_button.dart';
import 'package:groupchatfirebase/components/my_textfield.dart';
import 'package:groupchatfirebase/services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // tap to register
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  // register menthod
  void register(BuildContext context) {
    // get auth service
    final _auth = AuthService();

    // password match and create user
    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    // password dont match => show error to user

    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password don't match!"),
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
              "Let's create an account for you ",
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

            SizedBox(height: 10),

            // confirm pass
            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confirmPwController,
            ),

            SizedBox(height: 25),

            // login button
            MyButton(
              text: "Register",
              onTap: () => register(context),
            ),

            SizedBox(height: 25),

            // register button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an accound "),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
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
