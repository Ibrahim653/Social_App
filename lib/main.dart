import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/social_app_layout.dart';
import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/modules/social_app/social_login/social_login_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'bloc_observer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var token=await FirebaseMessaging.instance.getToken();
  print("token is $token");

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
  });
  Widget widget;
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  print(uId);
  if (uId !=null) {
    widget = SocialAppLayout();
  } else {
    widget = LoginScreen();

  }
  BlocOverrides.runZoned(
        () {
      runApp(MyApp(
        startScreen: widget,
      ));
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startScreen}) : super(key: key);
  final Widget startScreen;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            SocialAppCubit()..getUserData()..getPosts(),
          ),
          // BlocProvider(
          //   create: (BuildContext context) => SocialLoginCubit(),
          // ),
          // BlocProvider(
          //   create: (BuildContext context) => RegisterCubit(),
        //  ),
        ],
        child: MaterialApp(
          theme: lightMode(),
          debugShowCheckedModeBanner: false,

          home: startScreen,
        )


    );
  }
}
