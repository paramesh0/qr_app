
part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends BaseEquatable {}

class AuthenticationUnInitialized extends AuthenticationState {}

class AuthenticationUnAuthenticated extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}




