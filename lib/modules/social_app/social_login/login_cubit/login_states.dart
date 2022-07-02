abstract class SocialLoginStates {}

class SocialLoginInitialState extends SocialLoginStates {}

  class SocialLoginLoadingState extends SocialLoginStates {}

class SocialLoginSuccessState extends SocialLoginStates {
  final String uId;

  SocialLoginSuccessState(this.uId);
}

class SocialLoginErrorState extends SocialLoginStates {
  final String error;

  SocialLoginErrorState(this.error);
}

class SocialLoginPasswordVisibilityState extends SocialLoginStates {}

//
// class GetUserSuccessState extends SocialLoginStates {}
// class GetUserErrorState extends SocialLoginStates {
//   final String error;
//
//   GetUserErrorState(this.error);
// }
// class GetUserLoadingState extends SocialLoginStates {}

