class UserModel {
  late String name;
  late String? email;
  late String uId;
  late String profileImage;
  late String? coverImage;

  late String? bio;
  late String? phone;

  UserModel({
    required this.name,
    this.email,
    required this.uId,
    required this.profileImage,
    this.coverImage,
    this.bio,
    this.phone,
  });

  UserModel.fromJson(Map<String, dynamic> jsonData) {
    name = jsonData['name'];
    email = jsonData['email'];
    uId = jsonData['uId'];
    profileImage = jsonData['profileImage'];
    coverImage = jsonData['coverImage'];
    bio = jsonData['bio'];
    phone = jsonData['phone'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uId': uId,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'bio': bio,
      'phone': phone,
    };
  }
}
