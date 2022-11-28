part of 'package:battle_words/src/api/object_box/object_box.dart';

extension SinglePlayerScoreAccessor on ObjectBoxStore {
  void removeExistingScoreData() {
    singlePlayerScoreBox.removeAll();
  }

  void updateScoreData(SinglePlayerScore newScoreData) {
    singlePlayerScoreBox.put(newScoreData);
  }

  SinglePlayerScore getScoreData() {
    final rawScoreData = singlePlayerScoreBox.getAll()[0];

    return SinglePlayerScore(
      currentWinStreak: rawScoreData.currentWinStreak,
      highestScoreStreak: rawScoreData.highestScoreStreak,
      totalGamesWon: rawScoreData.totalGamesWon,
    );
  }
}
