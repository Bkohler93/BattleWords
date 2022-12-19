import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  late final SharedPreferences sharedPreferences;

  Future<void> resetSettings() async {
    sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setBool('isFirstLaunch', true);

    emit(state.copyWith(isFirstLaunch: true, status: SettingsStatus.loaded));
  }

  Future<void> loadSettings() async {
    sharedPreferences = await SharedPreferences.getInstance();

    bool? isFirstLaunch = sharedPreferences.getBool('isFirstLaunch');

    if (isFirstLaunch == null) {
      await sharedPreferences.setBool('isFirstLaunch', true);
      isFirstLaunch = true;
    }

    emit(state.copyWith(isFirstLaunch: isFirstLaunch, status: SettingsStatus.loaded));
  }

  Future<void> updateSettings({bool? isFirstLaunch}) async {
    //TODO update shared preferences for each parameter given
    if (isFirstLaunch != null) {
      await sharedPreferences.setBool('isFirstLaunch', isFirstLaunch);
    }

    //TODO emit new state with updated settings
    emit(
      state.copyWith(isFirstLaunch: isFirstLaunch ?? state.isFirstLaunch),
    );
  }
}
