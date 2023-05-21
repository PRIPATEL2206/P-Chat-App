import 'package:pchat/constants/key_constants.dart';

class Chat {
  final String cid;
  final String message;
  final String sendBy;
  final DateTime dateTime;
  final bool isRecived;

  Chat({
    required this.cid,
    required this.message,
    required this.sendBy,
    required this.dateTime,
    required this.isRecived,
  });

  Chat.fromJson(Map<String, dynamic> jsonData)
      : cid = jsonData[ChatJsonKey.cid],
        message = jsonData[ChatJsonKey.message],
        sendBy = jsonData[ChatJsonKey.sendBy],
        dateTime =
            DateTime.fromMillisecondsSinceEpoch(jsonData[ChatJsonKey.dateTime]),
        isRecived = jsonData[ChatJsonKey.isRecived];

  Map<String, dynamic> toJson() => {
        ChatJsonKey.cid: cid,
        ChatJsonKey.message: message,
        ChatJsonKey.sendBy: sendBy,
        ChatJsonKey.dateTime: dateTime.millisecondsSinceEpoch,
        ChatJsonKey.isRecived: isRecived,
      };
}
