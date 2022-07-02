import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

import '../../../shared/styles/colors.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);

  var postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {
        if (state is SocialCreatePostSuccessState) {
        //  SocialAppCubit.get(context).getPosts();
          SocialAppCubit.get(context).removePostImage();
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Your post is shared successfully",
              fontSize: 16,
              gravity: ToastGravity.BOTTOM,
              textColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundColor: social3,
              toastLength: Toast.LENGTH_LONG);
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: defaultAppBar(
              context: context,
              title: const Text('New Post'),
              actions: [
                defaultTextButton(
                  text: Text(
                    "POST",
                    style: TextStyle(
                      color: defaultColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (SocialAppCubit.get(context).PostImage == null) {
                      SocialAppCubit.get(context).createPost(
                          date: DateTime.now(), text: postController.text);
                    } else {
                      SocialAppCubit.get(context).uploadPostImage(
                          dateTime: DateTime.now(), text: postController.text);
                    }
                  },
                ),
                const SizedBox(width: 15),
              ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is SocialCreatePostLoadingState)
                    LinearProgressIndicator(),
                  if (state is SocialCreatePostLoadingState)
                    SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            SocialAppCubit.get(context)
                                .userModel!
                                .profileImage),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  SocialAppCubit.get(context).userModel!.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          fontSize: 19,
                                          height: 1.4,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: postController,
                    decoration: InputDecoration(
                      hintText: "What is in your mind ...",
                      hintStyle: Theme.of(context).textTheme.bodyText2,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (SocialAppCubit.get(context).PostImage != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 9,
                                    spreadRadius: 4,
                                    offset: Offset(0, 4))
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                  image: FileImage(
                                      SocialAppCubit.get(context).PostImage!),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              SocialAppCubit.get(context).removePostImage();
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        blurRadius: 9,
                                        spreadRadius: 4,
                                        offset: Offset(0, 4))
                                  ]),
                              child: CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .scaffoldBackgroundColor,
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: social3,
                                  )),
                            ))
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (SocialAppCubit.get(context).PostImage == null)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.63,
                    ),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.4))),
                      child: MaterialButton(
                          onPressed: () {
                            SocialAppCubit.get(context).getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: social2,
                              ),
                              Text(
                                " add photos",
                                style: TextStyle(
                                    color: social2,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              )
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                  // Stack(
                  //   alignment: AlignmentDirectional.topEnd,
                  //   children: [
                  //     Container(
                  //       height: 150,
                  //       width: double.infinity,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(4),
                  //         image: DecorationImage(
                  //           image: FileImage(
                  //               SocialAppCubit.get(context).postImage!),
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //     ),
                  //     CircleAvatar(
                  //       backgroundColor: Colors.black45,
                  //       radius: 18,
                  //       child: IconButton(
                  //         onPressed: () {
                  //           SocialAppCubit.get(context).removePostImage();
                  //         },
                  //         icon: Icon(
                  //           Icons.close,
                  //           size: 20,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 30),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextButton.icon(
                  //         onPressed: () {
                  //           SocialAppCubit.get(context).getPostImage();
                  //         },
                  //         icon: Icon(IconBroken.Image),
                  //         label: Text("add photo"),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: TextButton(
                  //         onPressed: () {},
                  //         child: Text("# tags"),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
