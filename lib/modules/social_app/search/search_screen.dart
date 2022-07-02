import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';

import '../../../models/social_user_model.dart';
import '../../../shared/styles/colors.dart';
import '../../friend_profile/friend_profile.dart';


class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController search = TextEditingController();
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var bloc = SocialAppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            // leading: IconButton(
            //   onPressed: () {
            //     // try {
            //     //   ZoomDrawer.of(context)!.toggle();
            //     // } catch (error) {
            //     //   Navigator.pop(context);
            //     //
            //     //   print(error.toString());
            //     // }
            //   },
            //   icon: Icon(FontAwesomeIcons.alignLeft),
            // ),
            title: Text(
              "Search",
              style: TextStyle(fontSize: 25),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: Center(
                            child: TextFormField(
                              onChanged: (value){
                                bloc.getSearchUsers(search.text);
                              },
                              controller: search,
                              decoration: InputDecoration(
                                  hintText: "Search ......",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(fontSize: 18),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: social3, width: 2),
                                      borderRadius: BorderRadius.circular(20)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: social3, width: 2),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: social3, width: 2),
                                      borderRadius: BorderRadius.circular(20))),
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'search must not be null';
                                }
                                return null;
                              },
                              onFieldSubmitted: (val){
                                bloc.getSearchUsers(search.text);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        radius: 25,
                        child: IconButton(
                          onPressed: () {
                            bloc.getSearchUsers(search.text);
                          },
                          icon: Icon(
                            Icons.search,
                            color:
                            Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  ConditionalBuilder(
                    condition: state is! GetAllSearchUserLoadingState,
                    builder: (context) => Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) =>
                              ChatItem(context, bloc.usersSearch[index]),
                          separatorBuilder: (context, index) => SizedBox(),
                          itemCount: bloc.usersSearch.length),
                    ),
                    fallback: (context) =>search.text==''?SizedBox() :LinearProgressIndicator(
                      color: social3,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget ChatItem(context, UserModel model) {
    var bloc1 = SocialAppCubit.get(context);
    return InkWell(
      onTap: () {
        if (model.uId == bloc1.userModel!.uId) {
          bloc1.changeBottomNavBarIndex(4);
          Navigator.pop(context);
        } else {
          bloc1.getFriendData(model.uId);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FriendProfile(friendId: model.uId,)));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(model.profileImage),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        model.name,
                        style: Theme.of(context).textTheme.headline5,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.check_circle,
                        color: social3,
                        size: 17,
                      )
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration:
                    BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: Offset(0, 4))
                    ]),
                    child: CircleAvatar(
                        backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                        child: Icon(
                          Icons.person_add_alt,
                          color: social3,
                        )),
                  ),
                  // radius: 25,
                ))
          ],
        ),
      ),
    );
  }
}
