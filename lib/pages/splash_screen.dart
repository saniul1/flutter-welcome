import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/utils/helper.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              height: 40.0,
              width: 40.0,
            ),
            buildSizedBox(),
            Center(
              child: Text(
                'Please wait connecting to serve...',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
