import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire_plus/pages/app.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/pages/login.dart';
import 'package:flutter_fire_plus/widgets/divider.dart';
import 'package:flutter_fire_plus/widgets/long_button.dart';
import 'package:flutter_fire_plus/widgets/input_field.dart';
import 'package:flutter_fire_plus/widgets/long_flat_button.dart';
import 'package:flutter_fire_plus/utils/helper.dart';
import 'package:flutter_fire_plus/models/http_exception.dart';

class SignUpPage extends StatelessWidget {
  static const routeName = '/sign-up';
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    'name': '',
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
        final _userId = await Provider.of<Auth>(context, listen: false).signUp(
          email: _authData['email'],
          password: _authData['password'],
          name: _authData['name'],
        );
        print('new_user: $_userId');
        Navigator.pop(context);
        if (_userId != null && _userId.length > 0) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              MyHomePage.routeName, (Route<dynamic> route) => false);
        }
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_ALREADY_IN_USE')) {
          errorMessage = 'This email address is already in use.';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
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
        title: Text('Sign up'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        InputField(
                          label: 'Name',
                          validator: (value) {
                            if (value.isEmpty || value.length < 3) {
                              return 'Name is too short!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['name'] = value;
                          },
                        ),
                        buildSizedBox(),
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
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty || value.length < 5) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value.trim();
                          },
                        ),
                        buildSizedBox(),
                        InputField(
                          label: 'Confirm Password',
                          obscureText: true,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          },
                        ),
                        buildSizedBox(val: 32),
                        LongButton(
                          label: 'create account',
                          callback: _submit,
                        ),
                        MyDivider(),
                        LongFlatButton(
                          label: 'Already have an Account? Login',
                          callback: () => Navigator.of(context)
                              .popAndPushNamed(Login.routeName),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
