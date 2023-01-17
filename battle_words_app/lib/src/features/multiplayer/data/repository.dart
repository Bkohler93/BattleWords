import 'dart:async';
import 'dart:convert';

import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MatchmakingRepository {
  late final WebSocketChannel channel;
  final StreamController<MatchmakingServerStatus> _onNewState = StreamController();
  late StreamSubscription<dynamic> subscription;

  Stream<MatchmakingServerStatus> get onNewState => _onNewState.stream.asBroadcastStream();

  void connectAndListen() async {
    final wsUrl = Uri.parse('ws://${dotenv.env['LOCALIP']}:8080/ws');
    channel = WebSocketChannel.connect(wsUrl);

    subscription = channel.stream.listen(
      (event) => _onNewState.sink.add(
        MatchmakingServerStatus.fromJson(
          jsonDecode(event),
        ),
      ),
    );
  }

  void stopListening() {
    subscription.cancel();
  }

  void resumeListening() {
    subscription = channel.stream.listen(
      (event) => _onNewState.sink.add(
        MatchmakingServerStatus.fromJson(
          jsonDecode(event),
        ),
      ),
    );
  }
}
