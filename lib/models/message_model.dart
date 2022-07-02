class MessageModel {
  late String senderId;
  late String receiverId;
  late String dateTime;
  late String message;



  MessageModel(
      {required this.senderId,
        required this.receiverId,
        required this.dateTime,
        required this.message,

      });

  MessageModel.fromJson(Map<String, dynamic> jsonData) {
    senderId = jsonData['senderId'];
    receiverId = jsonData['receiverId'];
    dateTime = jsonData['dateTime'];
    message = jsonData['message'];

  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'message': message,

    };
  }
}
