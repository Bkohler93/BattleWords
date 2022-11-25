import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageController extends StateNotifier<AsyncValue<void>> {
  HomePageController({required this.repository}) : super(const AsyncLoading()) {
    _fillDatabase();
  }
  final ObjectBox repository;

  Future<void> _fillDatabase() async {
    state = const AsyncLoading();
    await repository.populateDatabase();
    state = const AsyncData(null);
  }
}

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, AsyncValue<void>>((ref) {
  return HomePageController(repository: ref.watch(objectBoxProvider));
});
