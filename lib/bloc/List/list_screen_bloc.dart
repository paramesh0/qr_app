
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/base/base.dart';
import 'package:task_project/bloc/List/list_screen_event.dart';

class ListBloc extends Bloc<ListEvent, BaseState> {
  ListBloc() : super(LoadingState());

  @override
  Stream<BaseState> mapEventToState(ListEvent event) async* {
    if (event is ListIntialEvent) {
      yield LoadingState();

      yield SuccessState(successResponse: 'success');
    }
  }
}
