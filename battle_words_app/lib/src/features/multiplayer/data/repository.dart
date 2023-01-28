import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:battle_words/src/features/multiplayer/data/web_socket_manager.dart';
import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:battle_words/src/helpers/json.dart';

class MatchmakingRepository {
  MatchmakingRepository({required this.webSocketManager});
  final WebSocketManager webSocketManager;
  StreamController<MatchmakingServerState> streamController = StreamController();

  Stream<MatchmakingServerState> get stateStream => streamController.stream;
  void stopListening() {
    //TODO
  }

  /// connects websocket to server, listens for changes and converts incoming data from web socket into MatchmakingServerStatus. Sends status through webSocketManagerController's stream.
  connect() async {
    await webSocketManager.connect();

    webSocketManager.stream.listen(
      (data) {
        final jsonData = fixGoJson(data);
        final MatchmakingServerState status = MatchmakingServerState.fromJson(jsonDecode(jsonData));
        streamController.sink.add(status);
      },
      onError: (err) {
        final MatchmakingServerState status =
            MatchmakingServerState(status: MatchmakingServerStatus.connectionError);
        log(err);
        streamController.sink.add(status);
      },
    );

    //! Temporary write to server to test communication
    final response =
        jsonEncode(MatchmakingServerState(status: MatchmakingServerStatus.testStart).toJson());
    webSocketManager.write(response);
  }

  //* Response subject to change.
  sendReady() {
    final response = MatchmakingServerState(status: MatchmakingServerStatus.ready).toJson();
    webSocketManager.write(response);
  }

  //! WebSocketManager.disconnect needs to be implemented for this to work
  // reconnect() async {
  //   await webSocketManager.disconnect();
  // }
}
