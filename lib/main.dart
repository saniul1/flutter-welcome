import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/app.dart';
import 'package:flutter_fire_plus/pages/auth_screen.dart';
import 'package:flutter_fire_plus/pages/login.dart';
import 'package:flutter_fire_plus/pages/login_phone.dart';
import 'package:flutter_fire_plus/pages/sign_up.dart';
import 'package:flutter_fire_plus/providers/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Fire Plus',
          theme: ThemeData(
            primaryColor: const Color(0xFFE43F3F),
            // accentColor: const Color(0xFFCC1D1D),
          ),
          initialRoute: auth.isAuth ? MyHomePage.routeName : Welcome.routeName,
          routes: {
            Welcome.routeName: (_) => Welcome(),
            MyHomePage.routeName: (_) => MyHomePage(),
            SignUpPage.routeName: (_) => SignUpPage(),
            Login.routeName: (_) => Login(),
            LoginPhone.routeName: (_) => LoginPhone(),
          },
        ),
      ),
    );
  }
}
