// class CommentModel {
//   String? senderId;
//   String? dateTime;
//   String? text;
//   String? profileImage;
//  // Map<String,dynamic>? commentImage;
//   String? commenterName;
//
//   CommentModel({
//     required this.senderId,
//   //  this.commentImage,
//     required this.dateTime,
//     required this.text,
//     required this.profileImage,
//     required this.commenterName,
//
//
//   });
//
//   CommentModel.fromJson(Map<String, dynamic>? json) {
//     senderId = json!['senderId'];
//     dateTime = json['dataTime'];
//     text = json['text'];
//    // commentImage = json['commentImage'];
//     profileImage = json['profileImage'];
//     commenterName = json['commenterName'];
//
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'senderId': senderId,
//       'dateTime': dateTime,
//       'text': text,
//      // 'commentImage': commentImage,
//       'profileImage':profileImage,
//       'commenterName':commenterName,
//     };
//   }
// }