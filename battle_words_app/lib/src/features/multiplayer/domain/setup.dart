import 'package:json_annotation/json_annotation.dart';

part 'setup.g.dart';

/// state that matchmaking is currently in. This is received from the server
@JsonSerializable()
class ServerSetupState {
  ServerSetupState({required this.setupStep, this.clientId});

  @JsonKey(name: 'SetupStep')
  final SetupStep setupStep;
  @JsonKey(name: 'ClientId')
  final String? clientId;

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory ServerSetupState.fromJson(Map<String, dynamic> json) => _$ServerSetupStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$ServerSetupStateToJson(this);
}

@JsonEnum()
enum SetupStep {
  @JsonValue('Initial')
  initial,
  @JsonValue('Error')
  error,
  @JsonValue('ConnectionError')
  connectionError,
  @JsonValue('EndSetup')
  endSetup,
  @JsonValue('ServerSaysHi')
  serverSaysHi,
  @JsonValue('ClientSaysHi')
  hi,
}

extension SetupStatusX on SetupStep {
  bool get isAuthenticate => this == SetupStep.initial;
  bool get isError => this == SetupStep.error;
  bool get isConnectionError => this == SetupStep.connectionError;
  bool get isEndSetup => this == SetupStep.endSetup;
  bool get isServerSaysHi => this == SetupStep.serverSaysHi;
}

/// state that matchmaking is currently in. This is sent to the server.
@JsonSerializable()
class ClientSetupState {
  ClientSetupState({required this.setupStep, required this.clientId});

  @JsonKey(name: 'MatchmakingStep')
  final SetupStep setupStep;
  @JsonKey(name: 'ClientId')
  final String clientId;
  // final Map<String, dynamic>? data;

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory ClientSetupState.fromJson(Map<String, dynamic> json) => _$ClientSetupStateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$ClientSetupStateToJson(this);
}
