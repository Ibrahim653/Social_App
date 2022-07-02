import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/styles.dart';

import '../../../layout/social_app/social_cubit/cubit.dart';
import '../../../layout/social_app/social_cubit/states.dart';
import '../../../shared/components/constants.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialAppCubit.get(context).userModel;
        var profileImage = SocialAppCubit.get(context).profileImage;
        var coverImage = SocialAppCubit.get(context).coverImage;
        nameController.text = userModel!.name;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: const Text('Edit Profile'),
              actions: [
                defaultTextButton(
                  text: Text(
                    "Update",
                    style: TextStyle(
                        color: defaultColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    SocialAppCubit.get(context).updateUserData(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  },
                ),
                const SizedBox(width: 15),
              ]),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 200,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        //////صورة الخلفيه////////
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage(userModel.coverImage!)
                                        : FileImage(coverImage)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black45,
                                radius: 18,
                                child: IconButton(
                                  onPressed: () {
                                    SocialAppCubit.get(context).getCoverImage();
                                  },
                                  icon: Icon(
                                    IconBroken.Camera,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ////////الصورة الشخصيه////////
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: profileImage == null
                                    ? NetworkImage(userModel.profileImage)
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black45,
                              radius: 18,
                              child: IconButton(
                                onPressed: () {
                                  SocialAppCubit.get(context).getProfileImage();
                                },
                                icon: Icon(
                                  IconBroken.Camera,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (SocialAppCubit.get(context).profileImageIsSelected ||
                      SocialAppCubit.get(context).coverImageIsSelected)
                    Row(
                      children: [
                        if (SocialAppCubit.get(context).profileImageIsSelected)
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        SocialAppCubit.get(context)
                                            .uploadProfileImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          bio: bioController.text,
                                        );
                                      },
                                      child: Text('Update Profile'),
                                    )),
                                if (state is UploadProfileImageLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (SocialAppCubit.get(context).coverImageIsSelected)
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        SocialAppCubit.get(context)
                                            .uploadCoverImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          bio: bioController.text,
                                        );
                                      },
                                      child: Text('Update Cover'),
                                    )),
                                if (state is UploadCoverImageLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (SocialAppCubit.get(context).profileImage != null ||
                      SocialAppCubit.get(context).coverImage != null)
                    const SizedBox(height: 20),
                  /////////اسم اليوزر///////
                  defaultFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    validate: (value) {
                      if (value.isEmpty) {
                        return "Name must not be empty";
                      }
                      return null;
                    },
                    label: "Name",
                    prefix: IconBroken.User,
                  ),
                  const SizedBox(height: 10),
                  ///////////رقم الموبيل///////////
                  defaultFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validate: (value) {
                      if (value.isEmpty) {
                        return "phone number must not be empty";
                      }
                      return null;
                    },
                    label: "Phone",
                    prefix: IconBroken.Call,
                  ),
                  const SizedBox(height: 10),
                  /////////////البيوووو////////
                  defaultFormField(
                    controller: bioController,
                    keyboardType: TextInputType.text,
                    validate: (value) {
                      if (value.isEmpty) {
                        return "Bio must not be empty";
                      }
                      return null;
                    },
                    label: "Bio",
                    prefix: IconBroken.Info_Circle,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('LogOut'),
                      IconButton(
                        onPressed: () {
                          signOut(context);
                        },
                        icon: Icon(IconBroken.Logout),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  OutlinedButton buildOutlinedButton({
    required Function() onPressed,
    required String text,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
