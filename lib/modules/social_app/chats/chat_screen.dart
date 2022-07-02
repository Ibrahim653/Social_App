import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/shared/components/navigator.dart';

import '../chat_details/chat_details_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialAppCubit.get(context).users.isNotEmpty,
          builder: ( context) =>CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return
                      buildChatItem(SocialAppCubit.get(context).users[index],context, );
                  },
                  childCount: SocialAppCubit.get(context).users.length,
                ),
              ),
            ],
          ),
          fallback: (context) =>Center(child: CircularProgressIndicator()),

        );
      },
    );
  }

  Widget buildChatItem(UserModel model,BuildContext context) {
    return InkWell(
      onTap: () {
        MyNavigators.navigateTo(context, ChatDetailsScreen(userModel: model,));

      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                model.profileImage
                 ),
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

          ],
        ),
      ),
    );
  }
}
