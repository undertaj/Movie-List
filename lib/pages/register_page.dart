import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/routes.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/services.dart';


class  RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name = "";
  bool changeButton = false;
  final formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _passwordVisible = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: Column(
                      children: [
                        SizedBox(height: 95.0),
                        const Text(
                            "We're excited to have you onboard with us !!!",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepPurple)

                        ),
                        SizedBox(height: 95.0),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter First Name",
                            labelText: "First Name",
                          ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if(value!.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)){
                                return 'Enter correct first name';
                              }else {
                                return null;
                              }
                            }

                        ),
                        SizedBox(height: 10),// Name
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter Last Name",
                            labelText: "Last Name",
                          ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if(value!.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)){
                                return 'Enter correct last name';
                              }else {
                                return null;
                              }
                            }
                        ),
                        SizedBox(height: 10),// LastName
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.email, color: Colors.deepPurple,
                            ),
                            hintText: "Enter Email ID",
                            labelText: "Email ID",
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
                        SizedBox(height: 10),// Email
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                (_passwordVisible) ? Icons.visibility : Icons.visibility_off,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            hintText: "Enter password",
                            labelText: "Password",
                          ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if(value!.isEmpty) {
                                return 'Password cannot be empty';
                              }
                              else if(!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[_!@#$&*]).{8,15}$').hasMatch(value)){
                                return 'Enter a Strong Password (Atleast one upperCase, one \nlowercase, one digit and one special character)';
                              }else {
                                return null;
                              }
                            }
                        ),// Password
                        SizedBox(height: 40.0,),
                        ElevatedButton(
                          child: Text("Sign Up", style: TextStyle(fontSize: 15),),
                          style: TextButton.styleFrom(minimumSize: Size(100, 40)),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // Navigator.pushNamed(context, MyRoutes.homeRoute);
                              signUp();
                            }
                          },
                        ),
                        SizedBox(height: 50.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already A User ?    ", style: TextStyle(fontSize: 16),),
                            InkWell(
                                child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.bold),),
                                onTap: () {
                                    Navigator.pushNamed(context, MyRoutes.loginRoute);
                                }
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString()), backgroundColor: Colors.deepPurple,));
      // Utils.showSnackBar(e.toString());
    }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
