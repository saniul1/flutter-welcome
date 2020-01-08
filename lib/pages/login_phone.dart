import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/enter_otp.dart';
import 'package:flutter_fire_plus/pages/login.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:flutter_fire_plus/widgets/divider.dart';
import 'package:flutter_fire_plus/widgets/long_button.dart';
import 'package:flutter_fire_plus/widgets/input_field.dart';
import 'package:flutter_fire_plus/utils/helper.dart';
import 'package:flutter_fire_plus/widgets/long_flat_button.dart';
import 'package:flutter_fire_plus/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire_plus/services/auth.dart';

class LoginPhone extends StatefulWidget {
  static const routeName = '/login-phone';

  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class ScreenArguments {
  final String id;
  final String no;

  ScreenArguments({this.id, this.no});
}

class _LoginPhoneState extends State<LoginPhone> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _phoneNumber;
  final List<String> _countryCodes = ['91', '90', '80', '00'];
  String _countryCode = '91';

  @override
  Widget build(BuildContext context) {
    Future _onSuccess(String verificationId, [int forceResendingToken]) async {
      Navigator.of(context).pushNamed(EnterOtp.routeName,
          arguments: ScreenArguments(id: verificationId, no: _phoneNumber));
    }

    _onFailed(error) {
      String errorMessage = 'Could not complete action';
      if (error.code.toString().contains('invalidCredential')) {
        errorMessage = 'The given phone number is wrong.';
      } else if (error.code.toString().contains('quotaExceeded')) {
        errorMessage = 'Too many attempts with this number. Try again later.';
      }
      showErrorDialog(context, errorMessage);
    }

    _onTimeout(String verificationId) {
      showErrorDialog(context, 'Verification timed out.');
    }

    Future<void> _submit() async {
      if (!_formKey.currentState.validate()) {
        return; // Invalid!
      }
      buildLoadingDialog(context);
      _formKey.currentState.save();
      try {
        await Provider.of<Auth>(context, listen: false).verifyPhone(
          _phoneNumber,
          onFailed: _onFailed,
          onSuccess: _onSuccess,
          onTimeout: _onTimeout,
        );
        Navigator.pop(context);
      } on HttpException {
        var errorMessage = 'Authentication failed';
        Navigator.pop(context);
        showErrorDialog(context, errorMessage);
      } catch (error) {
        const errorMessage = 'For some reason it failed.';
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
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: MyColors.secondaryColor,
                  ),
                  child: DropdownButton<String>(
                    value: _countryCode,
                    icon: Row(
                      children: <Widget>[
                        Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Select Country Code',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    style: TextStyle(color: Colors.white),
                    focusColor: MyColors.primaryColor,
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _countryCode = newValue;
                      });
                    },
                    items: _countryCodes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                buildSizedBox(),
                InputField(
                  label: 'Phone No.',
                  keyboardType: TextInputType.number,
                  prefixText: '+$_countryCode',
                  validator: (value) {
                    if (value.isEmpty || value.length < 10) {
                      return 'Invalid phone number!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phoneNumber = '+$_countryCode$value'.trim();
                  },
                ),
                buildSizedBox(val: 32),
                LongButton(
                  label: 'get otp',
                  callback: _submit,
                ),
                MyDivider(),
                LongFlatButton(
                  label: 'Have an email address? Login',
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
}

class SelectCountry extends StatefulWidget {
  SelectCountry({this.callback});

  final Function callback;

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  final List<String> _countryCodes = ['+91', '+90', '+80', '+00'];
  var _selectVal = '';
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: _countryCodes[0],
        items: _countryCodes.map((String value) {
          return DropdownMenuItem<String>(
            value: _selectVal,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          print(value);
          setState(() {
            _selectVal = value;
          });
          widget.callback(value);
        });
  }
}
