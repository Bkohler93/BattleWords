import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/multiplayer/data/setup_repository.dart';
import 'package:battle_words/src/features/multiplayer/domain/setup.dart';
import 'package:battle_words/src/features/multiplayer/domain/setup_gameboard_tile.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_state.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/game_board_setup_tile.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetupStateNotifier extends StateNotifier<SetupState> {
  SetupStateNotifier(this.hiddenWordsRepo, this.setupRepo) : super(SetupState.initial());
  HiddenWordsRepository hiddenWordsRepo;
  SetupRepository setupRepo;

  void startSetup() async {
    await setupRepo.connect();
    state = state.copyWith(
        hiddenWords: hiddenWordsRepo.fetchHiddenWords(), status: SetupStatus.settingUp);

    setupRepo.stateStream.listen((event) {
      if (event.runtimeType == ServerSetupState) {
        switch (event.setupStep) {
          case SetupStep.connectionError:
            state = state.copyWith();
            break;
          case SetupStep.endSetup:
            setupRepo.stopListening();
            state = state.copyWith();
            break;
          case SetupStep.serverSaysHi:
            state = state.copyWith();
            break;
          default:
            state = state.copyWith();
        }
      } else {
        state = state.copyWith();
      }
    }, onError: (error) {
      state = state.copyWith();
    });
  }

  void selectWordToPlace(HiddenWord word) {
    HiddenWord selectedWord = word;
    state = state.copyWith(selectedWord: selectedWord);
  }

  void selectTile({required row, required col}) {
    state = state.copyWith(selectedCoords: SelectedGameCoords(col, row));
  }

  void releaseTile({required int row, required int col, required DragDirection dragDirection}) {
    var gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
    List<HiddenWord>? hiddenWords;
    HiddenWord? hiddenWord; // use to set selectedWord to null if word is successfully placed
    if (state.gameBoard[row][col].status == SetupGameBoardTileStatus.error) {
      switch (dragDirection) {
        case DragDirection.right:
          gameBoard = _clearWordRight(col, row);
          break;
        case DragDirection.down:
          gameBoard = _clearWordDown(row, col);
          break;
        case DragDirection.invalid:
          break;
      }
    } else {
      switch (dragDirection) {
        case DragDirection.right:
          for (var i = col; i < col + state.selectedWord.length; i++) {
            gameBoard[row][i] = gameBoard[row][i].copyWith(status: SetupGameBoardTileStatus.set);
          }
          hiddenWords = state.hiddenWords.map((word) {
            if (word == state.selectedWord) {
              word.direction = Direction.horizontal;
              hiddenWord = HiddenWord(word: "no");
              return word;
            }
            return word;
          }).toList();
          break;
        case DragDirection.down:
          for (var i = row; i < row + state.selectedWord.length; i++) {
            gameBoard[i][col] = gameBoard[i][col].copyWith(status: SetupGameBoardTileStatus.set);
          }
          hiddenWords = state.hiddenWords.map((word) {
            if (word == state.selectedWord) {
              word.direction = Direction.vertical;
              hiddenWord = HiddenWord(word: "no");
              return word;
            }
            return word;
          }).toList();
          break;
        case DragDirection.invalid:
          break;
      }
    }

    state = state.copyWith(
      selectedCoords: SelectedGameCoords(null, null),
      selectedWord: hiddenWord,
      gameBoard: gameBoard,
      hiddenWords: hiddenWords,
    );
  }

  void attemptToPlaceWord(
      {required int col, required int row, required DragDirection dragDirection}) {
    if (state.selectedWord.isInit) {
      return;
    }
    print(state.selectedWord.word);
    List<List<SetupGameBoardTile>>? gameBoard;
    if (dragDirection.isDown) {
      gameBoard = _clearWordRight(col, row);
      gameBoard = _placeWordDown(row, col);
    } else {
      gameBoard = _clearWordDown(row, col);
      gameBoard = _placeWordRight(col, row);
    }
    state = state.copyWith(gameBoard: gameBoard);
  }

  List<List<SetupGameBoardTile>> _placeWordRight(int startCol, int row) {
    var wordIdx = 0;
    var word = state.selectedWord.word;
    final gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
    if (startCol + state.selectedWord.length > GAME_BOARD_SIZE) {
      for (var i = startCol; i <= MAX_COL_ROW_IDX; i++) {
        if (gameBoard[row][i].status.isEmpty) {
          gameBoard[row][i] = gameBoard[row][i].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.error,
          );
        }
      }
    } else {
      bool isPlaceable = true;

      //determine if there are any conflicting tiles with proposed word
      for (var i = startCol; i < startCol + word.length; i++) {
        if (gameBoard[row][i].letter == word[wordIdx++]) {
          continue;
        } // allow matching letters
        else if (i == startCol && startCol != 0 && gameBoard[row][i - 1].status.isSet) {
          isPlaceable = false; //check tile before start of word
        } else if (i == startCol + word.length - 1 &&
            i != MAX_COL_ROW_IDX &&
            gameBoard[row][i + 1].status.isSet) {
          isPlaceable = false; //check tile after end of word
        } else if (gameBoard[row][i].status.isSet ||
            (row == 0 ? false : gameBoard[row - 1][i].status.isSet) ||
            (row == MAX_COL_ROW_IDX ? false : gameBoard[row + 1][i].status.isSet)) {
          isPlaceable = false;
        }
      }
      wordIdx = 0;

      if (isPlaceable) {
        for (var i = startCol; i < startCol + word.length; i++) {
          if (gameBoard[row][i].status.isSet) {
            wordIdx++;
            continue;
          }
          gameBoard[row][i] = gameBoard[row][i].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.fits,
          );
        }
      } else {
        for (var i = startCol; i < startCol + word.length; i++) {
          if (gameBoard[row][i].status.isEmpty) {
            gameBoard[row][i] = gameBoard[row][i].copyWith(
              letter: word[wordIdx],
              status: SetupGameBoardTileStatus.error,
            );
          }
          wordIdx++;
        }
      }
    }
    return gameBoard;
  }

  List<List<SetupGameBoardTile>> _clearWordRight(int startCol, int row) {
    var wordIdx = 0;
    var word = state.selectedWord.word;
    final gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
    if (startCol + word.length > GAME_BOARD_SIZE) {
      for (var i = startCol; i <= MAX_COL_ROW_IDX; i++) {
        // check if current tile has the correct word's letter so that
        // another word that is already using that tile does not get it's letter erased
        if (gameBoard[row][i].status != SetupGameBoardTileStatus.set &&
            gameBoard[row][i].letter == word[wordIdx]) {
          gameBoard[row][i] = gameBoard[row][i].copyWith(
            letter: "",
            status: SetupGameBoardTileStatus.empty,
          );
        }
        wordIdx++;
      }
    } else {
      for (var i = startCol; i < startCol + word.length; i++) {
        // check if current tile has the correct word's letter so that
        // another word that is already using that tile does not get it's letter erased
        if (gameBoard[row][i].status != SetupGameBoardTileStatus.set &&
            gameBoard[row][i].letter == word[wordIdx]) {
          gameBoard[row][i] = gameBoard[row][i].copyWith(
            letter: "",
            status: SetupGameBoardTileStatus.empty,
          );
        }
        wordIdx++;
      }
    }
    return gameBoard;
  }

  List<List<SetupGameBoardTile>> _placeWordDown(int startRow, int col) {
    var wordIdx = 0;
    var word = state.selectedWord.word;
    final gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
    if (startRow + state.selectedWord.length > GAME_BOARD_SIZE) {
      for (var i = startRow; i <= MAX_COL_ROW_IDX; i++) {
        if (gameBoard[i][col].status.isEmpty) {
          gameBoard[i][col] = gameBoard[i][col].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.error,
          );
        }
      }
    } else {
      bool isPlaceable = true;

      //determine if there are any conflicting tiles with proposed word
      for (var i = startRow; i < startRow + word.length; i++) {
        if (gameBoard[i][col].letter == word[wordIdx++]) {
          continue;
        } else if (i == startRow && i != 0 && gameBoard[i - 1][col].status.isSet) {
          isPlaceable = false;
        } else if (i == startRow + word.length - 1 &&
            i != MAX_COL_ROW_IDX &&
            gameBoard[i + 1][col].status.isSet) {
          isPlaceable = false;
        } else if (gameBoard[i][col].status.isSet ||
            (col == MAX_COL_ROW_IDX ? false : gameBoard[i][col + 1].status.isSet) ||
            (col == 0 ? false : gameBoard[i][col - 1].status.isSet)) {
          isPlaceable = false;
        }
      }
      wordIdx = 0;

      if (isPlaceable) {
        for (var i = startRow; i < startRow + word.length; i++) {
          if (gameBoard[i][col].status.isSet) {
            wordIdx++;
            continue;
          }
          gameBoard[i][col] = gameBoard[i][col].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.fits,
          );
        }
      } else {
        for (var i = startRow; i < startRow + word.length; i++) {
          if (gameBoard[i][col].status.isEmpty) {
            gameBoard[i][col] = gameBoard[i][col].copyWith(
              letter: word[wordIdx],
              status: SetupGameBoardTileStatus.error,
            );
          }
          wordIdx++;
        }
      }
    }
    return gameBoard;
  }

  bool wordIsSelected() => !state.selectedWord.isInit;

  List<List<SetupGameBoardTile>> _clearWordDown(int startRow, int col) {
    var wordIdx = 0;
    var word = state.selectedWord.word;
    final gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
    if (startRow + word.length > GAME_BOARD_SIZE) {
      for (var i = startRow; i <= MAX_COL_ROW_IDX; i++) {
        if (gameBoard[i][col].status != SetupGameBoardTileStatus.set &&
            gameBoard[i][col].letter == word[wordIdx]) {
          gameBoard[i][col] = gameBoard[i][col].copyWith(
            letter: "",
            status: SetupGameBoardTileStatus.empty,
          );
        }
        wordIdx++;
      }
    } else {
      for (var i = startRow; i < startRow + word.length; i++) {
        if (gameBoard[i][col].status != SetupGameBoardTileStatus.set &&
            gameBoard[i][col].letter == word[wordIdx]) {
          gameBoard[i][col] = gameBoard[i][col].copyWith(
            letter: "",
            status: SetupGameBoardTileStatus.empty,
          );
        }
        wordIdx++;
      }
    }
    return gameBoard;
  }
}

final setupStateProvider = StateNotifierProvider<SetupStateNotifier, SetupState>((ref) {
  HiddenWordsRepository hiddenWordsRepository =
      ref.watch(hiddenWordsRepositoryProvider(ref.watch(objectBoxStoreProvider)));
  SetupRepository setupRepository = ref.watch(setupRepositoryProvider);
  return SetupStateNotifier(hiddenWordsRepository, setupRepository);
});
