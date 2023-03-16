import 'package:flutter/material.dart';
import 'package:mychat_app/models/message_model.dart';

import 'package:mychat_app/shared/constants.dart';
import 'audio_message.dart';
import 'text_message.dart';
import 'image_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message, String? this.photo,
  }) : super(key: key);

  final MessageUserModel message;
  final String? photo;

  @override
  Widget build(BuildContext context) {
    Widget messageContainer(MessageUserModel message) {
      switch (message.messageType) {
        case "text":
          return TextMessage(message: message);
        case "audio":
          return AudioMessage(message: message);
        case "image":
          return ImageMessage(message: message);
        default:
          return SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.isSender! ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender!) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(photo!),
            ),
            SizedBox(width: kDefaultPadding / 2),
          ],
          messageContainer(message),
          if (message.isSender!) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final String? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(status) {
      switch (status) {
        case "not_sent":
          return kErrorColor;
        case "not_view":
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case "viewed":
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == "not_sent" ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
