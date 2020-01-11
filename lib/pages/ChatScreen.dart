import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

class ChatScreen extends StatelessWidget {
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        // backgroundColor: MyColors.primaryColor,
        leading: Icon(Icons.keyboard_backspace),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(msgs.length, (i) {
            final bool isLeft = msgs[i]['isReply'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:
                    isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (isLeft)
                    CircleAvatar(
                      backgroundImage: NetworkImage(images[0]),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: ClipShadowPath(
                      clipper: arrowClipper(isleft: isLeft),
                      shadow: Shadow(
                        blurRadius: 5,
                        color: isLeft
                            ? Colors.grey[300]
                            : MyColors.green.withAlpha(100),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        constraints: BoxConstraints(maxWidth: 220),
                        decoration: BoxDecoration(
                          color: isLeft
                              ? MyColors.white
                              : MyColors.green.withAlpha(180),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: isLeft ? 8 : 0, right: !isLeft ? 8 : 0),
                          child: Text(msgs[i]['msg'],
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              )),
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
      painter: _ClipShadowShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({@required this.shadow, @required this.clipper});

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
  arrowClipper({this.isleft = true});
  final curve = 12.0;
  final bool isleft;
  @override
  Path getClip(Size size) {
    var path = new Path();
    if (isleft) {
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
