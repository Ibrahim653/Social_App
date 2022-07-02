import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/social_app/social_register/register_cubit/register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool showPass = true;

  void changePassVisibility() {
    showPass = !showPass;
    emit(RegisterChangePassVisibilityState());
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(UserRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      emit(UserRegisterErrorState(error.toString()));
      print(error.toString());
    });
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    UserModel userModel = UserModel(
      name: name,
      email: email,
      uId: uId,
      phone: phone,
      profileImage:
          'https://img.freepik.com/free-photo/horizontal-shot-happy-asian-teenage-girl-enjoys-good-sound-quality-new-headphones-listens-favorite-music-closes-eyes-from-satisfaction-smiles-broadly-wears-hoodie-hat-isolated-pink-wall_273609-53680.jpg?w=1380',
      bio: 'write your bio ...',
      coverImage: 'https://img.freepik.com/free-photo/horizontal-shot-happy-asian-teenage-girl-enjoys-good-sound-quality-new-headphones-listens-favorite-music-closes-eyes-from-satisfaction-smiles-broadly-wears-hoodie-hat-isolated-pink-wall_273609-53680.jpg?w=1380',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(UserCreateSuccessState(uId));
    }).catchError((error) {
      emit(UserCreateErrorState(error.toString()));
    });
  }


}
