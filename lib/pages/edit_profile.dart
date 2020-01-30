import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_fire_plus/utils/helper.dart';
import 'package:flutter_fire_plus/services/storage.dart';
import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File _imageFile;
  String name;
  String bio;
  String url;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Future getImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(_imageFile.uri.toString());
    if (_imageFile != null) {
      if (!mounted) return;
      setState(() {});
      // uploadFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _id = Provider.of<Auth>(context, listen: false).userId;
    final user = Provider.of<UserData>(context).currentUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: user.imageURL == null && _imageFile == null
                      ? AssetImage('assets/images/img_not_available.jpeg')
                      : _imageFile != null
                          ? FileImage(_imageFile)
                          : CachedNetworkImageProvider(user.imageURL),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      elevation: 0,
                      highlightElevation: 0,
                      color: Colors.grey.withAlpha(50),
                      textColor: Colors.white,
                      child: Text('Change Profile Picture'),
                      onPressed: getImage,
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Profile Name',
                        helperText: 'Change Profile Name',
                        labelText: user.name,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.secondaryColor,
                          ),
                        ),
                      ),
                      onSaved: (value) {
                        name = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 4,
                      controller: TextEditingController(text: user.bio),
                      decoration: InputDecoration(
                        hintText: user.bio ?? 'no bio.',
                        helperText: 'Change bio',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.secondaryColor,
                          ),
                        ),
                      ),
                      onSaved: (value) {
                        bio = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: MyColors.secondaryColor,
                      textColor: Colors.white,
                      child: Text('Save'),
                      onPressed: () async {
                        buildLoadingDialog(context, msg: 'Saving data...');
                        _formKey.currentState.save();
                        if (_imageFile != null) {
                          final path = 'profiles/image/$_id';
                          final uploadTask =
                              Provider.of<Storage>(context, listen: false)
                                  .uploadFile(_imageFile, path);
                          await uploadTask.onComplete;
                          print('File Uploaded');
                          url =
                              await Provider.of<Storage>(context, listen: false)
                                  .getURL(path);
                        }
                        if (name.length == 0) name = null;
                        if (bio.length == 0) bio = null;
                        await user.reference.updateData({
                          if (name != null) 'displayName': name,
                          if (url != null) 'photoURL': url,
                          if (bio != null) 'bio': bio,
                        });
                        print('User data updated!');
                        Navigator.of(context).pop();
                        await Provider.of<UserData>(context, listen: false)
                            .fetchAndSetUserData();
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
