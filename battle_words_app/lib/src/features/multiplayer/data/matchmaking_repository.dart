import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:battle_words/src/features/auth/auth.dart';
import 'package:battle_words/src/api/web_socket_channel/web_socket_manager.dart';
import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';

class MatchmakingRepository {
  MatchmakingRepository({required this.webSocketManager});
  final WebSocketManager webSocketManager;
  StreamController<ServerMatchmakingState> streamController = StreamController();

  Stream<ServerMatchmakingState> get stateStream => streamController.stream;
  void stopListening() {
    //TODO
  }

  /// connects websocket to server, listens for changes and converts incoming data from web socket into MatchmakingServerStatus. Sends status through webSocketManagerController's stream.
  connect() async {
    if (!webSocketManager.isConnected) {
      await webSocketManager.connect();
    }

    // Listens to the webSocketManager's state stream but only adds a new state to the bloc if it is a MatchmakingServerState
    webSocketManager.stream.listen(
      (serverResponse) {
        try {
          final data = jsonDecode(serverResponse);
          ServerMatchmakingState state = ServerMatchmakingState.fromJson(data);
          streamController.sink.add(state);
        } catch (err) {
          // Do nothing, the data received is not a MatchmakingServerState
        }
      },
      onError: (err) {
        final ServerMatchmakingState status = ServerMatchmakingState(
          matchmakingStep: MatchmakingStep.connectionError,
        );
        streamController.sink.addError(status);
      },
    );
  }

  reconnect() async {
    await webSocketManager.connect();
  }

  //* Response subject to change.
  sendReady() {
    final response = jsonEncode(
        ClientMatchmakingState(matchmakingStep: MatchmakingStep.ready, clientId: auth).toJson());
    webSocketManager.write(response);
  }
}
