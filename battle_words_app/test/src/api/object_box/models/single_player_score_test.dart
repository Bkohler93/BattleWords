import 'package:battle_words/src/api/object_box/models/single_player_score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const currentWinStreak = 2;
  const highestScoreStreak = 4;
  const totalGamesWon = 5;
  final singlePlayerScore = SinglePlayerScore(
      currentWinStreak: currentWinStreak,
      highestScoreStreak: highestScoreStreak,
      totalGamesWon: totalGamesWon);
  test("SinglePlayerScore initializes with correct properties", () {
    expect(
      singlePlayerScore.currentWinStreak,
      currentWinStreak,
      reason: "current win streak should equal 2",
    );

    expect(
      singlePlayerScore.highestScoreStreak,
      highestScoreStreak,
      reason: "highestScoreStreak should equal 4",
    );

    expect(
      singlePlayerScore.totalGamesWon,
      totalGamesWon,
      reason: "totalGamesWon should equal 5",
    );
  });

  test("SinglePlayerScore toString() prints each property", () {
    const matchString =
        'SinglePlayerScore{id: 0, currentWinStreak: 2, totalGamesWon: 5, highestScoreStreak: 4}';

    final actual = singlePlayerScore.toString();

    expect(actual, matchString);
  });
}
