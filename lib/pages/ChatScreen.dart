import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

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

  void chooseAttache() {
    setState(() {
      isChooseAttach = !isChooseAttach;
    });
  }

  void showSticker() {
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  // @override
  void setState(fn) {
    SchedulerBinding.instance.addPostFrameCallback((_) =>
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    super.setState(fn);
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    print(imageFile);
    if (imageFile != null) {
      setState(() {
        // isLoading = true;
      });
      // uploadFile();
    }
  }

  final List<String> images = [
    'https://images.squarespace-cdn.com/content/v1/5c8eba949b7d157921bba3e4/1558254396295-BDGVZTP3I9BS9V7QN2XS/ke17ZwdGBToddI8pDm48kAGx3IFADtt9koaOuly55F57gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0pTKqSDRwmMK43IUI3HojJX_iGOyvGz0VEAhzFdMwNTUP3iYIRpjRWHZRVGJwIQ0nA/The+Humans+Being+Project-Myanmar-Yangon-Part+II-22.jpg?format=2500w'
  ];

  final msgs = [
    {
      'msg': 'adakhdkjahfjkahfjkaghfjg adajfhajfjkahfjkagfjhgfg',
      'isReply': true
    },
    {'msg': 'adakhdkjahfjkahfjkaghfjg', 'isReply': true},
    {
      'msg': 'adakhdkjahfjkahfjkaghfjg adajfhajfjkahfjkagfjhgfg',
      'isReply': false
    },
    {'msg': 'adakhdkjahfjkahfjasdfasf asfafafafafafafkaghfjg', 'isReply': true},
    {'msg': 'adakhfjg', 'isReply': false},
    {'msg': 'adakhdkjahfjkahfjasdfasf asfafafafafafafkaghfjg', 'isReply': true},
    {'msg': 'adakhfjg', 'isReply': false},
    {'msg': 'adakhdkjahfjkahfjasdfasf asfafafafafafafkaghfjg', 'isReply': true},
    {'msg': 'adakhfjg', 'isReply': false},
    {
      'msg':
          'adakhdkasdasdasdasdasfdasfasfasfafasdasdfasfasfafasfasfasfafadadajhfghfjg',
      'isReply': true
    },
    {'msg': 'adakhdkjahfjkahfjkaghfjg', 'isReply': true},
    {'msg': 'adakhdk', 'isReply': true},
    {'msg': 'D:)', 'isReply': false},
    {'msg': '', 'isReply': true},
  ];

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
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        // backgroundColor: MyColors.primaryColor,
        // leading: Icon(Icons.keyboard_backspace),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {},
          )
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Joededdd'),
            Text(
              'Moe',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          setState(() {
            isShowSticker = false;
            isChooseAttach = false;
          });
          return Future.value(false);
        },
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(msgs.length, (i) {
                    final bool isLeft = msgs[i]['isReply'];
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
                              backgroundImage: NetworkImage(images[0]),
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
                                      MediaQuery.of(context).size.width * 0.6,
                                ),
                                decoration: BoxDecoration(
                                  color: isLeft
                                      ? MyColors.white
                                      : MyColors.green.withAlpha(180),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: isLeft ? 8 : 0,
                                    right: !isLeft ? 8 : 0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      if (i == 12)
                                        Image.asset(
                                          'assets/images/mimi1.gif',
                                          fit: BoxFit.cover,
                                        ),
                                      if (i >= 13)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: isLeft ? 4 : 0,
                                            right: !isLeft ? 4 : 0,
                                          ),
                                          child: Image.network(
                                            images[0],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      if (i < 12) buildTextMessage(i, isLeft),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Yesterday 15:00',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: isLeft
                                                  ? Colors.grey
                                                  : Colors.white
                                                      .withOpacity(0.8),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              constraints:
                                                  BoxConstraints(minWidth: 10),
                                            ),
                                          ),
                                          if (!isLeft)
                                            Icon(
                                              i > 11
                                                  ? Icons.done
                                                  : Icons.done_all,
                                              size: 18,
                                              color: isLeft
                                                  ? Colors.grey
                                                  : Colors.white
                                                      .withOpacity(0.8),
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
                  }),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                elevation: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (isShowSticker) buildSticker(),
                    if (isChooseAttach)
                      Container(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            buildButton(Icons.camera_alt, callback: () {}),
                            buildButton(Icons.image, callback: getImage),
                            buildButton(Icons.face, callback: showSticker),
                          ],
                        ),
                      ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          buildButton(Icons.attach_file,
                              callback: chooseAttache),
                          Flexible(
                            child: TextField(
                              onTap: () {
                                // _scrollController.jumpTo(value)
                                var scrollPosition = _scrollController.position;
                                if (scrollPosition.viewportDimension <
                                    scrollPosition.maxScrollExtent) {
                                  _scrollController.animateTo(
                                    scrollPosition.maxScrollExtent,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                  );
                                }
                              },
                              style: TextStyle(
                                  color: MyColors.grey, fontSize: 15.0),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(color: MyColors.grey),
                              ),
                            ),
                          ),
                          buildButton(Icons.send, callback: () {}),
                        ],
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSendMessage(String content, int type) {}

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: Image.asset(
                  'assets/images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: Image.asset(
                  'assets/images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
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
                onPressed: () => onSendMessage('mimi4', 2),
                child: Image.asset(
                  'assets/images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: Image.asset(
                  'assets/images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
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
                onPressed: () => onSendMessage('mimi7', 2),
                child: Image.asset(
                  'assets/images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: Image.asset(
                  'assets/images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
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

  Text buildTextMessage(int i, bool isLeft) {
    return Text(
      msgs[i]['msg'],
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: isLeft ? Colors.black : Colors.white,
      ),
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
