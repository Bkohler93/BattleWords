part of 'package:battle_words/src/api/object_box/object_box.dart';

extension SinglePlayerGameAccessor on ObjectBoxStore {
  void removeExistingState() {
    singlePlayerGameBox.removeAll();
  }

  void updateSinglePlayerGame(SinglePlayerGameModel newGameState) {
    if (singlePlayerGameBox.isEmpty()) {
      singlePlayerGameBox
          .put(newGameState); //should not have an id associated since this is first state.
    } else {
      final id = singlePlayerGameBox.getAll()[0].id;

      newGameState.id = id; //ensure correct id is used

      singlePlayerGameBox.put(newGameState);
    }
  }

  Stream<SinglePlayerGameModel> listenForGameChanges() {
    return singlePlayerGameBox.query().watch().map((query) => query.find()[0]);
  }

  SinglePlayerGameModel fetchSinglePlayerGame() {
    //only one state exists at a time
    return singlePlayerGameBox.getAll()[0];
  }
}
