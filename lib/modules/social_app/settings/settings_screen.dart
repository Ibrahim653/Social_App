import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import 'package:social_app/modules/image_view_screen/image_view_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/components/navigator.dart';
import 'package:social_app/shared/styles/styles.dart';

import '../../../shared/styles/colors.dart';
import '../edit_profile/edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialAppCubit.get(context).userModel;
        return Scaffold(
          body: ConditionalBuilder(
            condition: userModel != null,
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          /////الصورة الخلفيه والشخصيه
                          SizedBox(
                            height: 290,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                //////صورة الخلفيه////////
                                Align(
                                  child: InkWell(
                                    onTap: () {
                                      MyNavigators.navigateTo(
                                        context,
                                        ImageViewScreen(
                                          image: SocialAppCubit.get(context)
                                              .userModel!
                                              .coverImage,
                                          body: '',
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(25),
                                          bottomLeft: Radius.circular(25),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              userModel!.coverImage!),
                                        ),
                                      ),
                                      width: double.infinity,
                                      height: 235,
                                    ),
                                  ),
                                  // Container(
                                  //   alignment: AlignmentDirectional.topStart,
                                  //   height: 235,
                                  //   width: double.infinity,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.only(
                                  //       topLeft: Radius.circular(4),
                                  //       topRight: Radius.circular(4),
                                  //     ),
                                  //     image: DecorationImage(
                                  //       image:
                                  //           NetworkImage(userModel!.coverImage),
                                  //       fit: BoxFit.cover,
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                                ////////الصورة الشخصيه////////
                                InkWell(
                                  onTap: () {
                                    MyNavigators.navigateTo(
                                      context,
                                      ImageViewScreen(
                                        image: SocialAppCubit.get(context)
                                            .userModel!
                                            .profileImage,
                                        body: '',
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 64,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          NetworkImage(userModel.profileImage),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          ///////اسم اليوزر//////
                          Text(
                            userModel.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          ///////البيووووو//////
                          Text(
                            userModel.bio!,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Text(
                                          "100",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Post",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Text(
                                          "50",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Photos",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Text(
                                          "265",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Followers",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Text(
                                          "64",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '10',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      MyNavigators.navigateTo(
                                        context,
                                        EditProfileScreen(),
                                      );
                                    },
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          color: social3, fontSize: 20),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  height: 35,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      MyNavigators.navigateTo(
                                        context,
                                        EditProfileScreen(),
                                      );
                                    },
                                    child: Icon(
                                      IconBroken.Edit,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return SocialAppCubit.get(context)
                                    .postsList[index]
                                    .uId ==
                                uId
                            ? buildPostItem(
                                SocialAppCubit.get(context).postsList[index],
                                context,
                                index,
                                SocialAppCubit.get(context)
                                    .postsList[index]
                                    .commentsNum!)
                            : SizedBox();

                        // print(
                        //     "length is ${SocialAppCubit.get(context).postsList.length}");
                        // return buildPostItem(
                        //     SocialAppCubit.get(context).myPostsList[index],
                        //     context,
                        //     index,
                        //     0);
                      },
                      childCount: SocialAppCubit.get(context).postsList.length,
                    ),
                  ),
                ],
              );
            },
            fallback: (context) => Center(
                child: CircularProgressIndicator(
              color: social3,
            )),
          ),
        );
      },
    );
  }
}
