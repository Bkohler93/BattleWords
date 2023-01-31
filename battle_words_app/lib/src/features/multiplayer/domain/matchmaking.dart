import 'package:json_annotation/json_annotation.dart';

part 'matchmaking.g.dart';

@JsonSerializable()
class MatchmakingServerState {
  MatchmakingServerState({required this.status});

  final MatchmakingServerStatus status;

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory MatchmakingServerState.fromJson(Map<String, dynamic> json) =>
      _$MatchmakingServerStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MatchmakingServerStateToJson(this);
}

@JsonEnum()
enum MatchmakingServerStatus {
  @JsonValue('gameFound')
  gameFound,
  @JsonValue('ready')
  ready,
  @JsonValue('findingGame')
  findingGame,
  @JsonValue('connectionError')
  connectionError,
  @JsonValue('opponentDeclined')
  opponentDeclined,
  @JsonValue('startingGame')
  startingGame,
  @JsonValue('testStart')
  testStart,
}

extension MatchmakingStatusX on MatchmakingServerStatus {
  bool get isFindingGame => this == MatchmakingServerStatus.findingGame;
  bool get isGameFound => this == MatchmakingServerStatus.gameFound;
  bool get isReady => this == MatchmakingServerStatus.ready;
  bool get isConnectionError => this == MatchmakingServerStatus.connectionError;
  bool get isOpponentDeclined => this == MatchmakingServerStatus.opponentDeclined;
  bool get isStartingGame => this == MatchmakingServerStatus.startingGame;
  bool get isTestStart => this == MatchmakingServerStatus.testStart;
}
