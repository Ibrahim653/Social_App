import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_app/modules/edit_post/edit_post.dart';
import 'package:social_app/modules/friend_profile/friend_profile.dart';
import 'package:social_app/modules/social_app/settings/settings_screen.dart';
import 'package:social_app/shared/styles/styles.dart';

import '../../layout/social_app/social_cubit/cubit.dart';
import '../../layout/social_app/social_cubit/states.dart';
import '../../models/post_model.dart';
import '../../modules/image_view_screen/image_view_screen.dart';
import '../../modules/social_app/comment_screen/comment_screen.dart';
import '../styles/colors.dart';
import 'constants.dart';
import 'navigator.dart';

defaultTextButton({
  required Text text,
  required Function() onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    child: text,
  );
}

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required FormFieldValidator validate,
  void Function(String)? onChanged,
  void Function(String)? onSubmit,
  void Function()? onTap,
  required String label,
   IconData? prefix,
  bool isPassword = false,
  bool showPass = false,
  Function? changeVisibility,
}) {
  return TextFormField(
    obscureText: showPass,
    controller: controller,
    keyboardType: keyboardType,
    validator: validate,
    onFieldSubmitted: onSubmit,
    onChanged: onChanged,
    onTap: onTap,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: isPassword
          ? IconButton(
              onPressed: () {
                changeVisibility!();
              },
              icon: showPass
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
            )
          : null,
      border: const OutlineInputBorder(),
    ),
  );
}

