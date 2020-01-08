import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/app.dart';
import 'package:flutter_fire_plus/pages/auth_screen.dart';
import 'package:flutter_fire_plus/pages/enter_otp.dart';
import 'package:flutter_fire_plus/pages/login.dart';
import 'package:flutter_fire_plus/pages/login_phone.dart';
import 'package:flutter_fire_plus/pages/sign_up.dart';
import 'package:flutter_fire_plus/pages/splash_screen.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final Map pages = {
    Welcome.routeName: (settings) => MaterialPageRoute(
          builder: (context) => Welcome(),
          settings: settings,
        ),
    MyHomePage.routeName: (settings) => MaterialPageRoute(
          builder: (context) => MyHomePage(),
          settings: settings,
        ),
    SignUpPage.routeName: (settings) => MaterialPageRoute(
          builder: (context) => SignUpPage(),
          settings: settings,
        ),
    Login.routeName: (settings) => MaterialPageRoute(
          builder: (context) => Login(),
          settings: settings,
        ),
    LoginPhone.routeName: (settings) => MaterialPageRoute(
          builder: (context) => LoginPhone(),
          settings: settings,
        ),
    EnterOtp.routeName: (settings) => MaterialPageRoute(
          builder: (context) => EnterOtp(
            id: settings.arguments.id,
            phoneNumber: settings.arguments.no,
          ),
          settings: settings,
        ),
  };

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
            primaryColor: MyColors.secondaryColor,
          ),
          home: FutureBuilder(
            future: auth.checkAuth(),
            builder: (context, authResultSnapshot) {
              return authResultSnapshot.connectionState ==
                      ConnectionState.waiting
                  ? SplashScreen()
                  : authResultSnapshot.data == true ? MyHomePage() : Welcome();
            },
          ),
          onGenerateRoute: (settings) {
            return pages[settings.name](settings);
          },
        ),
      ),
    );
  }
}
