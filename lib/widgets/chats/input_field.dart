import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/services/chats.dart';
import 'package:flutter_fire_plus/services/storage.dart';
import 'package:flutter_fire_plus/widgets/chats/stickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:provider/provider.dart';

class InputField extends StatefulWidget {
  InputField({@required this.goToBottom});

  final Function goToBottom;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  File imageFile;
  var isChooseAttach = false;
  var isShowSticker = false;
  var isShowEmoji = false;

  final txtInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatRoom = Provider.of<Chats>(context, listen: false).chatroom;

    return WillPopScope(
      onWillPop: () {
        if (isShowSticker || isChooseAttach)
          setState(() {
            if (!mounted) return;
            if (isShowEmoji) isShowEmoji = false;
            if (isShowSticker) isShowSticker = false;
            if (isChooseAttach) isChooseAttach = false;
          });
        else
          Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Material(
        elevation: 8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    buildButton(
                      Icons.image,
                      callback: () => getImage(chatRoom),
                    ),
                    Flexible(
                      child: TextField(
                        controller: txtInputController,
                        maxLines: null,
                        onTap: () {
                          widget.goToBottom();
                          isShowEmoji = false;
                          isShowSticker = false;
                        },
                        style: TextStyle(
                          color: MyColors.grey,
                          fontSize: 15.0,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: MyColors.grey),
                        ),
                      ),
                    ),
                    buildButton(Icons.face, callback: showEmojis),
                    buildButton(Icons.send, callback: () {
                      Provider.of<Chats>(context, listen: false)
                          .sendMessageToChatroom(
                        chatroomId: chatRoom.id,
                        message: txtInputController.text,
                        type: "text",
                      );
                      widget.goToBottom();
                      txtInputController.clear();
                    }),
                  ],
                ),
                color: Colors.white,
              ),
              if (isShowSticker)
                SelectSticker(
                  callback: (String file, int n) {
                    Provider.of<Chats>(context, listen: false)
                        .sendMessageToChatroom(
                      chatroomId: chatRoom.id,
                      message: file,
                      type: "gif",
                    );
                    widget.goToBottom();
                  },
                ),
              if (isShowEmoji)
                if (isShowEmoji)
                  Stack(children: [
                    EmojiPicker(
                      rows: 3,
                      columns: 7,
                      bgColor: Colors.white,
                      indicatorColor: Colors.white,
                      recommendKeywords: ["racing", "horse"],
                      numRecommended: 10,
                      onEmojiSelected: (emoji, category) {
                        txtInputController.text =
                            txtInputController.text + emoji.emoji;
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: buildButton(
                        Icons.gif,
                        callback: showSticker,
                      ),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }

  Future getImage(SelectedChatroom chatRoom) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final imageName = imageFile.toString().split('/');
      final name = imageName[imageName.length - 1];
      final path = 'chats/${chatRoom.id}/images/$name';
      print(path);
      final uploadTask = Provider.of<Storage>(context, listen: false)
          .uploadFile(imageFile, path);
      await uploadTask.onComplete;
      final url =
          await Provider.of<Storage>(context, listen: false).getURL(path);
      Provider.of<Chats>(context, listen: false).sendMessageToChatroom(
        chatroomId: chatRoom.id,
        message: url,
        type: "img",
      );
      widget.goToBottom();

      // setState(() {
      //   if (!mounted) return;
      // isLoading = true;
      // });
      // uploadFile();
    }
  }

  void showSticker() {
    FocusScope.of(context).unfocus();
    isShowEmoji = false;
    setState(() {
      if (!mounted) return;
      isShowSticker = !isShowSticker;
    });
  }

  void showEmojis() {
    FocusScope.of(context).unfocus();
    isShowSticker = false;
    setState(() {
      if (!mounted) return;
      isShowEmoji = !isShowEmoji;
    });
  }

  Material buildButton(IconData icon, {Function callback}) {
    return Material(
      child: IconButton(
        icon: Icon(icon),
        onPressed: callback,
        color: MyColors.secondaryColor,
      ),
      color: Colors.white,
    );
  }
}
