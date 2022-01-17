import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopinguser/pages/foodDetailPage.dart';
import 'package:shopinguser/pages/resultPage.dart';
import 'package:shopinguser/pages/shoppingCart.dart';
import 'package:shopinguser/pages/userHomePage.dart';
import 'authProfile/completeAllDetails.dart';
import 'authProfile/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});
  await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).platformBrightness == Brightness.light? FlutterStatusbarcolor.setStatusBarColor(Colors.indigo[800]):
    // FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: resultPage(),
      home: LoginPage(),
      // home: resultPage("Vasai Store"),
    );
  }
}
