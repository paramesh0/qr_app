
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/base/base.dart';
import 'package:task_project/bloc/plugin_screen/plugin_event.dart';

class PluginBloc extends Bloc<PluginEvent, BaseState> {
  PluginBloc() : super(LoadingState());

  @override
  Stream<BaseState> mapEventToState(PluginEvent event) async* {
    if (event is PluginIntialEvent) {
      yield LoadingState();

      yield SuccessState(successResponse: 'success');
    }
  }
}
