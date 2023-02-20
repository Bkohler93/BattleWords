import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:battle_words/src/features/auth/auth.dart';
import 'package:battle_words/src/features/multiplayer/data/helpers.dart';
import 'package:battle_words/src/features/multiplayer/data/web_socket_manager.dart';
import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:battle_words/src/helpers/json.dart';

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
    await webSocketManager.connect();

    // Listens to the webSocketManager's state stream but only adds a new state to the bloc if it is a MatchmakingServerState
    webSocketManager.stream.listen(
      (serverResponse) {
        try {
          final data = jsonDecode(serverResponse);

          //TODO
          ServerMatchmakingState state = ServerMatchmakingState.fromJson(data);

          streamController.sink.add(state);
        } catch (err) {
          print('Skipping, state is not a ServerMatchmakingState');
          // Do nothing, the data received is not a MatchmakingServerState
        }
      },
      onError: (err) {
        final ServerMatchmakingState status = ServerMatchmakingState(
          status: ServerMatchmakingStatus.connectionError,
          phase: MultiplayerPhase.matchmaking,
          data: null,
        );
        log(err.toString());
        print(jsonEncode(status.toJson()));
        streamController.sink.addError(status);
      },
    );
  }

  reconnect() async {
    await webSocketManager.connect();
  }

  //* Response subject to change.
  sendReady() {
    final response = jsonEncode(ServerMatchmakingState(
      status: ServerMatchmakingStatus.ready,
      phase: MultiplayerPhase.matchmaking,
      data: {'authenticate': auth},
    ).toJson());
    print(response);
    webSocketManager.write(response);
  }
}
