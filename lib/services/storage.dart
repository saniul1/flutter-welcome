import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Storage extends ChangeNotifier {
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
