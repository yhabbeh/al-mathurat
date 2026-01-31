import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(Locale('ar'))) {
    on<ChangeLanguage>(_onChangeLanguage);
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) {
    emit(LanguageState(event.locale));
  }
}
