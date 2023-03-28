import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:battle_words/src/features/auth/auth.dart';
import 'package:battle_words/src/api/web_socket_channel/web_socket_manager.dart';
import 'package:battle_words/src/features/multiplayer/domain/setup.dart';

class SetupRepository {
  SetupRepository({required this.webSocketManager});
  final WebSocketManager webSocketManager;
  StreamController<ServerSetupState> streamController = StreamController();

  Stream<ServerSetupState> get stateStream => streamController.stream;
  void stopListening() {
    //TODO
  }

  /// connects websocket to server, listens for changes and converts incoming data from web socket into SetupServerStatus. Sends status through webSocketManagerController's stream.
  connect() async {
    if (!webSocketManager.isConnected) {
      await webSocketManager.connect();
    }

    // Listens to the webSocketManager's state stream but only adds a new state to the bloc if it is a SetupServerState
    webSocketManager.stream.listen(
      (serverResponse) {
        try {
          final data = jsonDecode(serverResponse);
          ServerSetupState state = ServerSetupState.fromJson(data);
          streamController.sink.add(state);
        } catch (err) {
          // Do nothing, the data received is not a MatchmakingServerState
        }
      },
      onError: (err) {
        final ServerSetupState status = ServerSetupState(
          setupStep: SetupStep.error,
        );
        streamController.sink.addError(status);
      },
    );
  }

  reconnect() async {
    await webSocketManager.connect();
  }

  Future<void> sayHelloToServer() async {
    final response = jsonEncode(ClientSetupState(setupStep: SetupStep.hi, clientId: auth).toJson());
    webSocketManager.write(response);
  }
}
