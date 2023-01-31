import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:battle_words/src/features/multiplayer/data/helpers.dart';
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

    // Listens to the webSocketManager's state stream but only adds a new state to the bloc if it is a MatchmakingServerState
    webSocketManager.stream.listen(
      (data) {
        final jsonData = fixGoJson(data);
        try {
          final data = jsonDecode(jsonData);

          // ensure the current phase is matchmaking
          if (data['phase'] != 'matchmaking') {
            throw Exception('Not matchmaking response');
          }

          // remove 'phase' field from data
          Map<String, dynamic> filteredData = filterOutPhase(data);

          final MatchmakingServerState status = MatchmakingServerState.fromJson(filteredData);
          streamController.sink.add(status);
        } catch (err) {
          // print(err.toString());
          // Do nothing, the data received is not a MatchmakingServerState
        }
      },
      onError: (err) {
        final MatchmakingServerState status =
            MatchmakingServerState(status: MatchmakingServerStatus.connectionError);
        log(err.toString());
        streamController.sink.addError(status);
      },
    );

    //! Temporary write to server to test communication
    // final response =
    //     jsonEncode(MatchmakingServerState(status: MatchmakingServerStatus.testStart).toJson());
    // webSocketManager.write(response);
  }

  reconnect() async {
    await webSocketManager.connect();
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
