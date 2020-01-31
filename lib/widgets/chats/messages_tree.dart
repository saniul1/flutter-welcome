import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/models/messages.dart';
import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/widgets/chats/arrow_clipper.dart';
import 'package:flutter_fire_plus/widgets/chats/clip_shadow.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesTree extends StatelessWidget {
  const MessagesTree({
    Key key,
    @required this.messages,
  }) : super(key: key);

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context).currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: messages.map((msg) {
        final bool isLeft = !msg.outgoing;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
                isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (isLeft)
                CircleAvatar(
                  backgroundImage: user.imageURL == null
                      ? AssetImage('assets/images/avatar1.png')
                      : CachedNetworkImageProvider(user.imageURL),
                  backgroundColor: Colors.grey[200],
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: ClipShadowPath(
                  clipper: ArrowClipper(isLeft: isLeft),
                  shadow: Shadow(
                    blurRadius: 10,
                    color: isLeft
                        ? Colors.grey[300]
                        : MyColors.green.withAlpha(120),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    decoration: BoxDecoration(
                      color: isLeft
                          ? MyColors.white
                          : MyColors.green.withAlpha(180),
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
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
                            Text(
                              msg.value,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: isLeft ? Colors.black : Colors.white,
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                DateFormat('EEEE').format(
                                          msg.timestamp.toDate(),
                                        ) ==
                                        DateFormat('EEEE').format(
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
                                      : Colors.white.withOpacity(0.8),
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
                                      : Colors.white.withOpacity(0.8),
                                ),
                              ),
                              if (!isLeft)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    false ? Icons.done : Icons.done_all,
                                    size: 18,
                                    color: isLeft
                                        ? Colors.grey
                                        : Colors.white.withOpacity(0.8),
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
    );
  }
}
