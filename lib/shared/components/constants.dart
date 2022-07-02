import 'package:social_app/layout/social_app/social_cubit/cubit.dart';
import 'package:social_app/modules/social_app/social_login/social_login_screen.dart';
import 'package:social_app/shared/components/navigator.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

void signOut(context){
  CacheHelper.removeData(key: 'token').then((value) {
    if(value){
      MyNavigators.navigateAndFinish(context, LoginScreen());
    }
  });
}

String? uId='';