import 'package:json_annotation/json_annotation.dart';

part 'matchmaking.g.dart';

/// state that matchmaking is currently in. This is received from the server
@JsonSerializable()
class ServerMatchmakingState {
  ServerMatchmakingState({required this.matchmakingStep, this.clientId});

  @JsonKey(name: 'MatchmakingStep')
  final MatchmakingStep matchmakingStep;
  @JsonKey(name: 'ClientId')
  final String? clientId;

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory ServerMatchmakingState.fromJson(Map<String, dynamic> json) =>
      _$ServerMatchmakingStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$ServerMatchmakingStateToJson(this);
}

@JsonEnum()
enum MatchmakingStep {
  @JsonValue('Authenticate')
  authenticate,
  @JsonValue('ConnectionError')
  connectionError,
  @JsonValue('FindingGame')
  findingGame,
  @JsonValue('GameFound')
  gameFound,
  @JsonValue('Ready')
  ready,
  @JsonValue('AwaitingOpponentReady')
  awaitingOpponentReady,
  @JsonValue('OpponentDeclined')
  opponentDeclined,
  @JsonValue('EndMatchmaking')
  endMatchmaking,
}

extension MatchmakingStatusX on MatchmakingStep {
  bool get isAuthenticate => this == MatchmakingStep.authenticate;
  bool get isConnectionError => this == MatchmakingStep.connectionError;
  bool get isFindingGame => this == MatchmakingStep.findingGame;
  bool get isGameFound => this == MatchmakingStep.gameFound;
  bool get isReady => this == MatchmakingStep.ready;
  bool get isAwaitingOpponentReady => this == MatchmakingStep.awaitingOpponentReady;
  bool get isOpponentDeclined => this == MatchmakingStep.opponentDeclined;
  bool get isEndMatchmaking => this == MatchmakingStep.endMatchmaking;
}

/// state that matchmaking is currently in. This is sent to the server.
@JsonSerializable()
class ClientMatchmakingState {
  ClientMatchmakingState({required this.matchmakingStep, required this.clientId});

  @JsonKey(name: 'MatchmakingStep')
  final MatchmakingStep matchmakingStep;
  @JsonKey(name: 'ClientId')
  final String clientId;
  // final Map<String, dynamic>? data;

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory ClientMatchmakingState.fromJson(Map<String, dynamic> json) =>
      _$ClientMatchmakingStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$ClientMatchmakingStateToJson(this);
}
