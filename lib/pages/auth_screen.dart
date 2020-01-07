import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/login.dart';
import 'package:flutter_fire_plus/pages/login_phone.dart';
import 'package:flutter_fire_plus/pages/sign_up.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:flutter_fire_plus/widgets/divider.dart';
import 'package:flutter_fire_plus/utils/helper.dart';
import 'package:flutter_fire_plus/widgets/long_button.dart';

class Welcome extends StatelessWidget {
  static const routeName = '/welcome';

  const Welcome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Welcome'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 80,
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LongButton(
                label: 'Login with google',
                color: MyColors.googleColor,
                callback: () {
                  buildLoadingDialog(context);
                },
              ),
              buildSizedBox(val: 16),
              LongButton(
                label: 'Login with mobile',
                callback: () {
                  Navigator.of(context).pushNamed(LoginPhone.routeName);
                },
              ),
              buildSizedBox(val: 16),
              LongButton(
                label: 'Login with email',
                callback: () {
                  Navigator.of(context).pushNamed(Login.routeName);
                },
              ),
              MyDivider(),
              LongButton(
                label: 'CREATE ACCOUNT',
                callback: () {
                  Navigator.of(context).pushNamed(SignUpPage.routeName);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
