part of 'interface.dart';

/// Used by SinglePlayerGame Bloc to receive updated game states
class SinglePlayerObjectBoxRepository implements ISinglePlayerRepository {
  SinglePlayerObjectBoxRepository({required ObjectBoxStore store, ByteData? storeReference})
      : _store = store,
        _storeReference = storeReference;

  final ObjectBoxStore _store;
  final ByteData? _storeReference;
  late final SendPort toGameManagerPort;
  late final Isolate isolate;

  @override
  void dispose() {
    final request = GameOver();
    toGameManagerPort.send(request);
    isolate.kill();
  }

  @override

  /// Listens for new game state changes in objectbox store Box<SinglePlayerGameModel>
  Stream<SinglePlayerState> get gameStateStream => _store
      .listenForNewGameStates()
      .map((event) => SinglePlayerState.fromJson(jsonDecode(event.jsonStringState!)));

  @override
  //starts up isolate to handle all game events from UI and update state in db accordingly
  Future<void> init() async {
    final ReceivePort fromGameManagerPort = ReceivePort();

    final gameManagerData = {
      'gameManagerToRepositoryPort': fromGameManagerPort.sendPort,
      'objectBoxReference': _storeReference
    };

    isolate = await Isolate.spawn(runSinglePlayerGameManager, gameManagerData);

    toGameManagerPort = await fromGameManagerPort.first;

    if (kDebugMode) {
      print("=== (SinglePlayerGameRepository): received response from GameManager");
    }
  }

  @override
  // TODO: implement isIsolateConnectedStream
  Stream<bool> get isIsolateConnectedStream => throw UnimplementedError();

  // @override
  // //called form isolate to update state in db
  // FutureOr<bool> setSinglePlayerGame(SinglePlayerState singlePlayerGame) {
  //   try {
  //     final jsonString = jsonEncode(singlePlayerGame.toJson());

  //     final updatedState = SinglePlayerGameModel(jsonStringState: jsonString);

  //     _store.updateSinglePlayerGame(updatedState);
  //     return true;
  //   } catch (e) {
  //     print("=== SinglePlayerWatchRepository: Failed to update state. $e");
  //     return false;
  //   }
  // }

  @override
  FutureOr<void> updateGameByGuessingWord({required String word}) {
    final request = UpdateGameByGuessingWord(word: word);
    toGameManagerPort.send(request);
  }

  @override
  FutureOr<void> updateGameByTileTap({required int col, required int row}) {
    final request = UpdateGameByTileTap(col: col, row: row);

    toGameManagerPort.send(request);
  }
}
