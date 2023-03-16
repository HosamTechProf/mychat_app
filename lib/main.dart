import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/layout/home_layout.dart';
import 'package:mychat_app/modules/chats/chats_screen.dart';
import 'package:mychat_app/modules/login/login_screen.dart';
import 'package:mychat_app/modules/onboarding/onboarding_screen.dart';
import 'package:mychat_app/modules/register_user_data/register_user_data_screen.dart';
import 'package:mychat_app/network/remote/dio_helper.dart';
import 'package:mychat_app/shared/cubit/app_cubit/app_cubit.dart';
import 'package:mychat_app/shared/bloc_observer.dart';
import 'package:mychat_app/shared/components.dart';

import 'network/local/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? onBoarding = await CacheHelper.getData(key: "onBoarding");
  String? uId = await CacheHelper.getData(key: "uId");
  bool? docExists = await CacheHelper.getData(key: "docExists");

  Widget widget;

  if(onBoarding != null){
    if(uId != null){
      print("UID: "+uId.toString());
      if(docExists == true){
        widget = ChatsScreen();
      }else{
        widget = RegisterUserDataScreen();
      }
    }else{
      widget = LoginScreen();
    }
  }else{
    widget = OnBoardingScreen();
  }

  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {

  final Widget widget;
  const MyApp(this.widget, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state){},
        builder: (context, state){
          AppCubit cubit = AppCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: darkThemeData(context),
            theme: lightThemeData(context),
            home: widget,
          );
        },
      ),
    );
  }
}
