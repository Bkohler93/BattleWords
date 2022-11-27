part of 'interface.dart';

class SinglePlayerIsolateRepository implements ISinglePlayerRepository {
  SinglePlayerIsolateRepository({required this.fromGameManagerPort}) {
    _receivePort();
  }
  final ReceivePort fromGameManagerPort;
  late final SendPort toGameManagerPort;
  final _gameStateStream = StreamController<SinglePlayerState>();

  @override
  Stream<SinglePlayerState> get gameStateStream => _gameStateStream.stream;

  void _receivePort() {
    fromGameManagerPort.listen(
      (message) {
        if (message == "send us the store") {
        } else if (message is SendPort) {
          toGameManagerPort = message;
        } else {
          _gameStateStream.sink.add(message);
        }
      },
    );
  }

  @override
  FutureOr<SinglePlayerState> getSinglePlayerGame() {
    final requestObject = GetSinglePlayerGame();
    // print("(main isolate): requesting new game");
    toGameManagerPort.send(requestObject);
    return SinglePlayerState.generate();
  }

  FutureOr<void> sendObjectBoxStore(ObjectBoxStore objectBoxStore) {
    final requestObject = SendObjectBoxStore(store: objectBoxStore);
    toGameManagerPort.send(requestObject);
  }

  @override
  FutureOr<bool> setSinglePlayerGame(SinglePlayerState singlePlayerGame) {
    final requestObject = SetSinglePlayerGame(state: singlePlayerGame);
    toGameManagerPort.send(requestObject);
    return true;
  }

  @override
  FutureOr<void> updateGameByTileTap({required int col, required int row}) {
    final requestObject = UpdateGameByTileTap(col: col, row: row);
    toGameManagerPort.send(requestObject);
  }

  @override
  FutureOr<void> updateGameByGuessingWord({required String word}) {
    final requestObject = UpdateGameByGuessingWord(word: word);
    toGameManagerPort.send(requestObject);
  }
}
