import 'package:bloc/bloc.dart';

class PauseMenuCubit extends Cubit<bool> {
  PauseMenuCubit() : super(false);

  void showOrHidePauseMenu() {
    emit(!state);
  }
}
