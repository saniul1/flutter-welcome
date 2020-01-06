import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/sign_up.dart';
import 'package:flutter_fire_plus/widgets/divider.dart';
import 'package:flutter_fire_plus/widgets/long_button.dart';
import 'package:flutter_fire_plus/widgets/input_field.dart';
import 'package:flutter_fire_plus/widgets/long_flat_button.dart';

class LoginPhone extends StatelessWidget {
  static const routeName = '/login-phone';
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                  lable: 'Phone No.',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty || value.length < 10) {
                      return 'Invalid phone number!';
                    }
                    return null;
                  },
                ),
                buildSizedBox(val: 32),
                LongButton(
                  label: 'get otp',
                  callback: () {
                    if (_formKey.currentState.validate()) {}
                  },
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

  SizedBox buildSizedBox({val = 16}) {
    return SizedBox(
      height: double.parse(val.toString()),
    );
  }
}
