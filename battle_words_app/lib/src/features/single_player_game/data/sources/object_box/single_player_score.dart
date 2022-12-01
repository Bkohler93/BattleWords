part of 'package:battle_words/src/api/object_box/object_box.dart';

extension SinglePlayerScoreAccessor on ObjectBoxStore {
  void removeExistingScoreData() {
    singlePlayerScoreBox.removeAll();
  }

  void updateScoreData(SinglePlayerScore newScoreData) {
    singlePlayerScoreBox.put(newScoreData);
  }

  SinglePlayerScore getScoreData() {
    final rawScoreData = singlePlayerScoreBox.getAll();

    if (rawScoreData.isEmpty) {
      final newScoreState =
          SinglePlayerScore(currentWinStreak: 0, highestScoreStreak: 0, totalGamesWon: 0);
      singlePlayerScoreBox.put(newScoreState);
      return newScoreState;
    } else {
      return SinglePlayerScore(
        currentWinStreak: rawScoreData[0].currentWinStreak,
        highestScoreStreak: rawScoreData[0].highestScoreStreak,
        totalGamesWon: rawScoreData[0].totalGamesWon,
      );
    }
  }
}
