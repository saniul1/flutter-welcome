import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_fire_plus/services/analytics.dart';
import 'package:flutter_fire_plus/services/chats.dart';
// import 'package:flutter_fire_plus/services/notification.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/services/storage.dart';
import 'package:flutter_fire_plus/services/user_data.dart';

import 'package:flutter_fire_plus/styles/colors.dart';

import 'package:flutter_fire_plus/pages/profile.dart';
import 'package:flutter_fire_plus/pages/auth_screen.dart';
import 'package:flutter_fire_plus/pages/enter_otp.dart';
import 'package:flutter_fire_plus/pages/login.dart';
import 'package:flutter_fire_plus/pages/login_phone.dart';
import 'package:flutter_fire_plus/pages/sign_up.dart';
import 'package:flutter_fire_plus/pages/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final Map pages = {
    Welcome.routeName: (settings) => MaterialPageRoute(
          builder: (context) => Welcome(),
          settings: settings,
        ),
    ProfilePage.routeName: (settings) => MaterialPageRoute(
          builder: (context) => ProfilePage(),
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

  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: Analytics.analytics);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: UserData(),
        ),
        ChangeNotifierProvider.value(
          value: Storage(),
        ),
        ChangeNotifierProvider.value(
          value: Chats(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Notifications(),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: <NavigatorObserver>[observer],
          title: 'Flutter Fire Plus',
          theme: ThemeData(
            primaryColor: MyColors.secondaryColor,
            accentColor: MyColors.grey,
            fontFamily: 'Roboto',
          ),
          home: FutureBuilder(
            future: auth.checkAuth(),
            builder: (context, authResultSnapshot) {
              return authResultSnapshot.connectionState ==
                      ConnectionState.waiting
                  ? SplashScreen()
                  : authResultSnapshot.data == true ? ProfilePage() : Welcome();
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
