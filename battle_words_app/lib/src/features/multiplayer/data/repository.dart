import 'dart:convert';

import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MatchmakingRepository {
  late final WebSocketChannel channel;

  Stream<MatchmakingServerStatus> connectAndListen() async* {
    final wsUrl = Uri.parse('ws://${dotenv.env['LOCALIP']}:8080/ws');
    channel = WebSocketChannel.connect(wsUrl);

    await for (dynamic data in channel.stream) {
      final status = MatchmakingServerStatus.fromJson(jsonDecode(data));

      yield status;
    }
  }
}
