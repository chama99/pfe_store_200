import 'package:chama_projet/model/message.dart';
import 'package:flutter/material.dart';

import '../pages/utils.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  // ignore: use_key_in_widget_constructors
  const MessageWidget({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    Utils.printLog("message = = ${message.toJson()} ; isMe ??? $isMe");
    const radius = const Radius.circular(12);
    final borderRadius = const BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
              radius: 16, backgroundImage: NetworkImage(message.urlAvatar)),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 140),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.orange[300],
            borderRadius: isMe
                ? borderRadius
                    .subtract(const BorderRadius.only(bottomRight: radius))
                : borderRadius
                    .subtract(const BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );
}
