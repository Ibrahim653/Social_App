abstract class SocialAppStates {}

class SocialInitialState extends SocialAppStates {}

class SocialGetUserSuccessState extends SocialAppStates {}

class SocialGetUserLoadingState extends SocialAppStates {}

class SocialGetUserErrorState extends SocialAppStates {
  final String error;

  SocialGetUserErrorState(this.error);
}

class SocialChangeBottomNavBarState extends SocialAppStates {}

class SocialNewPostState extends SocialAppStates {}

class SocialProfileImageSuccessState extends SocialAppStates {}

class SocialProfileImageErrorState extends SocialAppStates {}

class SocialCoverImageErrorState extends SocialAppStates {}

class SocialCoverImageSuccessState extends SocialAppStates {}

class SocialCommentImageSuccessState extends SocialAppStates {}

class SocialCommentImageErrorState extends SocialAppStates {}

class SocialUploadCoverImageSuccessState extends SocialAppStates {}

class SocialUploadCoverImageErrorState extends SocialAppStates {}

class SocialUploadProfileImageErrorState extends SocialAppStates {}

class SocialUploadProfileImageSuccessState extends SocialAppStates {}

class SocialUserUpdateErrorState extends SocialAppStates {}

class SocialUserUpdateLoadingState extends SocialAppStates {}

class UploadProfileImageLoadingState extends SocialAppStates {}

class UploadCoverImageLoadingState extends SocialAppStates {}

//////create new post///////
class SocialCreatePostLoadingState extends SocialAppStates {}

class SocialCreatePostSuccessState extends SocialAppStates {}

class SocialCreatePostErrorState extends SocialAppStates {}

//////get post image////////
class SocialPostImageErrorState extends SocialAppStates {}

class SocialPostImageSuccessState extends SocialAppStates {}
////////remove post image///////////

class SocialRemovePostImageState extends SocialAppStates {}

////////get posts from firebase////////////
class SocialGetPostsSuccessState extends SocialAppStates {}

class SocialGetPostsErrorState extends SocialAppStates {
  final String error;

  SocialGetPostsErrorState(this.error);
}

/////////like the post/////////
class SocialLikePostSuccessState extends SocialAppStates {}

class SocialLikePostErrorState extends SocialAppStates {
  final String error;

  SocialLikePostErrorState(this.error);
}

class SocialDisLikeSuccessState extends SocialAppStates {}

class SocialDisLikeErrorSuccessState extends SocialAppStates {
  final String error;

  SocialDisLikeErrorSuccessState(this.error);
}

////get like/////
class SocialGetLikePostSuccessState extends SocialAppStates {}

/////////comment the post/////////
class SocialCommentPostSuccessState extends SocialAppStates {}

class SocialCommentPostLoadingState extends SocialAppStates {}

class SocialCommentPostErrorState extends SocialAppStates {
  final String error;

  SocialCommentPostErrorState(this.error);
}

/////////get all users to display in chat screen ///////
class SocialGetAllUserSuccessState extends SocialAppStates {}

class SocialGetAllUserLoadingState extends SocialAppStates {}

class SocialGetAllUserErrorState extends SocialAppStates {
  final String error;

  SocialGetAllUserErrorState(this.error);
}

//////////chat ///////////
class SocialSendMessageSuccessState extends SocialAppStates {}

class SocialSendMessageErrorState extends SocialAppStates {}

class SocialGetMessagesSuccessState extends SocialAppStates {}

///////delete user///////
// class DeleteUserSuccessState extends SocialAppStates {}
// class DeleteUserErrorState extends SocialAppStates {}
////get comments//////////

class GetCommentsSuccessState extends SocialAppStates {}

class SocialGetCommentsLoadingState extends SocialAppStates {}

class GetCommentsErrorState extends SocialAppStates {
  final String error;

  GetCommentsErrorState(this.error);
}

////////get comment image/////////
class GetCommentImageSuccessState extends SocialAppStates {}

class GetCommentImageErrorState extends SocialAppStates {}

//////delete comment image////
class DeleteCommentPicState extends SocialAppStates {}

/////upload comment image//////
class UploadCommentPicLoadingState extends SocialAppStates {}

class UploadCommentPicSuccessState extends SocialAppStates {}

class UploadCommentPicErrorState extends SocialAppStates {}

/////////send notification/////////
class SendNotificationsSuccessState extends SocialAppStates {}

class SendNotificationsErrorState extends SocialAppStates {
  final String error;

  SendNotificationsErrorState(this.error);
}

class GetPostPersonalLoadingState extends SocialAppStates {}

class GetPostPersonalSuccessState extends SocialAppStates {}

class GetPostPersonalErrorState extends SocialAppStates {
  final String error;

  GetPostPersonalErrorState(this.error);
}

/////////get notification/////////
class GetNotificationsSuccessState extends SocialAppStates {}
////////edit post/////

class EditPostLoadingState extends SocialAppStates {}

class EditPostSuccessState extends SocialAppStates {}

class EditPostErrorState extends SocialAppStates {}

//////delete post///////////
class DeletePostSuccessState extends SocialAppStates {}

class DeletePostErrorState extends SocialAppStates {}

///////////////get friend user data////////
class GetUserFriendLoadingState extends SocialAppStates {}

class GetUserFriendSuccessState extends SocialAppStates {}
class GetUserFriendErrorState extends SocialAppStates {}
////get friend post
class GetPostFriendsLoadingState extends SocialAppStates {}

class GetPostFriendsSuccessState extends SocialAppStates {}

class GetPostFriendsErrorState extends SocialAppStates {
  final String error;
  GetPostFriendsErrorState(this.error);
}
// Sign out
class SignOut extends SocialAppStates {}

class SignOutError extends SocialAppStates {}
//////search//////////
  class SearchSuccessState extends SocialAppStates {}
class SearchErrorState extends SocialAppStates {}
class GetAllSearchUserLoadingState extends SocialAppStates {}

class GetAllSearchUserSuccessState extends SocialAppStates {}

class GetAllSearchUserErrorState extends SocialAppStates {
  final String error;
  GetAllSearchUserErrorState(this.error);
}
///AddFriend State
class AddFriendLoadingState extends SocialAppStates{}
class AddFriendSuccessState extends SocialAppStates {}
class AddFriendErrorState extends SocialAppStates{}
///End of AddFriend State



