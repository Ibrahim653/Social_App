import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import 'package:social_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:social_app/modules/social_app/search/search_screen.dart';
import 'package:social_app/shared/components/navigator.dart';
import 'package:social_app/shared/styles/styles.dart';

class SocialAppLayout extends StatelessWidget {
  const SocialAppLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
        listener: (context, state) {
          if(state is SocialNewPostState)
            MyNavigators.navigateTo(context, NewPostScreen());
        },
        builder: (context, state) {
          var cubit = SocialAppCubit.get(context);
          return Scaffold(

            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNavBarIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Chat), label: "Chat"),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Paper_Upload), label: "Post"),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Location), label: "Users"),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Setting), label: "Settings"),
              ],
            ),
            appBar: AppBar(

              title: Text(cubit.titles[cubit.currentIndex]),
              actions: [
                IconButton(onPressed: (){}, icon: Icon(IconBroken.Notification)),
                IconButton(
                    onPressed: () {
                      MyNavigators.navigateTo(context, Search());
                    }, icon: Icon(IconBroken.Search)),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
          );
        });
  }
}

////// verify email/////////
// Widget build(BuildContext context) {
//   return BlocConsumer<SocialAppCubit, SocialAppStates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         var cubit=SocialAppCubit.get(context);
//         var model = cubit.model;
//         print("model is $model");
//         return Scaffold(
//             appBar: AppBar(
//               title: Text("News Feed"),
//             ),
//             body: SocialAppCubit.get(context).model != null
//                 ? Column(
//               children: [
//                 //FirebaseAuth.instance.currentUser!.emailVerified
//                 if (!model!.isEmailVerified)
//                   Container(
//                     color: Colors.amber.withOpacity(.6),
//                     child: Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         children: [
//                           Icon(Icons.info_outline),
//                           SizedBox(width: 15),
//                           const Expanded(
//                               child: Text("please verify your email")),
//                           defaultTextButton(
//                             text: "Send",
//                             onPressed: () {
//                               FirebaseAuth.instance.currentUser!
//                                   .sendEmailVerification().then((value) {
//                                 MyToast(msg: "please check your mail", state: ToastStates.SUCCESS);
//                               }).catchError((error){
//
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             )
//                 : Center(child: CircularProgressIndicator()));
//       });
// }
