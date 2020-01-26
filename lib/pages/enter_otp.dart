import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/widgets/divider.dart';
import 'package:flutter_fire_plus/widgets/long_button.dart';
import 'package:flutter_fire_plus/widgets/input_field.dart';
import 'package:flutter_fire_plus/utils/helper.dart';
import 'package:flutter_fire_plus/widgets/long_flat_button.dart';
import 'package:flutter_fire_plus/models/http_exception.dart';
import 'package:flutter_fire_plus/pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire_plus/services/auth.dart';

class EnterOtp extends StatelessWidget {
  static const routeName = '/enter-otp';

  EnterOtp({this.id, this.phoneNumber, this.isExistingUser = false});

  final String id;
  final String phoneNumber;
  final bool isExistingUser;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _authData = {'id': '', 'otp': ''};

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      if (!_formKey.currentState.validate()) {
        return; // Invalid!
      }
      buildLoadingDialog(context);
      _formKey.currentState.save();
      try {
        final _userId =
            await Provider.of<Auth>(context, listen: false).verifyOTP(
          id: _authData['id'],
          otp: _authData['otp'],
          phoneNo: phoneNumber,
          isExistingUser: isExistingUser,
        );
        print('Signed_in_phone_user: $_userId');
        Navigator.pop(context);
        if (_userId != null && _userId.length > 0) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              ProfilePage.routeName, (Route<dynamic> route) => false);
        }
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('INVALID_VERIFICATION_CODE')) {
          errorMessage = 'this verification code is wrong.';
        } else if (error.toString().contains('SESSION_EXPIRED')) {
          errorMessage = 'The sms code has expired.';
        }
        Navigator.pop(context);
        showErrorDialog(context, errorMessage);
      } catch (error) {
        print('Error: $error');
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        Navigator.pop(context);
        showErrorDialog(context, errorMessage);
      }
    }

    Future _onSuccess(String verificationId, [int forceResendingToken]) async {
      _authData['id'] = verificationId;
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Code Send! check your inbox.'),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {},
          ),
        ),
      );
    }

    _onFailed(error) {
      String errorMessage = 'Could not complete action';
      if (error.code.toString().contains('quotaExceeded')) {
        errorMessage = 'Too many attempts with this number. Try again later.';
      }
      showErrorDialog(context, errorMessage);
    }

    _onTimeout(String verificationId) {
      showErrorDialog(context, 'Verification timed out.');
    }

    Future<void> _resendOtp() async {
      try {
        buildLoadingDialog(context);
        await Provider.of<Auth>(context, listen: false).verifyPhone(
          phoneNumber,
          onFailed: _onFailed,
          onSuccess: _onSuccess,
          onTimeout: _onTimeout,
        );
        Navigator.pop(context);
      } on HttpException catch (error) {
        print(error.toString());
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
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Verify'),
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
                  label: 'Enter OTP',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'OTP is at least 6 character long!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['id'] = id;
                    _authData['otp'] = value.trim();
                  },
                ),
                buildSizedBox(val: 32),
                LongButton(
                  label: 'Verify',
                  callback: _submit,
                ),
                MyDivider(),
                LongFlatButton(
                  label: 'Didn\'t receive any OTP? Resend',
                  callback: _resendOtp,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
