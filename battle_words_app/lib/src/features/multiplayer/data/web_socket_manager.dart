import 'dart:convert';
import 'dart:io';

import 'package:battle_words/src/features/auth/auth.dart';
import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Allows read and write operations on a websocket connection
///
/// Uses BehaviorSubject to create a stream that can be listened to multiple times.
///
/// For testing, include an optional parameter in constructor for a mock channel to send/receive data
class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();

  late WebSocketChannel _channel;
  final _behaviorSubject = BehaviorSubject<String>();

  factory WebSocketManager() => _instance;

  WebSocketManager._internal({WebSocketChannel? channel}) {
    if (channel != null) {
      _channel = channel;
    }
  }

  //writes to web socket
  void write(dynamic message) {
    _channel.sink.add(message);
  }

  Stream<dynamic> get stream => _behaviorSubject.stream;

  Future<void> connect() async {
    final wsUrl = Uri.parse('ws://${dotenv.env['LOCALIP']}:8080/ws');

    try {
      WebSocket ws = await WebSocket.connect(wsUrl.toString()).timeout(
        const Duration(seconds: 5),
      );

      _channel = IOWebSocketChannel(ws);

      final authData = jsonEncode(ClientMatchmakingState(
        matchmakingStep: MatchmakingStep.authenticate,
        clientId: auth,
      ));

      // send request body with uid (found in Auth class when implemented)
      _channel.sink.add(authData);

      //feed stream into BehaviorSubject, account for error
      _channel.stream.listen(
        (event) {
          _behaviorSubject.sink.add(event);
        },
        onError: (err) {
          _behaviorSubject.addError(err);
        },
      );
    } catch (err) {
      _behaviorSubject.addError(err);
    }
  }
}
