import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/bloc/theme/theme_events.dart';
import 'package:task_project/bloc/theme/theme_state.dart';
import 'package:task_project/settings/app_themes.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super( ThemeState(
    themeData: AppThemes.appThemeData[AppTheme.darkTheme],
  ),);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeEvent) {
      yield ThemeState(
        themeData: AppThemes.appThemeData[event.appTheme],

      );
    }
  }
}
