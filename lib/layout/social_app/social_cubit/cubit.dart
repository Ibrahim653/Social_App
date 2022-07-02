import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/social_app/chats/chat_screen.dart';
import 'package:social_app/modules/social_app/feeds/feeds_screen.dart';
import 'package:social_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:social_app/modules/social_app/settings/settings_screen.dart';
import 'package:social_app/modules/social_app/social_login/social_login_screen.dart';
import 'package:social_app/modules/social_app/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/components/navigator.dart';
import '../../../models/social_user_model.dart';
import '../../../shared/network/local/cache_helper.dart';

class SocialAppCubit extends Cubit<SocialAppStates> {
  SocialAppCubit() : super(SocialInitialState());

  static SocialAppCubit get(context) => BlocProvider.of(context);

  bool profileImageIsSelected = false;
  bool coverImageIsSelected = false;

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = ["Home", "Chats", "Post", "Invite Friends", "Settings"];
  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      //print("c model is ${userModel!.toMap()}");

      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      // print("error is ${error.toString()}");
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  UserModel? friendModel;

  void getFriendData(String userId) {
    emit(GetUserFriendLoadingState());
    // friendModel=null;
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      friendModel = null;
      for (var element in event.docs) {
        if (element.data()['uId'] == userId) {
          friendModel = UserModel.fromJson(element.data());
        }
      }
      emit(GetUserFriendSuccessState());
    });
  }

  void changeBottomNavBarIndex(int index) {
    if (index == 1 || index == 3) {
      getAllUsers();
    }

    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavBarState());
    }
  }

  File? profileImage;

  final ImagePicker picker = ImagePicker();

////////profile image picker//////////
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImageSuccessState());
      profileImageIsSelected = true;
    } else {
      emit(SocialProfileImageErrorState());
      print('No image selected');
    }
  }

  File? coverImage;

