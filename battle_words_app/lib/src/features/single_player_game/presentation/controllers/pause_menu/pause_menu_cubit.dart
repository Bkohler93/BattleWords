import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class PauseMenuCubit extends Cubit<bool> {
  PauseMenuCubit() : super(false);

  void showOrHidePauseMenu() {
    emit(!state);
  }
}
