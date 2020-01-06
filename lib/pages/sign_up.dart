import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/login.dart';
import 'package:flutter_fire_plus/widgets/divider.dart';
import 'package:flutter_fire_plus/widgets/long_button.dart';
import 'package:flutter_fire_plus/widgets/input_field.dart';
import 'package:flutter_fire_plus/widgets/long_flat_button.dart';

class SignUpPage extends StatelessWidget {
  static const routeName = '/sign-up';
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Signup'),
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
                  lable: 'Name',
                ),
                buildSizedBox(),
                InputField(
                  lable: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                ),
                buildSizedBox(),
                InputField(
                  lable: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                ),
                buildSizedBox(),
                InputField(
                  lable: 'Confirm Password',
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
                  callback: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid.

                    }
                  },
                ),
                MyDivider(),
                LongFlatButton(
                  label: 'Already have an Account? Login',
                  callback: () =>
                      Navigator.of(context).popAndPushNamed(Login.routeName),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildSizedBox({val = 16}) {
    return SizedBox(
      height: double.parse(val.toString()),
    );
  }
}
