
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/api/services.dart';
import 'package:task_project/base/base.dart';
import 'package:task_project/bloc/plugin_screen/plugin_event.dart';
import 'package:task_project/model/albums_list.dart';

class PluginBloc extends Bloc<PluginEvent, BaseState> {
  PluginBloc() : super(LoadingState());

  String? date;
  String? time;

  @override
  Stream<BaseState> mapEventToState(PluginEvent event) async* {
    if (event is PluginIntialEvent) {
      yield LoadingState();
      date=event.arguments['Date'];
      time=event.arguments['Time'];
      final dynamic returnableValues = await APIRepository().getPublicIP(event.arguments);
      final values = IPValues.fromJson(jsonDecode(returnableValues));
      yield SuccessState(successResponse: values);
    }

  }
}
