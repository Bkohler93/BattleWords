import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  late final SharedPreferences sharedPreferences;

  Future<void> loadSettings() async {
    //TODO 1) load shared preferences instance, save into sharedPreferences

    //TODO 2) retrieve settings from shared preferences and store then into cubit state

    //TODO 3) emit state with loaded
  }

  Future<void> updateSettings({bool? isFirstLaunch}) async {
    //TODO update shared preferences for each parameter given

    //TODO emit new state with updated settings
  }
}
