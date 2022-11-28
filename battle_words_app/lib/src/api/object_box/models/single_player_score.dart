import 'package:objectbox/objectbox.dart';

@Entity()
class SinglePlayerScore {
  @Id()
  int id;

  int currentWinStreak;
  int highestScoreStreak;
  int totalGamesWon;

  SinglePlayerScore({
    this.id = 0,
    required this.currentWinStreak,
    required this.highestScoreStreak,
    required this.totalGamesWon,
  });

  @override
  toString() =>
      'SinglePlayerScore{id: $id, currentWinStreak: $currentWinStreak, totalGamesWon: $totalGamesWon, highestScoreStreak: $highestScoreStreak}';
}
