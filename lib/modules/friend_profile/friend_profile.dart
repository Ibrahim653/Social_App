import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import 'package:social_app/modules/image_view_screen/image_view_screen.dart';
import 'package:social_app/modules/social_app/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/navigator.dart';
import 'package:social_app/shared/styles/styles.dart';

import '../../../shared/styles/colors.dart';

class FriendProfile extends StatelessWidget {
  String friendId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialAppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: ConditionalBuilder(
            condition: cubit.friendModel != null,
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: [
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
                                          image: cubit.userModel!.coverImage,
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
                                              cubit.friendModel!.coverImage!),
                                        ),
                                      ),
                                      width: double.infinity,
                                      height: 235,
                                    ),
                                  ),
                                ),
                                ////////الصورة الشخصيه////////
                                InkWell(
                                  onTap: () {
                                    MyNavigators.navigateTo(
                                      context,
                                      ImageViewScreen(
                                        image: cubit.userModel!.profileImage,
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
                                      backgroundImage: NetworkImage(
                                          cubit.friendModel!.profileImage),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          ///////اسم اليوزر//////
                          Text(
                            cubit.friendModel!.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          ///////البيووووو//////
                          Text(
                            cubit.friendModel!.bio!,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: defaultButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              IconBroken.Add_User,
                                              color: WHITE,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Add Friend',
                                              style: TextStyle(color: WHITE),
                                            )
                                          ],
                                        ),
                                        onPressed: () {
                                          cubit.addFriend(
                                            friendsUid: cubit.userModel!.uId,
                                            friendName: cubit.userModel!.name,
                                            friendProfilePic: cubit.userModel!.profileImage,
                                          );
                                        })),
                                const SizedBox(width: 15),
                                Expanded(
                                    child: defaultButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              IconBroken.Message,
                                              color: WHITE,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Message',
                                              style: TextStyle(color: WHITE),
                                            )
                                          ],
                                        ),
                                        onPressed: () {
                                          MyNavigators.navigateTo(
                                              context,
                                              ChatDetailsScreen(
                                                userModel: cubit.friendModel,
                                              ));
                                        })),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return cubit.postsList[index].uId == friendId
                            ? buildPostItem(cubit.postsList[index], context,
                                index, cubit.postsList[index].commentsNum!)
                            : const SizedBox();
                      },
                      childCount: cubit.postsList.length,
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

  FriendProfile({
    required this.friendId,
  });
}
