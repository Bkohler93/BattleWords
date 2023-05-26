import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/multiplayer/data/setup_repository.dart';
import 'package:battle_words/src/features/multiplayer/domain/setup.dart';
import 'package:battle_words/src/features/multiplayer/domain/setup_gameboard_tile.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/game_board_setup_tile.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'setup_event.dart';
part 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  final SetupRepository setupRepo;
  final HiddenWordsRepository hiddenWordsRepo;

  @override
  void onChange(Change<SetupState> change) {
    super.onChange(change);
    // debugPrint(change.toString());
    // debugPrint(change.currentState.toString());
    // debugPrint(change.nextState.toString());
    debugPrint("Bloc updated");
  }

  SetupBloc({required this.setupRepo, required this.hiddenWordsRepo})
      : super(SetupState.initial()) {
    on<StartSetup>(
      (event, emit) async {
        await emit.forEach(
          setupRepo.stateStream,
          onData: (serverState) {
            if (serverState.runtimeType == ServerSetupState) {
              switch (serverState.setupStep) {
                case SetupStep.connectionError:
                  return state.copyWith(); //TODO
                case SetupStep.endSetup:
                  setupRepo.stopListening();
                  return state.copyWith(); //TODO
                case SetupStep.serverSaysHi:
                  return state.copyWith(); //TODO
                default:
                  return state.copyWith(); //TODO
              }
            } else {
              return state.copyWith(); //TODO
            }
          },
          onError: (error, stackTrace) {
            return state.copyWith(); //TODO on error
          },
        );
      },
    );
    on<InitializeSetup>((event, emit) async {
      await setupRepo.connect();
      emit(state.copyWith(
        hiddenWords: hiddenWordsRepo.fetchHiddenWords(),
        status: SetupStatus.settingUp,
      ));
      add(StartSetup());
    });

    on<SelectWordToPlace>((event, emit) async {
      HiddenWord selectedWord = event.word;
      emit(state.copyWith(selectedWord: selectedWord));
    });

    // when a user selects a tile the row and column are selected and
    // the state is updated with the selected coordinates.
    on<SelectTile>((event, emit) {
      int col = event.col;
      int row = event.row;

      emit(state.copyWith(selectedCoords: SelectedGameCoords(col, row)));
    });
    on<ReleaseTile>(
      (event, emit) {
        var gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
        if (state.gameBoard[event.row][event.col].status == SetupGameBoardTileStatus.error) {
          switch (event.dragDirection) {
            case DragDirection.right:
              gameBoard = clearWordRight(event.col, event.row);
              break;
            case DragDirection.down:
              gameBoard = clearWordDown(event.row, event.col);
              break;
            case DragDirection.invalid:
              break;
          }
        } else {
          switch (event.dragDirection) {
            case DragDirection.right:
              for (var i = event.col; i <= state.selectedWord.length; i++) {
                gameBoard[event.row][i] =
                    gameBoard[event.row][i].copyWith(status: SetupGameBoardTileStatus.set);
              }
              break;
            case DragDirection.down:
              for (var i = event.row; i <= state.selectedWord.length; i++) {
                gameBoard[i][event.col] =
                    gameBoard[i][event.col].copyWith(status: SetupGameBoardTileStatus.set);
              }
              break;
            case DragDirection.invalid:
              break;
          }
        }

        emit(state.copyWith(
          selectedCoords: SelectedGameCoords(null, null),
          selectedWord: null,
          gameBoard: gameBoard,
        ));
      },
    );
    // each time the user drags to right or down from selected tile this
    // checks if the word can fit on the board. If the word fits, the letters appear
    // in a lighter shade than the locked in words. If the word does not fit, the
    on<AttemptToPlaceWord>(
      (event, emit) {
        if (state.selectedWord.isInit) {
          return;
        }
        List<List<SetupGameBoardTile>>? gameBoard;
        if (event.direction.isDown) {
          gameBoard = clearWordRight(event.col, event.row);
          gameBoard = placeWordDown(event.row, event.col);
        } else {
          gameBoard = clearWordDown(event.row, event.col);
          gameBoard = placeWordRight(event.col, event.row);
        }
        emit(state.copyWith(gameBoard: gameBoard));
        emit(state.copyWith(placeWordToggle: !state.placeWordToggle));
      },
    );
  }

  List<List<SetupGameBoardTile>> placeWordRight(int startCol, int row) {
    var wordIdx = 0;
    var word = state.selectedWord.word;
    bool hasConflictingWords = false;
    final gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
    if (startCol + word.length > GAME_BOARD_SIZE) {
      for (var i = startCol; i <= MAX_COL_ROW_IDX; i++) {
        if (gameBoard[row][i].status.isSet) {
          hasConflictingWords = true;
        }
      }
      // fill word on board with error status
      for (var i = startCol; i <= MAX_COL_ROW_IDX; i++) {
        if (gameBoard[row][i].status.isEmpty) {
          gameBoard[row][i] = gameBoard[row][i].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.error,
          );
        }
      }
    } else {
      for (var i = startCol; i <= MAX_COL_ROW_IDX; i++) {
        if (gameBoard[row][i].status.isSet) {
          hasConflictingWords = true;
        }
      }

      for (var i = startCol; i < startCol + word.length; i++) {
        if (gameBoard[row][i].status.isEmpty && !hasConflictingWords) {
          gameBoard[row][i] = gameBoard[row][i].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.fits,
          );
        } else if (gameBoard[row][i].status.isEmpty && hasConflictingWords) {
          gameBoard[row][i] = gameBoard[row][i].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.error,
          );
        }
      }
    }
    return gameBoard;
  }

  List<List<SetupGameBoardTile>> clearWordRight(int startCol, int row) {
    var wordIdx = 0;
    var word = state.selectedWord.word;
    final gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
    if (startCol + word.length > GAME_BOARD_SIZE) {
      for (var i = startCol; i <= MAX_COL_ROW_IDX; i++) {
        // check if current tile has the correct word's letter so that
        // another word that is already using that tile does not get it's letter erased
        if (gameBoard[row][i].letter == word[wordIdx++]) {
          gameBoard[row][i] = gameBoard[row][i].copyWith(
            letter: "",
            status: SetupGameBoardTileStatus.empty,
          );
        }
      }
    } else {
      for (var i = startCol; i < startCol + word.length; i++) {
        // check if current tile has the correct word's letter so that
        // another word that is already using that tile does not get it's letter erased
        if (gameBoard[row][i].letter == word[wordIdx++]) {
          gameBoard[row][i] = gameBoard[row][i].copyWith(
            letter: "",
            status: SetupGameBoardTileStatus.empty,
          );
        }
      }
    }
    return gameBoard;
  }

  List<List<SetupGameBoardTile>> placeWordDown(int startRow, int col) {
    var wordIdx = 0;
    var word = state.selectedWord.word;
    final gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
    if (startRow + state.selectedWord.length > GAME_BOARD_SIZE) {
      for (var i = startRow; i <= MAX_COL_ROW_IDX; i++) {
        if (gameBoard[i][col].status.isFits) {
          gameBoard[i][col] = gameBoard[i][col].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.error,
          );
        }
      }

      for (var i = startRow; i <= MAX_COL_ROW_IDX; i++) {
        if (gameBoard[i][col].status.isEmpty) {
          gameBoard[i][col] = gameBoard[i][col].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.error,
          );
        }
      }
    } else {
      for (var i = startRow; i < startRow + word.length; i++) {
        if (gameBoard[i][col].status.isEmpty) {
          gameBoard[i][col] = gameBoard[i][col].copyWith(
            letter: word[wordIdx++],
            status: SetupGameBoardTileStatus.fits,
          );
        }
      }
    }
    return gameBoard;
  }

  bool wordIsSelected() => !state.selectedWord.isInit;

  List<List<SetupGameBoardTile>> clearWordDown(int startRow, int col) {
    var wordIdx = 0;
    var word = state.selectedWord.word;
    final gameBoard = List<List<SetupGameBoardTile>>.from(state.gameBoard);
    if (startRow + word.length > GAME_BOARD_SIZE) {
      for (var i = startRow; i <= MAX_COL_ROW_IDX; i++) {
        if (gameBoard[i][col].letter == word[wordIdx++]) {
          gameBoard[i][col] = gameBoard[i][col].copyWith(
            letter: "",
            status: SetupGameBoardTileStatus.empty,
          );
        }
      }
    } else {
      for (var i = startRow; i < startRow + word.length; i++) {
        if (gameBoard[i][col].letter == word[wordIdx++]) {
          gameBoard[i][col] = gameBoard[i][col].copyWith(
            letter: "",
            status: SetupGameBoardTileStatus.empty,
          );
        }
      }
    }
    return gameBoard;
  }
}
