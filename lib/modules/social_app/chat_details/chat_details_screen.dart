import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/layout/social_app/social_cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/social_app/chats/chat_screen.dart';
import 'package:social_app/shared/styles/colors.dart';

import '../../../shared/styles/styles.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel? userModel;

  ChatDetailsScreen({Key? key, this.userModel}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var messageController = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialAppCubit.get(context).getMessages(receiverId: userModel!.uId);
        return BlocConsumer<SocialAppCubit, SocialAppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userModel!.profileImage),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(userModel!.name),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                  condition: SocialAppCubit.get(context).messages.isNotEmpty,
                  builder: (BuildContext context) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                controller: _controller,
                                reverse: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var message = SocialAppCubit.get(context)
                                      .messages[index];
                                  if (SocialAppCubit.get(context)
                                          .userModel!
                                          .uId ==
                                      message.senderId)
                                    return chatBubble(context, message);

                                  return chatBubbleForFriend(context, message);
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 5,
                                ),
                                itemCount:
                                    SocialAppCubit.get(context).messages.length,
                              ),
                            ),
                            Form(
                              key: formKey,
                              child: TextFormField(
                                controller: messageController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'The message can\'t be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Send Message ...',
                                  suffixIcon: Container(
                                    decoration: BoxDecoration(
                                      color: defaultColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        IconBroken.Send,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          SocialAppCubit.get(context)
                                              .sendMessage(
                                            receiverId: userModel!.uId,
                                            dateTime: DateTime.now().toString(),
                                            message: messageController.text,
                                          );
                                        }
                                        messageController.clear();
                                        _controller.animateTo(
                                          0.0,
                                          duration:
                                              const Duration(microseconds: 500),
                                          curve: Curves.fastOutSlowIn,
                                        );
                                      },
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  fallback: (BuildContext context) {
                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                SocialAppCubit.get(context).sendMessage(
                                  receiverId: userModel!.uId,
                                  dateTime: DateTime.now().toString(),
                                  message: 'Hi',
                                );
                              },
                              child: Text(
                                'Say Hello',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 5),
                          child: Form(
                            key: formKey,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: messageController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'The message can\'t be empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Send Message ...',
                                      suffixIcon: Container(
                                        decoration: BoxDecoration(
                                          color: defaultColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            IconBroken.Send,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              SocialAppCubit.get(context)
                                                  .sendMessage(
                                                receiverId: userModel!.uId,
                                                dateTime:
                                                    DateTime.now().toString(),
                                                message: messageController.text,
                                              );
                                            }
                                            messageController.clear();
                                            _controller.animateTo(
                                              0.0,
                                              duration: const Duration(
                                                  microseconds: 500),
                                              curve: Curves.fastOutSlowIn,
                                            );
                                          },
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            );
          },
        );
      },
    );
  }

  Widget chatBubble(BuildContext context, MessageModel model) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(8),
        child: Text(
          model.message,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Color(0xff006D84),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
              bottomLeft: Radius.circular(32),
            )),
      ),
    );
  }

  Widget chatBubbleForFriend(BuildContext context, MessageModel model) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(8),
        child: Text(
          model.message,
          style: TextStyle(color: Colors.black),
        ),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            )),
      ),
    );
  }
}
