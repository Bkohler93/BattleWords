import 'package:json_annotation/json_annotation.dart';

part 'matchmaking.g.dart';

@JsonSerializable()
class MatchmakingServerStatus {
  MatchmakingServerStatus({required this.status});

  final MatchmakingStatus status;

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory MatchmakingServerStatus.fromJson(Map<String, dynamic> json) =>
      _$MatchmakingServerStatusFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MatchmakingServerStatusToJson(this);
}

@JsonEnum()
enum MatchmakingStatus {
  @JsonValue('gameFound')
  gameFound,
  @JsonValue('ready')
  ready,
  @JsonValue('connectionError')
  connectionError,
  @JsonValue('opponentDeclined')
  opponentDeclined,
  @JsonValue('startingGame')
  startingGame,
}

extension MatchmakingStatusX on MatchmakingStatus {
  bool get isGameFound => this == MatchmakingStatus.gameFound;
  bool get isReady => this == MatchmakingStatus.ready;
  bool get isConnectionError => this == MatchmakingStatus.connectionError;
  bool get isOpponentDeclined => this == MatchmakingStatus.opponentDeclined;
}
