import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/social_app/social_register/register_cubit/register_cubit.dart';
import 'package:social_app/modules/social_app/social_register/register_cubit/register_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/navigator.dart';

import '../../../layout/social_app/social_app_layout.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is UserCreateSuccessState){
            MyNavigators.navigateAndFinish(context, SocialAppLayout());
          }
          // if (state is UserCreateSuccessState) {
          //   uId = state.uId;
          //   CacheHelper.setData(key: 'uId', value: state.uId).then((value) {
          //     MyNavigators.navigateAndFinish(context, const MainScreen());
          //   });
          // }
          // if (state is UserRegisterErrorState) {
          //   if (state.error.contains('[firebase_auth/email-already-in-use]')) {
          //     MyToast(
          //         msg: state.error.replaceRange(0, 37, ''),
          //         state: ToastStates.ERROR)
          //         .showToast();
          //   } else if (state.error.contains('[firebase_auth/weak-password]')) {
          //     MyToast(
          //         msg: state.error.replaceRange(0, 30, ''),
          //         state: ToastStates.ERROR)
          //         .showToast();
          //   } else {
          //     MyToast(
          //         msg: state.error.replaceRange(0, 30, ''),
          //         state: ToastStates.ERROR)
          //         .showToast();
          //   }
          // }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(
                color: Colors.black,
              ),
            ),
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
                          'register'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Register now to communicate with friends',
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

                         _buildRegisterButton(state, cubit),
                        const SizedBox(
                          height: 15,
                        ),
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

  Widget _buildInputFields(RegisterCubit cubit) {
    return Column(
      children: [
        defaultFormField(
          controller: usernameController,
          keyboardType: TextInputType.text,
          validate: (val) {
            if(val!.isEmpty){
              return "username must not be empty";
            }else{
              return null;
            }
          },
          label: 'Username',
          prefix: Icons.person,
        ),
        const SizedBox(height: 15),
        defaultFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validate: (val) {
            if(val!.isEmpty){
              return "email must not be empty";
            }else{
              return null;
            }

          },
          label: 'Email',
          prefix: Icons.email,
        ),
        const SizedBox(height: 15),
        defaultFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validate: (val) {
            if(val!.isEmpty){
              return "phone must not be empty";
            }else{
              return null;
            }
          },
          label: 'Phone',
          prefix: Icons.phone_android_outlined,
        ),
        const SizedBox(height: 15),
        defaultFormField(
          onTap: (){
            
          },
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          validate: (val) {
            if(val!.isEmpty){
              return "password must not be empty";
            }else{
              return null;
            }
          },
          label: 'Password',
          prefix: Icons.lock,
          isPassword: true,
          showPass: cubit.showPass,
          changeVisibility: (){
            cubit.changePassVisibility();
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton(RegisterStates state, RegisterCubit cubit) {
    return Container(
      height: 45,
      width: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        child: state is UserRegisterLoadingState
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(
                'register'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            cubit.userRegister(
              email: emailController.text,
              password: passwordController.text,
              name: usernameController.text,
              phone: phoneController.text,
            );

          }
        },
      ),
    );
  }
}



