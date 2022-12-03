part of 'score_cubit.dart';

enum ScoreStateStatus { loading, loaded, error }

extension ScoreStateStatusX on ScoreStateStatus {
  bool get isLoading => this == ScoreStateStatus.loading;
  bool get isLoaded => this == ScoreStateStatus.loaded;
  bool get isError => this == ScoreStateStatus.error;
}

class SinglePlayerScoreState extends Equatable {
  const SinglePlayerScoreState({
    this.totalGamesWon = 0,
    this.highestWinStreak = 0,
    this.currentWinStreak = 0,
    this.status = ScoreStateStatus.loading,
  });
  final int totalGamesWon;
  final int highestWinStreak;
  final int currentWinStreak;
  final ScoreStateStatus status;

  SinglePlayerScoreState copyWith(
      {int? totalGamesWon,
      int? highestWinStreak,
      int? currentWinStreak,
      ScoreStateStatus? status}) {
    return SinglePlayerScoreState(
      currentWinStreak: currentWinStreak ?? this.currentWinStreak,
      highestWinStreak: highestWinStreak ?? this.highestWinStreak,
      totalGamesWon: totalGamesWon ?? this.totalGamesWon,
      status: status ?? this.status,
    );
  }

  static SinglePlayerScoreState from(SinglePlayerScore objectBoxStoreData) {
    return SinglePlayerScoreState(
      totalGamesWon: objectBoxStoreData.totalGamesWon,
      highestWinStreak: objectBoxStoreData.highestScoreStreak,
      status: ScoreStateStatus.loaded,
      currentWinStreak: objectBoxStoreData.currentWinStreak,
    );
  }

  @override
  List<Object> get props => [
        totalGamesWon,
        highestWinStreak,
        currentWinStreak,
        status,
      ];
}
