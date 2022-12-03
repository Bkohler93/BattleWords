part of 'interface.dart';

class SinglePlayerIsolateRepository implements ISinglePlayerRepository {
  SinglePlayerIsolateRepository() {
    // _spawnIsolate();
  }
  // final ByteData objectBoxStoreReference;
  final ReceivePort fromGameManagerPort = ReceivePort();
  late final SendPort toGameManagerPort;
  Isolate? _isolate;
  final _gameStateStream = StreamController<SinglePlayerState>();

  @override
  Stream<SinglePlayerState> get gameStateStream => _gameStateStream.stream;

  @override
  void init() async {
    await _spawnIsolate();
  }

  FutureOr<void> _spawnIsolate() async {
    final gameManagerData = {
      'gameManagerToRepositoryPort': fromGameManagerPort.sendPort,
      // 'objectBoxReference': objectBoxStoreReference,
    };

    _isolate = await Isolate.spawn(runSinglePlayerGameManager, gameManagerData);

    fromGameManagerPort.listen(
      (message) {
        if (message is SendPort) {
          print("(main isolate): repository received toGameManagerPort");
          toGameManagerPort = message;
        } else {
          _gameStateStream.sink.add(message);
        }
      },
    );
  }

  @override
  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  @override
  void getSinglePlayerGame() {
    final requestObject = GetSinglePlayerGame();
    toGameManagerPort.send(requestObject);
  }

  @override
  bool setSinglePlayerGame(SinglePlayerState singlePlayerGame) {
    try {
      final requestObject = SetSinglePlayerGame(state: singlePlayerGame);
      toGameManagerPort.send(requestObject);
      return true;
    } catch (err) {
      print("=== (isolate repository) setSinglePlayerGame error $err");
      return false;
    }
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
