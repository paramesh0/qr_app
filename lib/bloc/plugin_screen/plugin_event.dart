import 'package:flutter/material.dart';
import 'package:task_project/utils/base_equtable.dart';

abstract class PluginEvent extends BaseEquatable {}

class PluginIntialEvent extends PluginEvent {
  BuildContext? context;
  dynamic arguments;

  PluginIntialEvent({this.context, this.arguments});
}
