import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';

import '../../../layout/social_app/social_cubit/cubit.dart';
import '../../../models/comment_model.dart';
import '../../../models/post_model.dart';
import '../../../shared/styles/styles.dart';

class CommentsScreen extends StatefulWidget {
  final String postUid;

  final String receiverUid;

  CommentsScreen(this.postUid, this.receiverUid);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  var commentController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SocialAppCubit cubit = SocialAppCubit.get(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              IconBroken.Arrow___Left_2,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark),
          elevation: 0,
          backgroundColor: GREEN.withOpacity(0.4),
          titleSpacing: 5,
          title: Text(
            'Comments',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postUid)
                .collection('comments')
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: BROWN,
                  ),
                );
              } else {
                cubit.comments = [];
                snapshot.data.docs.forEach((element) {
                  cubit.comments.add(CommentsModel.fromJson(element.data()));
                });
                return ConditionalBuilder(
                    condition:
                        snapshot.hasData == true && cubit.comments.isNotEmpty,
                    builder: (BuildContext context) => Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                reverse: false,
                                itemBuilder: (context, index) {
                                  return buildComment(cubit.comments[index]);
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                  height: 0,
                                ),
                                itemCount: cubit.comments.length,
                              ),
                            ),
                            Container(
                              color: GREEN.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
                                child: Form(
                                  key: formKey,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 0, right: 7),
                                          child: Transform.rotate(
                                              angle: 0,
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      GREEN.withOpacity(0.1),
                                                  child: Icon(
                                                    IconBroken.Image,
                                                    size: 20,
                                                  ))),
                                        ),
                                        onPressed: () {
                                          print('add image');
                                        },
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          autofocus: false,
                                          keyboardType: TextInputType.text,
                                          enableInteractiveSelection: true,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          enableSuggestions: true,
                                          scrollPhysics:
                                              BouncingScrollPhysics(),
                                          decoration: InputDecoration(
                                            icon: SizedBox(
                                              width: 5,
                                            ),
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            fillColor: Colors.grey,
                                            hintText: 'Write your comment...',
                                            hintStyle: TextStyle(
                                                color: Colors.black54),
                                          ),
                                          autocorrect: true,
                                          controller: commentController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The comment can\'t be empty';
                                            }
                                            return null;
                                          },
                                          onFieldSubmitted: (value) {},
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          IconBroken.Send,
                                          color: defaultColor,
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       bottom: 0, right: 7),
                                          //   child: Transform.rotate(
                                          //       angle: 2400,
                                          //       child: CircleAvatar(
                                          //           radius: 20,
                                          //           backgroundColor:
                                          //           GREEN.withOpacity(0.1),
                                          //           child: Icon(
                                          //             IconBroken.Send,
                                          //             size: 20,
                                          //           ))),
                                          //
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            SocialAppCubit.get(context)
                                                .sendComment(
                                                    date: DateTime.now()
                                                        .toString(),
                                                    commentText:
                                                        commentController.text,
                                                    postId: widget.postUid,
                                                commentsNum: cubit.comments.length);
                                            // SocialAppCubit.get(context)
                                            //     .sendNotifications(
                                            //         action: 'COMMENT',
                                            //         targetPostUid:
                                            //             widget.postUid,
                                            //         receiverUid:
                                            //             widget.receiverUid,
                                            //         dateTime: DateTime.now()
                                            //             .toString());
                                             commentController.clear();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    fallback: (BuildContext context) => Column(
                          children: [
                            Expanded(
                                child: Container(
                              child: Center(child: Text('No comments yet')),
                            )),
                            Container(
                              color: GREEN.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
                                child: Form(
                                  key: formKey,
                                  child: Row(
                                    children: [
                                      ///// add image//////
                                      // IconButton(
                                      //   icon: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //         bottom: 0, right: 7),
                                      //     child: Transform.rotate(
                                      //         angle: 0,
                                      //         child: CircleAvatar(
                                      //             radius: 20,
                                      //             backgroundColor: GREEN
                                      //                 .withOpacity(0.1),
                                      //             child: Icon(
                                      //               IconBroken.Image,
                                      //               size: 20,
                                      //             ))),
                                      //   ),
                                      //   onPressed: () {
                                      //     //  SocialAppCubit.get(context).getCommentImage();
                                      //     print('add image');
                                      //   },
                                      // ),
                                      // if(commentImage != null)
                                      //   Padding(
                                      //     padding: const EdgeInsetsDirectional.only(bottom: 8.0),
                                      //     child: Align(
                                      //       alignment: AlignmentDirectional.topStart,
                                      //       child: Row(
                                      //         crossAxisAlignment: CrossAxisAlignment.start,
                                      //         children: [
                                      //           Container(
                                      //             width: 100,
                                      //             height: 100,
                                      //             child:Image.file(
                                      //                 commentImage,
                                      //                 fit: BoxFit.cover,width: 100),
                                      //           ),
                                      //           SizedBox(width: 5,),
                                      //           Container(
                                      //             width: 30,
                                      //             height: 30,
                                      //             child: CircleAvatar(
                                      //               backgroundColor: Colors.grey[300],
                                      //               child: IconButton(
                                      //                 onPressed: (){
                                      //                   SocialAppCubit.get(context).popCommentImage();
                                      //                 },
                                      //                 icon: Icon(Icons.close),iconSize: 15,),
                                      //             ),
                                      //           )
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      Expanded(
                                        child: TextFormField(
                                          autofocus: false,
                                          keyboardType: TextInputType.text,
                                          enableInteractiveSelection: true,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                          enableSuggestions: true,
                                          scrollPhysics:
                                              BouncingScrollPhysics(),
                                          decoration: InputDecoration(
                                              icon: SizedBox(
                                                width: 5,
                                              ),
                                              focusedBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              fillColor: Colors.grey,
                                              hintText: 'Write your comment...',
                                              hintStyle: TextStyle(
                                                  color: Colors.black54)),
                                          autocorrect: true,
                                          controller: commentController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The comment can\'t be empty';
                                            }
                                            return null;
                                          },
                                          //onFieldSubmitted: (value) {},
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          IconBroken.Send,
                                          size: 20,
                                          color: defaultColor,
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       bottom: 0, right: 7),
                                        //   child: Transform.rotate(
                                        //       angle: 2400,
                                        //       child: CircleAvatar(
                                        //           radius: 30,
                                        //           backgroundColor:
                                        //           GREEN.withOpacity(0.1),
                                        //           child: Icon(
                                        //             IconBroken.Send,
                                        //             size: 20,
                                        //             color: defaultColor,
                                        //           ))),
                                        // ),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            SocialAppCubit.get(context)
                                                .sendComment(
                                                    date: DateTime.now()
                                                        .toString(),
                                                    commentText:
                                                        commentController.text,
                                                    postId: widget.postUid,
                                                commentsNum: cubit.comments.length);
                                            commentController.clear();
                                            }
                                            // SocialAppCubit.get(context)
                                            //     .sendNotifications(
                                            //         action: 'COMMENT',
                                            //         targetPostUid:
                                            //             widget.postUid,
                                            //         receiverUid:
                                            //             widget.receiverUid,
                                            //         dateTime: DateTime.now()
                                            //             .toString());
                                            // commentController.clear();
                                            //   }else{
                                            //     SocialAppCubit.get(context).uploadCommentPic(
                                            //       postId: widget.postId,
                                            //       commentText: commentController.text == ''? null:commentController.text,
                                            //       time: TimeOfDay.now().format(context),
                                            //     );
                                            //
                                            //    // commentController.clear();
                                            //     SocialAppCubit.get(context).popCommentImage();

                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ));
              }
            }));
  }

  Widget buildComment(CommentsModel comment) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                comment.image,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.grey.withOpacity(0.2)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.name,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          color: BROWN,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${comment.text}',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
         /////date//////////
         // Text(comment.date.toString()),
        ],
      ),
    );
  }
}
// import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
// import 'package:social_app/layout/social_app/social_cubit/states.dart';
//
// import '../../../shared/styles/colors.dart';
//
//
// class CommentsScreen extends StatelessWidget {
//   late int likesNumber;
//   late int index;
//   bool? isPersonal;
//   late String postId;
//   CommentsScreen(
//       {required this.likesNumber,
//         this.isPersonal,
//         required this.postId,
//         required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController comment = TextEditingController();
//     return BlocConsumer<SocialAppCubit, SocialAppStates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         var bloc = SocialAppCubit.get(context);
//         return Scaffold(
//           appBar: AppBar(
//             titleSpacing: 0,
//             leadingWidth: 100,
//             leading: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Icon(
//                     Icons.favorite_border,
//                     color: Colors.pink,
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Flexible(
//                     child: Text(
//                       "$likesNumber",
//                       style:
//                       TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Row(
//                   children: [
//                     if (isPersonal == false &&
//                         (SocialAppCubit.get(context)
//                             .postsList[index]
//                             .likes[SocialAppCubit.get(context).userModel!.uId] !=
//                             true ||
//                             SocialAppCubit.get(context)
//                                 .postsList[index]
//                                 .likes[SocialAppCubit.get(context).userModel!.uId] ==
//                                 null))
//                       Icon(
//                         Icons.favorite_border,
//                         color: Colors.grey,
//                       ),
//                     if (isPersonal == false &&
//                         SocialAppCubit.get(context)
//                             .postsList[index]
//                             .likes[SocialAppCubit.get(context).userModel!.uId] ==
//                             true)
//                       Icon(
//                         Icons.favorite,
//                         color: Colors.pink,
//                       ),
//                     if (isPersonal! &&
//                         (SocialAppCubit.get(context)
//                             .postsPersonal[index]
//                             .likes[SocialAppCubit.get(context).userModel!.uId] !=
//                             true ||
//                             SocialAppCubit.get(context)
//                                 .postsPersonal[index]
//                                 .likes[SocialAppCubit.get(context).userModel!.uId] ==
//                                 null))
//                       Icon(
//                         Icons.favorite_border,
//                         color: Colors.grey,
//                       ),
//                     if (isPersonal! &&
//                         SocialAppCubit.get(context)
//                             .postsPersonal[index]
//                             .likes[SocialAppCubit.get(context).userModel!.uId] ==
//                             true)
//                       Icon(
//                         Icons.favorite,
//                         color: Colors.pink,
//                       ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           body: ConditionalBuilder(
//             condition: state is! SocialGetCommentsLoadingState,
//             fallback: (context) => Center(child: CircularProgressIndicator()),
//             builder: (context) => Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: BouncingScrollPhysics(),
//                     child: ListView.separated(
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemBuilder: (context, index) =>
//                             commentItem(context, bloc.comments[index], index),
//                         separatorBuilder: (context, index) => SizedBox(
//                           height: 10,
//                         ),
//                         itemCount: bloc.comments.length),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 7.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           margin: EdgeInsetsDirectional.only(
//                               top: 7, end: 5, bottom: 5),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     spreadRadius: 3,
//                                     blurRadius: 6,
//                                     offset: Offset(0, 0))
//                               ]),
//                           child: TextFormField(
//                             controller: comment,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .subtitle2!
//                                 .copyWith(color: Colors.black),
//                             keyboardType: TextInputType.text,
//                             decoration: InputDecoration(
//                                 hintText: "type here...",
//                                 hintStyle: TextStyle(color: Colors.grey),
//
//                                 // border: OutlineInputBorder(),
//                                 focusColor: social1,
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.transparent, width: 3),
//                                     borderRadius: BorderRadius.circular(30)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.transparent, width: 3),
//                                     borderRadius: BorderRadius.circular(30))),
//                             cursorColor: social1,
//                           ),
//                         ),
//                       ),
//                       CircleAvatar(
//                         radius: 27,
//                         backgroundColor: social2,
//                         child: IconButton(
//                             onPressed: () {
//                               var date = DateTime.now();
//                               try {
//                                 bloc.commentPost(
//                                     postId, date, comment.text);
//                               } catch (error) {}
//                             },
//                             icon: Icon(
//                               Icons.send_outlined,
//                               color: Colors.white,
//                               size: 32,
//                             )),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget commentItem(context, String Comment, int index) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             backgroundImage:
//             NetworkImage(SocialAppCubit.get(context).CommentsUserImages[index]),
//             radius: 29,
//           ),
//           Flexible(
//             child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1.5),
//                 padding:
//                 EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 5),
//                 decoration: BoxDecoration(
//                     color: social5,
//                     borderRadius: BorderRadiusDirectional.only(
//                       topEnd: Radius.circular(20),
//                       bottomEnd: Radius.circular(20),
//                       bottomStart: Radius.circular(20),
//                     )),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       SocialAppCubit.get(context).CommentsUserName[index],
//                       style:
//                       TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       Comment,
//                       style:
//                       TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     )
//                   ],
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
