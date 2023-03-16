import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatMessageType { text, audio, image, video }

enum MessageStatus { not_sent, not_view, viewed }

class MessageUserModel {
  String? senderId;
  String? receiverId;
  Timestamp? dateTime;
  String? text;
  String? messageResource;
  String? messageType;
  String? messageStatus;
  bool? isSender;

  MessageUserModel({
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    this.receiverId,
    this.senderId,
    this.dateTime,
    this.text,
    this.messageResource,
  });
  MessageUserModel.fromJson(Map<String, dynamic> json) {
    messageType = json['messageType'];
    messageStatus = json['messageStatus'];
    isSender = json['isSender'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    messageResource = json['messageResource'];
    dateTime = json['dateTime'];
    text = json['text'];
  }
  Map<String, dynamic> toMap() {
    return {
      'messageType': messageType,
      'messageStatus': messageStatus,
      'isSender': isSender,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageResource': messageResource,
      'dateTime': dateTime,
      'text': text,
    };
  }
}
