import 'package:battle_words/api/object_box/object_box.dart';
import 'package:battle_words/features/home_screen/data/database_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageController extends StateNotifier<AsyncValue<void>> {
  HomePageController({required this.repository}) : super(const AsyncLoading()) {
    _fillDatabase();
    //consider making _loadAssets if more things need to be loaded here
  }
  final ObjectBoxRepository repository;

  ///copyDatabaseFileFromAssets: https://stackoverflow.com/questions/68453004/how-setup-dart-objectbox-with-a-local-database-pre-populated
  ///
  ///This function checks if the database has already been written to application memory.
  ///If it hasn't then it loads the database files from the assets directory and writes them
  Future<void> _fillDatabase() async {
    state = const AsyncLoading();
    await repository.populateDatabase();
    state = const AsyncData(null);
  }
}

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, AsyncValue<void>>((ref) {
  return HomePageController(repository: ref.watch(objectBoxRepositoryProvider));
});
