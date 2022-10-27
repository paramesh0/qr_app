import 'package:flutter/material.dart';
import 'package:task_project/utils/base_equtable.dart';

abstract class AlbumNewEvent extends BaseEquatable {}

class AlbumIntialEvent extends AlbumNewEvent {
  BuildContext? context;
  dynamic arguments;

  AlbumIntialEvent({this.context, this.arguments});
}
