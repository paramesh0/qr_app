
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/base/base.dart';
import 'package:task_project/bloc/login/login_events.dart';

class AlbumsBloc extends Bloc<AlbumNewEvent, BaseState> {
  AlbumsBloc() : super(LoadingState());

  @override
  Stream<BaseState> mapEventToState(AlbumNewEvent event) async* {
    if (event is AlbumIntialEvent) {
      yield LoadingState();

      yield SuccessState(successResponse: 'success');
    }
  }
}
