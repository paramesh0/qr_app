import 'package:flutter/material.dart';
import 'package:task_project/utils/base_equtable.dart';

abstract class ListEvent extends BaseEquatable {}

class ListIntialEvent extends ListEvent {
  BuildContext? context;
  dynamic arguments;

  ListIntialEvent({this.context, this.arguments});
}
