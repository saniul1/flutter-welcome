import 'package:flutter/foundation.dart';

class Auth extends ChangeNotifier {
  String _token;

  bool get isAuth {
    return _token != null;
  }
}
