import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/social_user_model.dart';
import 'login_states.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);
  bool showPass = true;

  changePasswordVisibility() {
    showPass = !showPass;

    emit(SocialLoginPasswordVisibilityState());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(SocialLoginSuccessState(value.user!.uid));
      print(value.user!.email);
      print(value.user!.uid);
    }).catchError((error) {
      emit(SocialLoginErrorState(error.toString()));
    });

    // FirebaseAuth.instance
    //     .signInWithEmailAndPassword(
    //   email: email,
    //   password: password,
    // )
    //     .then((value) {
    //   emit(SocialLoginSuccessState(value.user!.uid));
    //   getUser();
    // }).catchError((error) {
    //   emit(SocialLoginErrorState(error.toString()));
    //   print(error);
    // });
  }

  // UserModel? userModel;
  //
  // void getUserData() {
  //   emit(GetUserLoadingState());
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userModel!.uId)
  //       .get()
  //       .then((value) {
  //     userModel = UserModel.fromJson(value.data()!);
  //     emit(GetUserSuccessState());
  //   }).catchError((error) {
  //     print(error);
  //     emit(GetUserErrorState(error.toString()));
  //   });
  // }
}
