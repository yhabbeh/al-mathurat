import 'dart:developer';

import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  static final MyBlocObserver _instance = MyBlocObserver._internal();

  factory MyBlocObserver() => _instance;

  MyBlocObserver._internal();

  final Set<String> loggedErrors = {};

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    // Green
    log('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // Cyan
    log('onEvent -- ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Yellow
    log('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // Red
    log('onError -- ${bloc.runtimeType}, $error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    // Magenta
    log('onClose -- ${bloc.runtimeType}');
  }
}
