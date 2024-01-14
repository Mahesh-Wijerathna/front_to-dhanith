import 'package:flutter/material.dart';
import 'package:snap2/dashboard.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/loginPage.dart';
import 'dart:developer' as dev;

void main() async {
  // show in console this is main function
  dev.log('This is main function');
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}



class MyApp extends StatelessWidget {
  final token;
  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SignInPage());
        
        // (token != null && JwtDecoder.isExpired(token) == false)
        //     ? Dashboard(token: token)
        //     : SignInPage());
  }
}
