import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import '../../../layout/social_app/social_cubit/cubit.dart';
import '../../../shared/components/components.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (BuildContext context, state) {
        return ConditionalBuilder(
          condition: SocialAppCubit.get(context).postsList.isNotEmpty &&
              SocialAppCubit.get(context).userModel != null,
          builder: (context) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                //////items before list//////
                child: Column(
                  children: const [
                    Card(
                      margin: EdgeInsets.all(8),
                      elevation: 5,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(
                        image: NetworkImage(
                          'https://img.freepik.com/free-vector/happy-united-business-team_74855-6520.jpg?w=1380',
                        ),
                        fit: BoxFit.cover,
                        height: 225,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 8),

                    // ListView.separated(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemBuilder: (context, index) => buildPostItem(context),
                    //   separatorBuilder: (context, index) => const SizedBox(height: 8),
                    //   itemCount: 200,
                    // ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {

                    return buildPostItem(
                        SocialAppCubit.get(context).postsList[index],
                        context,
                        index,
                        SocialAppCubit.get(context).postsList[index].commentsNum!);
                  },
                  childCount: SocialAppCubit.get(context).postsList.length,
                ),
              ),
            ],
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

}
