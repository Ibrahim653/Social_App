import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/social_app/social_register/social_register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/navigator.dart';
import 'package:social_app/shared/components/toast.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import '../../../layout/social_app/social_app_layout.dart';
import 'login_cubit/login_cubit.dart';
import 'login_cubit/login_states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            MyToast(
              msg: state.error.replaceRange(0, 31, ''),
              state: ToastStates.ERROR,
            ).showToast();
          }
          if (state is SocialLoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              MyNavigators.navigateAndFinish(context, SocialAppLayout());
            });
          }
          // if (state is SocialLoginSuccessState) {
          //   uId = state.uId;
          //   CacheHelper.setData(key: 'uId', value: state.uId).then((value) {
          //     MyNavigators.navigateAndFinish(context, const MainScreen());
          //   });
          // }
          // if (state is UserLoginErrorState) {
          //   MyToast(
          //           msg: state.error.replaceRange(0, 31, ''),
          //           state: ToastStates.ERROR)
          //       .showToast();
          // }
        },
        builder: (context, state) {
          var cubit = SocialLoginCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'login'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey, fontSize: 17),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildInputFields(cubit),
                        const SizedBox(
                          height: 15,
                        ),
                        _buildLoginButton(state, cubit),
                        const SizedBox(
                          height: 15,
                        ),
                        _buildBottomRow(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputFields(SocialLoginCubit cubit) {
    return Column(
      children: [
        defaultFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validate: (value) {
            if (value.isEmpty) {
              return "email must not be empty";
            } else {
              return null;
            }
          },
          label: 'Email',
          prefix: Icons.email,
        ),
        const SizedBox(
          height: 15,
        ),
        defaultFormField(
          isPassword: true,
          showPass: cubit.showPass,
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          validate: (value) {
            if (value.isEmpty) {
              return "password must not be empty";
            } else {
              return null;
            }
          },
          label: 'Password',
          prefix: Icons.lock,
          changeVisibility: () {
            cubit.changePasswordVisibility();
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(SocialLoginStates state, SocialLoginCubit cubit) {
    return Container(
      height: 45,
      width: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        child: state is SocialLoginLoadingState
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(
                'login'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            cubit.userLogin(
              email: emailController.text,
              password: passwordController.text,
            );
          }

          //   if (formKey.currentState!.validate()) {
          //     login_cubit.
          //   (
          //   email: emailController.text,
          //   password: passwordController.text
          //   ,
          //   );
          // }
        },
      ),
    );
  }

  Widget _buildBottomRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have account?",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          child: Text(
            'register'.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
