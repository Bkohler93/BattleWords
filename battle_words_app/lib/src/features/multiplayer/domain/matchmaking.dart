import 'package:json_annotation/json_annotation.dart';

part 'matchmaking.g.dart';

//* Change this to ServerResponse object
@JsonEnum()
enum MultiplayerPhase {
  @JsonValue('matchmaking')
  matchmaking,
  @JsonValue('setup')
  setup,
  @JsonValue('inGame')
  inGame,
}

extension MultiplayerPhaseX on MultiplayerPhase {
  bool get isMatchmaking => this == MultiplayerPhase.matchmaking;
  bool get isSetup => this == MultiplayerPhase.setup;
  bool get isInGame => this == MultiplayerPhase.inGame;
}

// @JsonSerializable()
// class ServerResponse {
//   ServerResponse({required this.phase, required this.state, required this.data});
//   final Phase phase;
//   final ServerResponseState state;
//   //! This can be MatchmakingServerState / SetupServerState / InGameServerState
//   final Map<String, dynamic> data;
// }

// @JsonSerializable()
// class ServerResponseState {
//   ServerResponseState(this.phase);
//   final MultiplayerPhase phase;

//   /// Connect the generated [_$PersonFromJson] function to the `fromJson`
//   /// factory.
//   factory ServerResponseState.fromJson(Map<String, dynamic> json) =>
//       _$ServerResponseStateFromJson(json);

//   /// Connect the generated [_$PersonToJson] function to the `toJson` method.
//   Map<String, dynamic> toJson() => _$ServerResponseStateToJson(this);
// }

@JsonSerializable()
class ServerMatchmakingState {
  ServerMatchmakingState({required this.status, required this.phase, required this.data});

  final MultiplayerPhase phase;
  final ServerMatchmakingStatus status;
  final Map<String, dynamic>? data;

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory ServerMatchmakingState.fromJson(Map<String, dynamic> json) =>
      _$ServerMatchmakingStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$ServerMatchmakingStateToJson(this);
}

// @JsonSerializable()
// class MatchmakingServerState {
//   MatchmakingServerState({required this.status});

//   final ServerMatchmakingStatus status;

//   /// Connect the generated [_$PersonFromJson] function to the `fromJson`
//   /// factory.
//   factory MatchmakingServerState.fromJson(Map<String, dynamic> json) =>
//       _$MatchmakingServerStateFromJson(json);

//   /// Connect the generated [_$PersonToJson] function to the `toJson` method.
//   Map<String, dynamic> toJson() => _$MatchmakingServerStateToJson(this);
// }

@JsonEnum()
enum ServerMatchmakingStatus {
  @JsonValue('connectionError')
  connectionError,
  @JsonValue('findingGame')
  findingGame,
  @JsonValue('gameFound')
  gameFound,
  @JsonValue('ready')
  ready,
  @JsonValue('awaitingOpponentReady')
  awaitingOpponentReady,
  @JsonValue('opponentDeclined')
  opponentDeclined,
  @JsonValue('endMatchmaking')
  endMatchmaking,
}

extension MatchmakingStatusX on ServerMatchmakingStatus {
  bool get isConnectionError => this == ServerMatchmakingStatus.connectionError;
  bool get isFindingGame => this == ServerMatchmakingStatus.findingGame;
  bool get isGameFound => this == ServerMatchmakingStatus.gameFound;
  bool get isReady => this == ServerMatchmakingStatus.ready;
  bool get isAwaitingOpponentReady => this == ServerMatchmakingStatus.awaitingOpponentReady;
  bool get isOpponentDeclined => this == ServerMatchmakingStatus.opponentDeclined;
  bool get isEndMatchmaking => this == ServerMatchmakingStatus.endMatchmaking;
}
