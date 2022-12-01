part of 'interface.dart';

class SinglePlayerIsolateRepository implements ISinglePlayerRepository {
  SinglePlayerIsolateRepository({required this.objectBoxStoreReference}) {
    _spawnIsolate();
  }
  final ByteData objectBoxStoreReference;
  final ReceivePort fromGameManagerPort = ReceivePort();
  late final SendPort toGameManagerPort;
  Isolate? _isolate;
  final _gameStateStream = StreamController<SinglePlayerState>();

  @override
  Stream<SinglePlayerState> get gameStateStream => _gameStateStream.stream;

  void _spawnIsolate() async {
    final gameManagerData = {
      'gameManagerToRepositoryPort': fromGameManagerPort.sendPort,
      'objectBoxReference': objectBoxStoreReference,
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

  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  @override
  FutureOr<SinglePlayerState> getSinglePlayerGame() {
    final requestObject = GetSinglePlayerGame();
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
