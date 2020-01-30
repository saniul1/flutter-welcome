import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/utils/profile_helper.dart';
import 'package:flutter_fire_plus/widgets/profile/row_item.dart';

class EmailRow extends StatelessWidget {
  EmailRow({@required this.isSelf});
  final bool isSelf;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context).currentUser;
    final Future<bool> isEmailVerified =
        Provider.of<Auth>(context, listen: false).isEmailVerified();

    return BodyRowItem(
      text: user.email ?? 'Not added yet',
      suffix: user.email == null
          ? FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text('Add Email Address.'),
              onPressed: () => addEmail(context),
            )
          : !isSelf
              ? null
              : FutureBuilder(
                  future: isEmailVerified,
                  builder: (context, value) {
                    if (value.connectionState == ConnectionState.waiting) {
                      return Text('');
                    } else {
                      if (value.data != null && value.data) {
                        return Row(
                          children: <Widget>[
                            Icon(
                              Icons.done,
                              size: 18,
                            ),
                            Text('Verified')
                          ],
                        );
                      } else {
                        return FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: Text('Verify'),
                          onPressed: () async {
                            try {
                              await Provider.of<Auth>(context, listen: false)
                                  .sendEmailVerification();
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Email Send! check your inbox.'),
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            } catch (error) {
                              print(error);
                            }
                          },
                        );
                      }
                    }
                  },
                ),
    );
  }
}
