import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/friend_profile/friend_profile.dart';
import 'package:social_app/shared/components/navigator.dart';
import 'package:social_app/shared/styles/styles.dart';

import '../../../shared/styles/colors.dart';
import '../chat_details/chat_details_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Friend Request',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                ////////friend request/////////
                ConditionalBuilder(
                  condition: false,
                  builder: (BuildContext context) => ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Text('true'),
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemCount: 100,
                  ),
                  fallback: (BuildContext context) => Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: dark2,
                          borderRadius: BorderRadius.circular(10)),
                      alignment: AlignmentDirectional.center,
                      child: const Text(
                        'No Friend Request',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )),
                ),
                ///////people you may know//////////
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'People You May Know',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                ConditionalBuilder (
                  condition: SocialAppCubit.get(context).users.isNotEmpty,
                  builder: (context) => ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        buildUserItem(
                      SocialAppCubit.get(context).users[index],
                      context,
                    ),
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemCount: SocialAppCubit.get(context).users.length,
                  ),
                  fallback: (context) =>
                      Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildUserItem(UserModel model, BuildContext context) {
    return InkWell(
      onTap: () {
        SocialAppCubit.get(context)
            .getFriendData(
            model.uId);
        MyNavigators.navigateTo(
          context,
          FriendProfile(friendId: model.uId),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(model.profileImage),
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
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 17,
                            height: 1.4,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              IconBroken.Arrow___Right_Circle,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
