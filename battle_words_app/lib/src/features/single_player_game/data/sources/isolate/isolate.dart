import 'dart:io';
import 'dart:isolate';

import 'package:battle_words/main.dart';
import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/game_manager.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

void printIsolate(String message) {
  print('(manager isolate): $message');
}

void runSinglePlayerGameManager(Map<String, dynamic> data) async {
  try {
    if (Platform.isAndroid) PathProviderAndroid.registerWith();
    if (Platform.isIOS) PathProviderIOS.registerWith();
    //extract port and ObjectBox store reference from main isolate
    final toRepositoryPort = data['gameManagerToRepositoryPort'];
    // final objectBoxReference = data['objectBoxReference'];

    final ReceivePort fromRepositoryPort = ReceivePort();

    //create repository for GameManager to retrieve words from
    final IHiddenWordsRepository hiddenWordsRepository = HiddenWordsRepository();

    await hiddenWordsRepository.init();

    GameManager(
      toRepositoryPort: toRepositoryPort,
      hiddenWordsRepository: hiddenWordsRepository,
      fromRepositoryPort: fromRepositoryPort,
    );
  } catch (err) {
    printIsolate(err.toString());
  }
}
