import 'dart:io';

import 'package:battle_words/src/features/multiplayer/data/web_socket_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketChannelMock extends Mock implements IOWebSocketChannel {}

void main() async {
  await dotenv.load(fileName: ".env");

  group('WebSocketManager tests', () {
    ///run tests for server offline
    test('stream returns an error if websocket cannot connect to server', () async {
      final manager = WebSocketManager();

      await manager.connect();

      expect(manager.stream.first, throwsException);
    });
  });
}