////////cover image picker//////////
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImageSuccessState());
      coverImageIsSelected = true;
    } else {
      emit(SocialCoverImageErrorState());
      print('No image selected');
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadProfileImageSuccessState());
        updateUserData(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
        profileImageIsSelected = false;
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //  emit(SocialUploadCoverImageSuccessState());
        updateUserData(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
        coverImageIsSelected = false;
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUserData({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      uId: userModel!.uId,
      profileImage: image ?? userModel!.profileImage,
      coverImage: cover ?? userModel!.coverImage,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

////////cover image picker//////////
  File? PostImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      PostImage = File(pickedFile.path);
      emit(SocialPostImageSuccessState());
    } else {
      emit(SocialPostImageErrorState());
      print('No image selected');
    }
  }

//////upload post//////////
  void createPost({
    required DateTime date,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      text: text,
      postImage: postImage ?? '',
      image: userModel!.profileImage,
      date: date,
      likesNum: [],
      commentsName: [],
      comments: [],
      commentsImage: [],
      likes: {},
      myLike: false,
      commentsNum: 0,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

//////create new post/////
  void uploadPostImage({
    required DateTime dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(PostImage!.path).pathSegments.last}')
        .putFile(PostImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          text: text,
          postImage: value,
          date: dateTime,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  removePostImage() {
    PostImage = null;
    emit(SocialRemovePostImageState());
  }

////////get posts from firebase////////////
  List<PostModel> postsList = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<bool> likedByMe = [];
  int counter = 0;

  // List<String> likes2 = [];
  // List<bool> isLike = [];
  // int likesNum = 0;

  //   List<int> commentsNumber = [];

  getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      postsList = [];
      postsId = [];
      likes = [];
      likedByMe = [];
      counter = 0;
      //emit(SocialGetPostsSuccessState());
      for (var element in event.docs) {
        element.reference.collection('likes').get().then((value) {
          emit(SocialGetPostsSuccessState());
          likes.add(value.docs.length);
          postsList.add(PostModel.fromJson(element.data()));
          postsId.add(element.id);
          for (var element in value.docs) {
            if (element.id == userModel!.uId) {
              counter++;
            }
          }
          if (counter > 0) {
            likedByMe.add(true);
          } else {
            likedByMe.add(false);
          }
          counter = 0;

          //emit(SocialGetPostsSuccessState());
        }).catchError((error) {
          emit(SocialGetPostsErrorState(error));
        });
      }
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error));
      print(error.toString());
    });
  }

  void disLikePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .delete()
        .then((value) {
      emit(SocialDisLikeSuccessState());
    }).catchError((error) {
      emit(SocialDisLikeSuccessState());
      print(error.toString());
    });
  }

  PostModel? postModel;

  void sendComment({
    required String date,
    required String commentText,
    required String postId,
    String? commentImage,
    required int commentsNum,
  }) {
    CommentsModel commentsModel = CommentsModel(
      uId: userModel!.uId,
      name: userModel!.name,
      image: userModel!.profileImage,
      date: date,
      text: commentText,
      commentImage: commentImage,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentsModel.toMap())
        .then((value) {
      // postModel!.comments.add(commentText);
      // postModel!.commentsName.add(userModel!.name);
      // postModel!.commentsImage.add(userModel!.profileImage);
      // emit(SocialCommentPostSuccessState());

      int comments = commentsNum += 1;
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update({'commentsNum': comments}).then((value) {
        emit(SocialCommentPostSuccessState());
      }).catchError((error) {
        emit(SocialGetPostsErrorState(error));
      });
    }).catchError((error) {
      emit(SocialCommentPostErrorState(error));
      print(error.toString());
    });
  }

  List<CommentsModel> comments = [];

  void getComments({
    required String postUid,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .collection('comments')
        .orderBy('date', descending: false)
        .snapshots()
        .listen((event) {
      comments = [];
      for (var element in event.docs) {
        comments.add(CommentsModel.fromJson(element.data()));
      }
    });
    emit(GetCommentsSuccessState());
  }

  List<UserModel> users = [];

  void getAllUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != userModel!.uId) {
            users.add(UserModel.fromJson(element.data()));
          }
        }
        emit(SocialGetAllUserSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUserErrorState(error.toString()));
      });
    }
  }

  ///////send message///////
  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String message,
  }) {
    MessageModel messageModel = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      message: message,
    );
    ///// set sender chat//////
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
    ///// set receiver chat//////
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

///////get messages///////////
  List<MessageModel> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessagesSuccessState());
    });
  }

// void sendNotifications({
//   required String? action,
//   required String? targetPostUid,
//   required String? receiverUid,
//   required String? dateTime,
// }) {
//   if (receiverUid != userModel!.uId) {
//     NotificationModel notify = NotificationModel(
//         action: action,
//         receiverUid: receiverUid,
//         senderName: userModel!.name,
//         senderProfileImage: userModel!.profileImage,
//         senderUid: userModel!.uId,
//         targetPostUid: targetPostUid,
//         dateTime: dateTime,
//         seen: false);
//
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(receiverUid)
//         .collection('notifications')
//         .add(notify.toMap())
//         .then((value) {
//       emit(SendNotificationsSuccessState());
//     }).catchError((error) {
//       emit(SendNotificationsErrorState(error.toString()));
//     });
//   }
// }

