

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:my_app/utils/routes.dart';
import '../main.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final img = "https://stories.freepiklabs.com/storage/19513/forgot-password-amico-1951.png";
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Column(
          children: [
            Image.network(
                img,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 30.0,),
            const Text("Enter your email and we'll send you a link to get back into your account."),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter Email ID",
                labelText: "Email ID"
              ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if(value!.isEmpty ){
                    return 'Email cannot be empty';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)){
                    return 'Enter correct email';
                  } else {
                    return null;
                  }
                }

            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton.icon(
                style: TextButton.styleFrom(minimumSize: Size(100, 40)),
                icon: Icon(Icons.email_outlined),
                label: (const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 24),
                )),
              onPressed: () => resetPassword(),
            )
          ],
        ),
      ),
    );
  }
  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );
    try {

      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password Reset Email sent!'), backgroundColor: Colors.deepPurple,));
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password Reset Email sent!'), backgroundColor: Colors.deepPurple,));
      // Utils.showSnackBar('Password Reset Email sent!');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString()), backgroundColor: Colors.deepPurple,));
      // Utils.showSnackBar(e.toString());
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

