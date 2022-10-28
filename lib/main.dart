import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/authentication/authentication_bloc.dart';
import 'package:task_project/bloc/login/login_bloc.dart';
import 'package:task_project/bloc/login/login_screen.dart';
import 'package:task_project/bloc/theme/theme_bloc.dart';
import 'package:task_project/router.dart';
import 'package:task_project/settings/color_resource.dart';
import 'package:task_project/settings/preferences.dart';
import 'bloc/theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Preferences.init();
  runApp(BlocProvider<AuthenticationBloc>(
    create: (BuildContext context) {
      return AuthenticationBloc()..add(AppStarted(context: context));
    },
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorResource.color2E3B5F,
    ));
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeState) {
          return MaterialApp(
            title: 'Task_QR',
            debugShowCheckedModeBanner: false,
             onGenerateRoute: getRoute,
            home: BlocProvider(
              create: (context) => AlbumsBloc(),
              child:const AlbumsScreen(),
            ),
          );
        },
      ),
    );
  }
}