// void notificationSeen() {}
// List<NotificationModel> myNotifications = [];
//
// void getNotifications() {
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(uId)
//       .collection('notifications')
//       .orderBy('dateTime', descending: true)
//       .snapshots()
//       .listen((event) {
//     myNotifications = [];
//     for (var element in event.docs) {
//       myNotifications.add(NotificationModel.fromJson(element.data()));
//     }
//   });
//   emit(GetNotificationsSuccessState());
// }

  void editPost({
    required PostModel postModel,
    required String postId,
    String? postImage,
    required String text,
  }) {
    emit(EditPostLoadingState());
    postModel = PostModel(
        uId: postModel.uId,
        name: postModel.name,
        image: postModel.image,
        date: postModel.date,
        likes: postModel.likes,
        myLike: postModel.myLike,
        likesNum: postModel.likesNum,
        comments: postModel.comments,
        commentsNum: postModel.commentsNum,
        commentsName: postModel.commentsName,
        commentsImage: postModel.commentsImage,
        text: text,
        postImage: postImage ?? postModel.postImage);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(postModel.toMap())
        .then((value) {
      emit(EditPostSuccessState());
    }).catchError((error) {
      emit(EditPostErrorState());
      print("${error.toString()} from UpdatePost");
    });
  }

  void editPostWithImage(
      {required PostModel postModel,
      required String postId,
      required String text,
      String? postImage}) {
    emit(EditPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('editedPosts/${Uri.file(PostImage!.path).pathSegments.last}')
        .putFile(PostImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        editPost(
            postModel: postModel, postId: postId, text: text, postImage: value);
      }).catchError((error) {
        emit(EditPostErrorState());
        print("${error.toString()} from UpdatePost");
      });
    }).catchError((error) {
      emit(EditPostErrorState());
      print("${error.toString()} from urlUpdatePost");
    });
  }

  deletePost({
    required String postId,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      emit(DeletePostSuccessState());
    }).catchError((error) {
      emit(DeletePostErrorState());
      print(error.toString());
    });
  }

  //////add friend////
  void addFriend({
    required String friendsUid,
    required String friendName,
    required String friendProfilePic,
  }) {
    emit(AddFriendLoadingState());
    UserModel myFriendModel = UserModel(
      uId: friendsUid,
      name: friendName,
      profileImage: friendProfilePic,
    );
    UserModel myModel = UserModel(
      uId: userModel!.uId,
      name: userModel!.name,
      profileImage: userModel!.profileImage,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('friends')
        .doc(friendsUid)
        .set(myFriendModel.toMap())
        .then((value) {
      emit(AddFriendSuccessState());
    }).catchError((error) {
      emit(AddFriendErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendsUid)
        .collection('friends')
        .doc(userModel!.uId)
        .set(myModel.toMap())
        .then((value) {
      emit(AddFriendSuccessState());
    }).catchError((error) {
      emit(AddFriendErrorState());
    });
  }

///////search users//////////
  List<UserModel> usersSearch = [];

//   void getSearchUsers(String name) {
//     emit(GetAllSearchUserLoadingState());
//     usersSearch = [];
//     FirebaseFirestore.instance.collection('users').get().then((value) {
//       for (var element in value.docs) {
//         if (element.data()['name'] == name) {
//           usersSearch.add(UserModel.fromJson(element.data()));
//         }
//       }
//       emit(GetAllSearchUserSuccessState());
//     }).catchError((error) {
//       print(error.toString());
//       emit(GetAllSearchUserErrorState(error));
//     });
//   }
  getSearchUsers(String searchName) {
    getAllUsers();
    emit(GetAllSearchUserLoadingState());
    searchName = searchName.toLowerCase();
    print(users.toString());
    if (searchName.length > 2) {
      usersSearch = users.where((search) {
        var searchTitle = search.name.toLowerCase();
        return searchTitle.contains(searchName);
      }).toList();
    }else if(searchName.isEmpty){
      usersSearch=[];
    }
    emit(GetAllSearchUserSuccessState());
    //print(searchList[0].displayName);
  }

  void signOut(context) {
    FirebaseAuth.instance.signOut().then((value) async {
      users = [];

      postsId = [];
      postsList = [];
      likes = [];
      comments = [];

      uId = '';
      CacheHelper.removeData(key: 'uId');
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.id == userModel?.uId) {
            element.reference.update({'token': null});
          }
        }
      });
      MyNavigators.navigateAndFinish(context, LoginScreen());

      currentIndex = 0;
      emit(SignOut());
    }).catchError((error) {
      emit(SignOutError());
    });
    // CacheHelper.removeData(key: 'uId').then((value) {
    //   if (value) {
    //     navigateAndFinish(context, StartScreen());
    //     emit(SignOut());
    //   }
    // }
    // );
  }
}
