import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lashmeassignment/pages/home_page.dart';
import './pages/login_page.dart';
import './pages/forgot_page.dart';
import './pages/register_page.dart';
import './pages/verifyemail_page.dart';

import 'package:lashmeassignment/utils/routes.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        // "/" : (context) => LoginPage(),
        MyRoutes.homeRoute : (context) => HomePage(),
        MyRoutes.loginRoute : (context) => LoginPage(),
        MyRoutes.registerRoute : (context) => const RegisterPage(),
        MyRoutes.forgotRoute : (context) => const ForgotPage(),
        MyRoutes.verifyRoute : (context) => const VerifyEmailPage()
      },
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
       home: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError){
              return const Center(child: Text('Something went wrong!'));
            }
            else if(snapshot.hasData) {
              return const VerifyEmailPage();
            }
            else {
              return LoginPage();
            }
          }),

      );
  }
  @override
  void dispose() {
    super.dispose();
  }
}

