import 'dart:async';
import 'dart:convert';

import 'package:battle_words/src/features/multiplayer/data/web_socket_manager.dart';
import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MatchmakingRepository {
  MatchmakingRepository({required this.webSocketManager});
  final WebSocketManager webSocketManager;
  StreamController<MatchmakingServerState> webSocketManagerController = StreamController();

  Stream<MatchmakingServerState> get stateStream => webSocketManagerController.stream;
  void stopListening() {
    //TODO
  }

  /// connects websocket to server, listens for changes and converts incoming data from web socket into MatchmakingServerStatus. Sends status through webSocketManagerController's stream.
  connect() async {
    await webSocketManager.connect();

    webSocketManager.stream.listen(
      (data) {
        //go server returns string with ' around names instead of ", which is required by Flutter's jsonDecode method.
        final jsonData = data.replaceAll("'", '"');
        final MatchmakingServerState status = MatchmakingServerState.fromJson(jsonDecode(jsonData));
        webSocketManagerController.sink.add(status);
      },
      onError: (err) {
        final MatchmakingServerState status =
            MatchmakingServerState(status: MatchmakingServerStatus.connectionError);
        print(err);
        webSocketManagerController.sink.add(status);
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
