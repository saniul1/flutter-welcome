import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/models/user.dart';

import 'package:flutter_fire_plus/pages/enter_otp.dart';
import 'package:flutter_fire_plus/widgets/profile/row_item.dart';

class PhoneRow extends StatelessWidget {
  PhoneRow({@required this.isSelf});

  final isSelf;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context).currentUser;
    return BodyRowItem(
      // text: '+919876543210',
      text: user.phoneNumber ?? 'Not added yet',
      suffix: user.phoneNumber == null
          ? FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text('Add Mobile No.'),
              onPressed: () => _addMobileNo(context, user),
            )
          : !isSelf
              ? null
              : user.isPhoneVerified
                  ? Row(
                      children: <Widget>[
                        Icon(
                          Icons.done,
                          size: 18,
                        ),
                        Text('Verified')
                      ],
                    )
                  : FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text('Verify'),
                      onPressed: () async {
                        await Provider.of<Auth>(
                          context,
                          listen: false,
                        ).verifyPhone(
                          user.phoneNumber,
                          onSuccess: (String verificationId,
                              [int forceResendingToken]) async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EnterOtp(
                                  id: verificationId,
                                  phoneNumber: user.phoneNumber,
                                  isExistingUser: true,
                                ),
                              ),
                            );
                          },
                          onFailed: (error) => print('error: ${error.message}'),
                          onTimeout: (verificationId) =>
                              print('Verification timed out.'),
                        );
                      },
                    ),
    );
  }

  Future<void> _addMobileNo(BuildContext context, User user) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    String _phoneNumber;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add mobile number'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty || value.length < 10) {
                return 'Invalid phone number!';
              } else if (value.length == 10) {
                return 'don\'t forget add country code!';
              }
              return null;
            },
            onSaved: (value) {
              _phoneNumber = '+$value'.trim();
            },
            decoration: InputDecoration(
              prefix: Text('+'),
              hintText: "Mobile number with country code.",
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('add'),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return; // Invalid!
              }
              _formKey.currentState.save();
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
        ],
      ),
    ).then((isConfirmed) async {
      if (isConfirmed) {
        try {
          print('add No- $_phoneNumber');
          await user.reference.updateData({'phoneNumber': _phoneNumber});
          await Provider.of<UserData>(context, listen: false)
              .fetchAndSetUserData();
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
