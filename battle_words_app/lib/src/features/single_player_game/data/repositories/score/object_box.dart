part of 'interface.dart';

class SinglePlayerScoreObjectBoxRepository extends ISinglePlayerScoreRepository {
  SinglePlayerScoreObjectBoxRepository({required ByteData storeReference}) {
    store = ObjectBoxStore(storeReference: storeReference);
  }
  late final ObjectBoxStore store;

  @override
  SinglePlayerScoreState getScoreState() {
    final scoreData = store.getScoreData();
    return SinglePlayerScoreState.from(scoreData);
  }

  @override
  void setScoreState(SinglePlayerScoreState state) {
    store.removeExistingScoreData();

    final SinglePlayerScore objectBoxScoreData = SinglePlayerScore(
      currentWinStreak: state.currentWinStreak,
      highestScoreStreak: state.highestWinStreak,
      totalGamesWon: state.totalGamesWon,
    );
    store.updateScoreData(objectBoxScoreData);
  }

  @override
  SinglePlayerScoreState updateScoreFromGameEnd({required GameStatus status}) {
    final currentScoreData = store.getScoreData();
    late final SinglePlayerScore newScoreData;

    if (status.isWin) {
      final currentWinStreak = currentScoreData.currentWinStreak + 1;
      final totalGamesWon = currentScoreData.totalGamesWon + 1;
      final highestWinStreak = currentScoreData.highestScoreStreak > currentWinStreak
          ? currentScoreData.highestScoreStreak
          : currentWinStreak;

      newScoreData = SinglePlayerScore(
        currentWinStreak: currentWinStreak,
        highestScoreStreak: highestWinStreak,
        totalGamesWon: totalGamesWon,
      );
    } else if (status.isLoss) {
      final currentWinStreak = 0;
      final totalGamesWon = currentScoreData.totalGamesWon;
      final highestScoreStreak = currentScoreData.highestScoreStreak;

      newScoreData = SinglePlayerScore(
        currentWinStreak: currentWinStreak,
        highestScoreStreak: highestScoreStreak,
        totalGamesWon: totalGamesWon,
      );
    } else {
      throw Exception("(SinglePlayerScoreObjectRepository): Result of game is not win or loss");
    }

    store.removeExistingScoreData();
    store.updateScoreData(newScoreData);

    return SinglePlayerScoreState.from(newScoreData);
  }
}
