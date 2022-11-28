part of 'score_cubit.dart';

class SinglePlayerScoreState extends Equatable {
  const SinglePlayerScoreState({
    this.totalGamesWon = 0,
    this.highestWinStreak = 0,
    this.currentWinStreak = 0,
  });
  final int totalGamesWon;
  final int highestWinStreak;
  final int currentWinStreak;

  SinglePlayerScoreState copyWith(
      {int? totalGamesWon, int? highestWinStreak, int? currentWinStreak}) {
    return SinglePlayerScoreState(
      currentWinStreak: currentWinStreak ?? this.currentWinStreak,
      highestWinStreak: highestWinStreak ?? this.highestWinStreak,
      totalGamesWon: totalGamesWon ?? this.totalGamesWon,
    );
  }

  static SinglePlayerScoreState from(SinglePlayerScore objectBoxStoreData) {
    return SinglePlayerScoreState(
      totalGamesWon: objectBoxStoreData.totalGamesWon,
      highestWinStreak: objectBoxStoreData.highestScoreStreak,
      currentWinStreak: objectBoxStoreData.currentWinStreak,
    );
  }

  @override
  List<Object> get props => [
        totalGamesWon,
        highestWinStreak,
        currentWinStreak,
      ];
}
