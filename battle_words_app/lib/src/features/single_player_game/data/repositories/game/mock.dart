part of 'interface.dart';

class MockSinglePlayerRepository implements ISinglePlayerRepository {
  @override
  FutureOr<SinglePlayerState> getSinglePlayerGame() async {
    return SinglePlayerState.generate();
  }

  @override
  FutureOr<bool> setSinglePlayerGame(SinglePlayerState singlePlayerGame) async {
    return true;
  }

  @override
  FutureOr<void> updateGameByTileTap({required int col, required int row}) {
    final state = SinglePlayerState.generate();

    //hardcoded changing value
    state.gameBoard[col][row] = SinglePlayerGameTile(
        coordinates: TileCoordinates(col: col, row: row), tileStatus: TileStatus.empty);
  }

  @override
  FutureOr<void> updateGameByGuessingWord({required String word}) {
    ;
  }

  @override
  // TODO: implement gameStateStream
  Stream<SinglePlayerState> get gameStateStream => throw UnimplementedError();
}