defaultAppBar(
    {Text? title, List<Widget>? actions, required BuildContext context}) {
  return AppBar(
    title: title,
    actions: actions,
    titleSpacing: 5.0,
    leading: IconButton(
      icon: Icon(IconBroken.Arrow___Left_2),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

Widget defaultButton({
  required Function onPressed,
  required Widget child,

}) {
  return Container(
    height: 45,
    width: double.infinity,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(
      color: defaultColor,
        borderRadius: BorderRadius.circular(8)),
    child: MaterialButton(
      onPressed: () {
        onPressed();
      },
      child: child,
    ),
  );
}

Widget buildPostItem(
  PostModel model,
  BuildContext context,
  int index,
  int commentsNum,
) {
  return BlocConsumer<SocialAppCubit, SocialAppStates>(
    listener: (context, state) {},
    builder: (context, state) {
      return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          elevation: 5,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /////صورة واسم اليوزر
                GestureDetector(
                  onTap: () {
                    if (SocialAppCubit.get(context).postsList[index].uId ==
                        uId) {
                      SocialAppCubit.get(context).changeBottomNavBarIndex(4);
                      //   MyNavigators.navigateTo(context, SettingsScreen());
                    } else if (SocialAppCubit.get(context)
                            .postsList[index]
                            .uId !=
                        uId) {
                      SocialAppCubit.get(context).getFriendData(
                          SocialAppCubit.get(context).postsList[index].uId);
                      MyNavigators.navigateTo(
                          context,
                          FriendProfile(
                            friendId: SocialAppCubit.get(context)
                                .postsList[index]
                                .uId,
                          ));
                    }
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(model.image),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  model.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          fontSize: 17,
                                          height: 1.4,
                                          fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.blue[700],
                                  size: 16,
                                )
                              ],
                            ),
                            Text(
                              DateFormat.yMMMd().format(model.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                        onPressed: () {
                          showMaterialModalBottomSheet(
                              backgroundColor: Colors.black.withOpacity(0.9),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.save,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                            minLeadingWidth: 60,
                                            title: Text(
                                              'Save Post Image',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        if (model.uId ==
                                            SocialAppCubit.get(context)
                                                .userModel!
                                                .uId)
                                          Expanded(
                                            child: ListTile(
                                              leading: Icon(
                                                IconBroken.Upload,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                              minLeadingWidth: 60,
                                              title: Text(
                                                'Edit Post',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                MyNavigators.navigateTo(
                                                    context,
                                                    EditPosts(
                                                        postModel: model,
                                                        postId: SocialAppCubit
                                                                .get(context)
                                                            .postsId[index]));
                                              },
                                            ),
                                          ),
                                        if (model.uId ==
                                            SocialAppCubit.get(context)
                                                .userModel!
                                                .uId)
                                          Expanded(
                                            child: ListTile(
                                              leading: Icon(
                                                IconBroken.Delete,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                              minLeadingWidth: 60,
                                              title: Text(
                                                'Delete Post',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                SocialAppCubit.get(context)
                                                    .deletePost(
                                                        postId: SocialAppCubit
                                                                .get(context)
                                                            .postsId[index]);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: Icon(Icons.more_horiz),
                      )
                    ],
                  ),
                ),
                /////Divider////
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
                ////نص البوست//
                if (model.text != '')
                  Text(
                    model.text!,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                /////الهاشتاج///
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 10, top: 5),
                //   child: Container(
                //     width: double.infinity,
                //     child: Wrap(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsetsDirectional.only(end: 6),
                //           child: Container(
                //             height: 25,
                //             child: MaterialButton(
                //               padding: EdgeInsets.zero,
                //               minWidth: 1,
                //               onPressed: () {},
                //               child: Text("#Software",
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .caption!
                //                       .copyWith(
                //                           color: defaultColor,
                //                           fontWeight: FontWeight.bold)),
                //             ),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsetsDirectional.only(end: 6),
                //           child: Container(
                //             height: 25,
                //             child: MaterialButton(
                //               padding: EdgeInsets.zero,
                //               minWidth: 1,
                //               onPressed: () {},
                //               child: Text("#flutter",
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .caption!
                //                       .copyWith(
                //                           color: defaultColor,
                //                           fontWeight: FontWeight.bold)),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                //////////// صورة البوست//////
                if (model.postImage != '')
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 15,
                    ),
                    child: Container(
                      // height: 250,
                      margin: EdgeInsets.only(top: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GestureDetector(
                          onTap:(){
                            MyNavigators.navigateTo(
                              context,
                              ImageViewScreen(
                                image: model.postImage,
                                body: '',
                              ),
                            );
                          } ,
                          child: Image(
                              image: NetworkImage(model.postImage!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                //// /////  عددالكومنت واللايك
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                if (SocialAppCubit.get(context)
                                        .likedByMe[index] ==
                                    false)
                                  Icon(
                                    IconBroken.Heart,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                if (SocialAppCubit.get(context)
                                        .likedByMe[index] ==
                                    true)
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                const SizedBox(width: 5),
                                Text(
                                  SocialAppCubit.get(context)
                                      .likes[index]
                                      .toString(),
                                  //SocialAppCubit.get(context).postsList[index].likesNum!.length.toString(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  IconBroken.Chat,
                                  color: Colors.amber,
                                  size: 25,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  commentsNum.toString(),

                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            MyNavigators.navigateTo(
                                context,
                                CommentsScreen(
                                  SocialAppCubit.get(context).postsId[index],
                                  SocialAppCubit.get(context).userModel!.uId,
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ////// Divider/////
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 1.0,
                    color: Colors.grey,
                  ),
                ),
                /////اعمل لايك و كومنت
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            MyNavigators.navigateTo(
                                context,
                                CommentsScreen(
                                  SocialAppCubit.get(context).postsId[index],
                                  SocialAppCubit.get(context).userModel!.uId,
                                ));


                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                    SocialAppCubit.get(context)
                                        .userModel!
                                        .profileImage),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "Write a comment...",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),

                      ////////like////////
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                IconBroken.Heart,
                                color: SocialAppCubit.get(context)
                                            .likedByMe[index] ==
                                        true
                                    ? Colors.red
                                    : null,
                                size: 25,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Like',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (SocialAppCubit.get(context).likedByMe[index] ==
                              true) {
                            SocialAppCubit.get(context).disLikePost(
                                SocialAppCubit.get(context).postsId[index]);
                            SocialAppCubit.get(context).likedByMe[index] =
                                false;
                            SocialAppCubit.get(context).likes[index]--;
                          } else {
                            SocialAppCubit.get(context).likePost(
                                SocialAppCubit.get(context).postsId[index]);
                            SocialAppCubit.get(context).likedByMe[index] = true;
                            SocialAppCubit.get(context).likes[index]++;
                          }

                          // SocialAppCubit.get(context).likePost(SocialAppCubit
                          //     .get(context)
                          //     .postsId[index]);

                          // var date = DateTime.now();
                          //   SocialAppCubit.get(context).likePost2(
                          //       SocialAppCubit.get(context).postsId[index], date);
                          // if (isPersonal) {
                          //   SocialAppCubit.get(context).likePost2(
                          //       SocialAppCubit.get(context)
                          //           .postsIdPersonal[index],
                          //       date);
                          // } else {
                          //   SocialAppCubit.get(context).likePost2(
                          //       SocialAppCubit.get(context).postsId[index], date);
                          // }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: MediaQuery.of(context).size.height * 0.008,
                  color: Colors.black26,
                )
              ],
            ),
          )
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     child: Text(
          //       'Communicate with friends',
          //       style: TextStyle(color: Colors.black),
          //     ),
          //   ),
          // ),

          );
    },
  );
}

// backGroundImage() {
//   return ShaderMask(
//     shaderCallback: (bound) => LinearGradient(
//             colors: [Colors.black, Colors.black12],
//             begin: Alignment.bottomCenter,
//             end: Alignment.center)
//         .createShader(bound),
//     child: Container(
//       decoration: BoxDecoration(
//           image: DecorationImage(
//         image: AssetImage('assets/images/login background.jpg'),
//         fit: BoxFit.cover,
//       )),
//     ),
//   );
// }

// Widget myTextField({
//   required String labelText,
//   required String validateTitle,
//   required IconData prefix,
//   required TextEditingController controller,
//   required TextInputType type,
//   bool isPassword = false,
//   bool showPass = false,
//   Function? changeVisibility,
// }) {
//   return TextFormField(
//     decoration: InputDecoration(
//       label: Text(labelText),
//       prefixIcon: Icon(prefix),
//       border: const OutlineInputBorder(),
//       suffixIcon: isPassword
//           ? IconButton(
//               onPressed: () {
//                 changeVisibility!();
//               },
//               icon: showPass
//                   ? const Icon(Icons.visibility_outlined)
//                   : const Icon(Icons.visibility_off_outlined),
//             )
//           : null,
//     ),
//     controller: controller,
//     keyboardType: type,
//     validator: (value) {
//       if (value!.isEmpty) {
//         return validateTitle + ' must not be empty!';
//       }
//       return null;
//     },
//     obscureText: showPass,
//   );
// }
