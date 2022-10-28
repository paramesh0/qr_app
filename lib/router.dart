import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/authentication/authentication_bloc.dart';
import 'package:task_project/bloc/List/list_screen_bloc.dart';
import 'package:task_project/bloc/List/list_screen_event.dart';
import 'package:task_project/bloc/List/list_view_screen.dart';
import 'package:task_project/bloc/login/login_bloc.dart';
import 'package:task_project/bloc/login/login_screen.dart';
import 'package:task_project/bloc/plugin_screen/plugin_bloc.dart';
import 'package:task_project/bloc/plugin_screen/plugin_view_screen.dart';
import 'package:task_project/settings/preferences.dart';
import 'bloc/plugin_screen/plugin_event.dart';

class AppRoutes {
  static const String landingScreen = 'landing_screen';
  static const String pluginScreen = 'pluginScreen';
  static const String listScreen = 'ListScreen';
}

Route<dynamic>? getRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.landingScreen:
      return _buildLandingScreen();
    case AppRoutes.pluginScreen:
      return _buildPluginScreen(settings.arguments);
    case AppRoutes.listScreen:
      return _buildListScreen();
  }
  return null;
}

Route<dynamic> _buildLandingScreen() {
  return MaterialPageRoute(
      builder: (BuildContext context) => PageBuilder.buildLandingScreen());
}

Route<dynamic> _buildPluginScreen(dynamic arguments) {
  return MaterialPageRoute(
      builder: (BuildContext context) =>
          PageBuilder.buildPluginScreen(arguments: arguments));
}

Route<dynamic> _buildListScreen() {
  return MaterialPageRoute(
      builder: (BuildContext context) => PageBuilder.buildListScreen());
}

class PageBuilder {
  static Widget buildLandingScreen() {
    return BlocProvider(
      create: (BuildContext context) => AlbumsBloc(),
      child: const AlbumsScreen(),
    );
  }

  static Widget buildPluginScreen({dynamic arguments}) {
    return BlocProvider(
      create: (BuildContext context) =>
          PluginBloc()..add(PluginIntialEvent(arguments: arguments)),
      child: const PluginScreen(),
    );
  }

  static Widget buildListScreen() {
    return BlocProvider(
      create: (BuildContext context) => ListBloc()..add(ListIntialEvent()),
      child: const ListScreen(),
    );
  }
}

Widget addAuthBloc(BuildContext context, Widget widget) {
  return BlocListener(
    bloc: BlocProvider.of<AuthenticationBloc>(context),
    listener: (BuildContext context, Object? state) async {
      if (state is AuthenticationUnAuthenticated) {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        String? isLogin;
        await Preferences.getLoginStatus().then((value) => isLogin = value);
        if (isLogin == 'LoginSuccess') {
          await Navigator.pushReplacementNamed(
              context, AppRoutes.pluginScreen);
        } else {
          await Navigator.pushReplacementNamed(context, AppRoutes.landingScreen);
        }
      }

      if (state is AuthenticationAuthenticated) {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    },
    child: BlocBuilder(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      builder: (BuildContext context, Object? state) {
        return widget;
        /*  if (state is NoInternetConnectionState) {
          return Card(
            // child: Container(
            //   height: MediaQuery.of(context).size.height / 3,
            //   width: MediaQuery.of(context).size.width / 1,
            //   decoration: const BoxDecoration(
            //     color: Colors.white,
            //   ),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Icon(
            //         Icons.no_accounts_sharp,
            //         size: 34,
            //       ),
            //       const SizedBox(
            //         height: 30,
            //       ),
            //       CustomText('No Internet Connection',
            //           style: Theme.of(context)
            //               .textTheme
            //               .headline2!
            //               .copyWith(color: ColorResource.color641653)),
            //     ],
            //   ),
            // ),
          );
        } else {

        }*/
      },
    ),
  );
}
