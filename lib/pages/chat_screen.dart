import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/models/messages.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/services/chats.dart';
import 'package:flutter_fire_plus/services/storage.dart';
import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController(
      // initialScrollOffset: 0.0,
      // keepScrollOffset: true,
      );
  File imageFile;
  var isChooseAttach = false;
  var isShowSticker = false;
  var isShowEmoji = false;
  final txtInputController = TextEditingController();

  void chooseAttache() {
    setState(() {
      if (!mounted) return;
      isChooseAttach = !isChooseAttach;
    });
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

  // @override
  void setState(fn) {
    if (!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) =>
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final _id = Provider.of<Auth>(context, listen: false).userId;
    final chatRoom = Provider.of<Chats>(context, listen: false).chatroom;
    final name = chatRoom == null ? [] : chatRoom.displayName.split(" ");
    final user = Provider.of<UserData>(context).currentUser;
    Future getImage() async {
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
        setState(() {
          if (!mounted) return;
          // isLoading = true;
        });
        // uploadFile();
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        // backgroundColor: MyColors.primaryColor,
        // leading: Icon(Icons.keyboard_backspace),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.person_add),
        //     onPressed: () {},
        //   )
        // ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(name[0]),
            if (name.length > 1)
              Text(
                name[1],
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
      body: WillPopScope(
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
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection('chats')
                      .document(chatRoom.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    final document = snapshot.data;
                    final messages = Messages.fromMap(
                        document.data, document.reference, _id);
                    final msgs = messages.messages;
                    if (msgs.length == 0)
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "start a conversation.",
                              style:
                                  TextStyle(color: MyColors.grey, fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: msgs.map((msg) {
                        final bool isLeft = !msg.outgoing;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: isLeft
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (isLeft)
                                CircleAvatar(
                                  backgroundImage: user.imageURL == null
                                      ? AssetImage('assets/images/avatar1.png')
                                      : CachedNetworkImageProvider(
                                          user.imageURL),
                                  backgroundColor: Colors.grey[200],
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: ClipShadowPath(
                                  clipper: arrowClipper(isLeft: isLeft),
                                  shadow: Shadow(
                                    blurRadius: 10,
                                    color: isLeft
                                        ? Colors.grey[300]
                                        : MyColors.green.withAlpha(120),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isLeft
                                          ? MyColors.white
                                          : MyColors.green.withAlpha(180),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(1.0)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: isLeft ? 8 : 0,
                                        right: !isLeft ? 8 : 0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: isLeft
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                        children: <Widget>[
                                          if (msg.type == 'gif')
                                            Image.asset(
                                              'assets/images/${msg.value}.gif',
                                              fit: BoxFit.cover,
                                            )
                                          else if (msg.type == 'img')
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: isLeft ? 4 : 0,
                                                right: !isLeft ? 4 : 0,
                                              ),
                                              child: Image.network(
                                                msg.value,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          else if (msg.type == 'text')
                                            buildTextMessage(
                                              msg.value,
                                              isLeft,
                                            ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                DateFormat('EEEE').format(
                                                          msg.timestamp
                                                              .toDate(),
                                                        ) ==
                                                        DateFormat('EEEE')
                                                            .format(
                                                          DateTime.now(),
                                                        )
                                                    ? "Today"
                                                    : DateFormat('EEEE').format(
                                                        msg.timestamp.toDate(),
                                                      ),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: isLeft
                                                      ? Colors.grey
                                                      : Colors.white
                                                          .withOpacity(0.8),
                                                ),
                                              ),
                                              Text(
                                                DateFormat(', hh:mm a').format(
                                                  msg.timestamp.toDate(),
                                                ),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: isLeft
                                                      ? Colors.grey
                                                      : Colors.white
                                                          .withOpacity(0.8),
                                                ),
                                              ),
                                              if (!isLeft)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Icon(
                                                    false
                                                        ? Icons.done
                                                        : Icons.done_all,
                                                    size: 18,
                                                    color: isLeft
                                                        ? Colors.grey
                                                        : Colors.white
                                                            .withOpacity(0.8),
                                                  ),
                                                )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      // List.generate(msgs.length, (i) {
                      //   print(msgs[0].type);
                      //   print(msgs[0].type == 'gif');

                      // }),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
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
                              callback: getImage,
                            ),
                            Flexible(
                              child: TextField(
                                controller: txtInputController,
                                maxLines: null,
                                onTap: () {
                                  // _scrollController.jumpTo(value)
                                  Future.delayed(Duration(milliseconds: 500))
                                      .then((_) {
                                    var scrollPosition =
                                        _scrollController.position;
                                    if (scrollPosition.viewportDimension <
                                        scrollPosition.maxScrollExtent) {
                                      _scrollController.animateTo(
                                        scrollPosition.maxScrollExtent,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  });
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
            ),
          ],
        ),
      ),
    );
  }

  Text buildTextMessage(String msg, bool isLeft) {
    return Text(
      msg,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: isLeft ? Colors.black : Colors.white,
      ),
    );
  }
}

class SelectSticker extends StatelessWidget {
  SelectSticker({this.callback});
  Function callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => callback('mimi1', 2),
                child: Image.asset(
                  'assets/images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => callback('mimi2', 2),
                child: Image.asset(
                  'assets/images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => callback('mimi3', 2),
                child: Image.asset(
                  'assets/images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => callback('mimi4', 2),
                child: Image.asset(
                  'assets/images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => callback('mimi5', 2),
                child: Image.asset(
                  'assets/images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => callback('mimi6', 2),
                child: Image.asset(
                  'assets/images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => callback('mimi7', 2),
                child: Image.asset(
                  'assets/images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => callback('mimi8', 2),
                child: Image.asset(
                  'assets/images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => callback('mimi9', 2),
                child: Image.asset(
                  'assets/images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipShadowPath({
    @required this.shadow,
    @required this.clipper,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _ClipShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowPainter({@required this.shadow, @required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class arrowClipper extends CustomClipper<Path> {
  arrowClipper({this.isLeft = true});
  final curve = 12.0;
  final bool isLeft;
  @override
  Path getClip(Size size) {
    var path = Path();
    if (isLeft) {
      path.moveTo(0, 0);
      path.lineTo(curve, curve);
      path.lineTo(curve, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width - curve, size.height - curve);
      path.lineTo(size.width - curve, 0);
      path.lineTo(0, 0);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
