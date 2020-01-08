import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/app.dart';
import 'package:flutter_fire_plus/pages/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/pages/sign_up.dart';
import 'package:flutter_fire_plus/widgets/divider.dart';
import 'package:flutter_fire_plus/widgets/long_button.dart';
import 'package:flutter_fire_plus/widgets/input_field.dart';
import 'package:flutter_fire_plus/utils/helper.dart';
import 'package:flutter_fire_plus/widgets/long_flat_button.dart';
import 'package:flutter_fire_plus/models/http_exception.dart';

class Login extends StatelessWidget {
  static const routeName = '/login';
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      if (!_formKey.currentState.validate()) {
        return; // Invalid!
      }
      buildLoadingDialog(context);
      _formKey.currentState.save();
      try {
        final _userId = await Provider.of<Auth>(context, listen: false).signIn(
          _authData['email'],
          _authData['password'],
        );
        print('Signed_in_user: $_userId');
        Navigator.pop(context);
        if (_userId != null && _userId.length > 0) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              MyHomePage.routeName, ModalRoute.withName(Welcome.routeName));
        }
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('WRONG_PASSWORD')) {
          errorMessage = 'The given password is wrong.';
        } else if (error.toString().contains('USER_NOT_FOUND')) {
          errorMessage = 'Make sure user exist';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password.';
        }
        Navigator.pop(context);
        showErrorDialog(context, errorMessage);
      } catch (error) {
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        Navigator.pop(context);
        showErrorDialog(context, errorMessage);
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          height: MediaQuery.of(context).size.height - 80,
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InputField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value.trim();
                  },
                ),
                buildSizedBox(),
                InputField(
                  label: 'Password',
                  obscureText: true,
                  onSaved: (value) {
                    _authData['password'] = value.trim();
                  },
                ),
                buildSizedBox(val: 32),
                LongButton(
                  label: 'login',
                  callback: _submit,
                ),
                MyDivider(),
                LongFlatButton(
                  label: 'Don\'t have an Account? Signup',
                  callback: () => Navigator.of(context)
                      .popAndPushNamed(SignUpPage.routeName),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
