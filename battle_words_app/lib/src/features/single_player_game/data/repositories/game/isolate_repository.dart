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
        if (message is SendPort) {
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
    print("== (single player isolate repository) requesting new game");
    toGameManagerPort.send(requestObject);
    return SinglePlayerState.generate();
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
