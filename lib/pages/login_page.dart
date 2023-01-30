import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import './googlesignin_page.dart';

import 'package:provider/provider.dart';
import '../utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/services.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  bool changeButton = false;
  bool _passwordVisible  = false;
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
              SizedBox(height: 10,),
              Image.asset(
                "assets/images/homepage_pic.png",
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
              Text(
                "Welcome $name",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(
                            Icons.email, color: Colors.deepPurple, textDirection: TextDirection.ltr,
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
                        // onChanged: (value) {
                        //   name = value;
                        //
                        //   setState(() {});
                        //   },
                      ),// Email
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: !_passwordVisible,
                        controller: passwordController,
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
                            else if(!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$&*]).{8,15}$').hasMatch(value)){
                              return 'Enter a Strong Password (Atleast one upperCase, one lowercase, one digit and one special character)';
                            }else {
                              return null;
                            }
                          }
                      ),// Password
                      SizedBox(height: 40.0,),
                      // InkWell(
                      //   onTap: () async {
                      //     if (formKey.currentState!.validate()) {
                      //       const Text('Logging in');
                      //     }
                      //     else {
                      //       setState(() {
                      //         changeButton = true;
                      //       });
                      //       await Future.delayed(Duration(seconds: 1));
                      //       Navigator.pushNamed(context, MyRoutes.homeRoute);
                      //     }
                      //   },
                      //   child: AnimatedContainer(
                      //     duration: Duration(seconds: 1),
                      //     width: changeButton ? 50 : 150,
                      //     height: 50,
                      //     alignment: Alignment.center,
                      //     child: changeButton ? Icon(Icons.done, color: Colors.white,) : Text(
                      //       "Login",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 18),
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: Colors.deepPurple,
                      //       borderRadius:
                      //       BorderRadius.circular(changeButton ? 50 : 8),
                      //     ),
                      //   ),
                      // ),
                      ElevatedButton(
                        child: Text("Login", style: TextStyle(fontSize: 20)),
                        style: TextButton.styleFrom(minimumSize: Size(100, 40)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            signIn();
                          }
                          },
                          ),
                      const SizedBox(height: 20.0,),
                      ElevatedButton.icon(
                          label: const Text('Sign In with Google', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50)
                        ),
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.purpleAccent,),
                          onPressed: () {
                            final provider = Provider.of<GoogleSignInPage>(context, listen: false);
                                provider.googleLogin().then((_) => Navigator.pushNamed(context, MyRoutes.homeRoute));
                          },
                      ),
                      const SizedBox(height: 50.0,),
                      InkWell(
                          child: const Text("Forgot Password ?", style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.bold),),
                          onTap: () {
                            Navigator.pushNamed(context, MyRoutes.forgotRoute);
                          }
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't Have An Account ?    ", style: TextStyle(fontSize: 16),),
                          InkWell(
                              child: const Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.bold),),
                              onTap: () {
                                Navigator.pushNamed(context, MyRoutes.registerRoute);
                              }
                          ),
                        ],
                      ),
          ],
          ),
                ),
        )
      ],
    ),
    )
    );
  }
  Future signIn() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
    on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString()), backgroundColor: Colors.deepPurple,));
    }
    // Navigator.popUntil(context, (route) => MyRoutes.homeRoute.isEmpty);
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

