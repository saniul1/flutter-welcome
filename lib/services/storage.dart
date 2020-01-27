import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage with ChangeNotifier {
  StorageUploadTask uploadFile(File file, String path) {
    final StorageReference storageReference =
        FirebaseStorage().ref().child(path);

    final StorageUploadTask uploadTask = storageReference.putFile(file);

    return uploadTask;
    // Cancel your subscription when done.
  }

  Future<String> getURL(String path) async {
    final StorageReference storageReference =
        FirebaseStorage().ref().child(path);
    String _url;
    await storageReference.getDownloadURL().then((url) {
      _url = url.toString();
    });

    return _url;
  }
}
