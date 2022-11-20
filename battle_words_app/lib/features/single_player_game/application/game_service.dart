// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:battle_words/api/object_box/object_box.dart';
import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/keyboard/domain/letter.dart';
import 'package:battle_words/features/single_player_game/data/repositories/game.dart';
import 'package:battle_words/features/single_player_game/data/repositories/hidden_words.dart';
import 'package:battle_words/features/single_player_game/data/sources/hidden_words.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/helpers/data_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Direction { horizontal, vertical }

final singlePlayerGameServiceProvider = Provider<SinglePlayerGameService>((ref) {
  return SinglePlayerGameService(
      singlePlayerGameRepository: ref.watch(singlePlayerGameRepositoryProvider),
      hiddenWordsRepository: ref.watch(hiddenWordsRepositoryProvider));
});

class SinglePlayerGameService {
  SinglePlayerGameService(
      {required this.singlePlayerGameRepository, required this.hiddenWordsRepository});
  final MockSinglePlayerGameRepository singlePlayerGameRepository;
  final IHiddenWordsRepository hiddenWordsRepository;

  Future<SinglePlayerGame> flipGameBoardTile(
      {required int row, required int col, required SinglePlayerGame singlePlayerGame}) {
    final SinglePlayerGameTile gameTile = singlePlayerGame.gameBoard[row][col];

    if (!(gameTile.tileStatus == TileStatus.hidden)) {
      return Future.value(SinglePlayerGame.from(singlePlayerGame));
    }

    singlePlayerGame = singlePlayerGame.flipTile(col: col, row: row);

    singlePlayerGame = _findUncoveredWords(singlePlayerGame: singlePlayerGame);

    singlePlayerGame = _fillKeyboardLetters(singlePlayerGame, gameTile.letter);

    singlePlayerGame = _checkIfWin(singlePlayerGame: singlePlayerGame);

    if (singlePlayerGame.gameResult != GameResult.win) {
      singlePlayerGame = _reduceMovesRemaining(singlePlayerGame: singlePlayerGame);
    }
    return _setSinglePlayerGame(singlePlayerGame: singlePlayerGame);
  }

  SinglePlayerGame _reduceMovesRemaining({required SinglePlayerGame singlePlayerGame}) {
    //reduce moves remaining
    singlePlayerGame = singlePlayerGame.reduceMovesRemaining();

    //check if 0, set GameResult to GameResult.win
    if (singlePlayerGame.movesRemaining == 0) {
      singlePlayerGame = singlePlayerGame.setGameResult(GameResult.loss);
    }

    // set in database
    return SinglePlayerGame.from(singlePlayerGame);
  }

  Future<SinglePlayerGame> createSinglePlayerGame() async {
    // get hidden words
    final List<HiddenWord> hiddenWords = await hiddenWordsRepository.fetchHiddenWords();

    //arrange words on board
    GameBoard gameBoard = List.generate(
        GAME_BOARD_SIZE,
        (row) => List.generate(
              GAME_BOARD_SIZE,
              (col) => SinglePlayerGameTile(coordinates: TileCoordinates(col: col, row: row)),
            ));

    for (var hiddenWord in hiddenWords) {
      //loop until word is cleared for placement.
      bool placeable = false; //assume word cannot be placed

      while (!placeable) {
        placeable = true; //assume word can be placed

        //get random acceptable index, determine L->R or T->B
        final int col = Random().nextInt(GAME_BOARD_SIZE);
        late final int row;
        late Direction direction;
        int directionLimiter = GAME_BOARD_SIZE - hiddenWord.length;

        if (col > directionLimiter) {
          row = Random().nextInt(directionLimiter);
          direction = Direction.vertical;
        } else {
          row = Random().nextInt(GAME_BOARD_SIZE);
          direction = row > directionLimiter ? Direction.horizontal : _randomDirection();
        }

        //check if other letters are already present/nearby from other words
        int tempCol = col;
        int tempRow = row;
        for (var i = 0; i < hiddenWord.length; i++) {
          if (gameBoard[tempRow][tempCol].isEmpty()) {
            //check if at top left
            if (tempRow == 0 && tempCol == 0) {
              //check if tiles right and lower are empty
              if (_tileHasAdjacentTiles(gameBoard, tempRow, tempCol, right: true, below: true)) {
                placeable = false;
                break;
              }
            }

            //check if at top right
            else if (tempRow == 0 && tempCol == GAME_BOARD_SIZE - 1) {
              //check if tiles left and below are empty
              if (_tileHasAdjacentTiles(gameBoard, tempRow, tempCol, left: true, below: true)) {
                placeable = false;
                break;
              }
            }

            //check if at bottom left
            else if (tempRow == GAME_BOARD_SIZE - 1 && tempCol == 0) {
              //check if tiles above and right are empty
              if (_tileHasAdjacentTiles(gameBoard, tempRow, tempCol, above: true, right: true)) {
                placeable = false;
                break;
              }
            }

            //check if at bottom right
            else if (tempRow == GAME_BOARD_SIZE - 1 && tempCol == GAME_BOARD_SIZE - 1) {
              //be sure tiles above and left are empty
              if (_tileHasAdjacentTiles(gameBoard, tempRow, tempCol, above: true, left: true)) {
                placeable = false;
                break;
              }
            }

            //check if at top
            else if (tempRow == 0) {
              //make sure tile below, left, and right are empty
              if (_tileHasAdjacentTiles(gameBoard, tempRow, tempCol,
                  below: true, left: true, right: true)) {
                placeable = false;
                break;
              }
            }

            //check if at bottom
            else if (tempRow == GAME_BOARD_SIZE - 1) {
              //make sure tile above, left, and right are empty
              if (_tileHasAdjacentTiles(gameBoard, tempRow, tempCol,
                  above: true, left: true, right: true)) {
                placeable = false;
                break;
              }
            }

            //check if at right
            else if (tempCol == GAME_BOARD_SIZE - 1) {
              //make sure tile above, left, and below are empty
              if (_tileHasAdjacentTiles(gameBoard, tempRow, tempCol,
                  above: true, left: true, below: true)) {
                placeable = false;
                break;
              }
            }

            //check if at left
            else if (tempCol == 0) {
              //make sure tile above, right, and below are empty
              if (_tileHasAdjacentTiles(gameBoard, tempRow, tempCol,
                  above: true, right: true, below: true)) {
                placeable = false;
                break;
              }
            }

            //in middle of board somewhere
            else {
              //make sure tile above, below, right, and left are empoty
              if (_tileHasAdjacentTiles(gameBoard, tempRow, tempCol,
                  above: true, below: true, right: true, left: true)) {
                placeable = false;
                break;
              }
            }
          } else if (gameBoard[tempRow][tempCol].letter == hiddenWord.word[i]) {
            //spot is fine for a word
          } else {
            placeable = false;
            break;
          }
          switch (direction) {
            case Direction.horizontal:
              tempCol++;
              break;
            case Direction.vertical:
              tempRow++;
              break;
          }
        }

        //place word
        if (placeable) {
          var tempRow = row;
          var tempCol = col;
          hiddenWord.letterCoords = {};

          switch (direction) {
            case Direction.horizontal:
              hiddenWord.wordDirection = HiddenWordDirection.right;
              for (var i = 0; i < hiddenWord.length; i++) {
                hiddenWord.letterCoords![i] = TileCoordinates(row: tempRow, col: tempCol);
                gameBoard[tempRow][tempCol] =
                    gameBoard[tempRow][tempCol++].setLetter(hiddenWord.word[i]);
              }
              break;
            case Direction.vertical:
              hiddenWord.wordDirection = HiddenWordDirection.down;
              for (var i = 0; i < hiddenWord.length; i++) {
                hiddenWord.letterCoords![i] = TileCoordinates(row: tempRow, col: tempCol);
                gameBoard[tempRow][tempCol] =
                    gameBoard[tempRow++][tempCol].setLetter(hiddenWord.word[i]);
              }
              break;
          }
        }
      }
    }

    // set moves remaining
    int movesRemaining = START_NUM_OF_MOVES;

    // set single player game in database

    // set up keyboardLetterMap
    KeyboardLetterMap keyboardLetterMap = createBlankKeyboardLetterMap();

    // send single player game to controller
    return SinglePlayerGame(
      gameBoard: gameBoard,
      movesRemaining: movesRemaining,
      hiddenWords: hiddenWords,
      gameResult: GameResult.playing,
      keyboardLetterMap: keyboardLetterMap,
    );
  }

  bool _tileHasAdjacentTiles(
    GameBoard gameBoard,
    int tempRow,
    int tempCol, {
    right = false,
    left = false,
    below = false,
    above = false,
  }) {
    return ((above ? gameBoard[tempRow - 1][tempCol].isNotEmpty() : false) ||
        (below ? gameBoard[tempRow + 1][tempCol].isNotEmpty() : false) ||
        (right ? gameBoard[tempRow][tempCol + 1].isNotEmpty() : false) ||
        (left ? gameBoard[tempRow][tempCol - 1].isNotEmpty() : false));
  }

  Direction _randomDirection() {
    return Random().nextInt(2) == 1 ? Direction.horizontal : Direction.horizontal;
  }

  // ignore: unused_element
  Future<SinglePlayerGame> _fetchSinglePlayerGame() {
    return singlePlayerGameRepository.getSinglePlayerGame();
  }

  // ignore: unused_element
  Future<SinglePlayerGame> _setSinglePlayerGame({required SinglePlayerGame singlePlayerGame}) {
    return Future.value(SinglePlayerGame.from(singlePlayerGame));

    // ignore: dead_code
    final gameService = singlePlayerGameRepository.getSinglePlayerGame();
  }

  //! implement this, lots of logic involved.
  SinglePlayerGame _findUncoveredWords({required SinglePlayerGame singlePlayerGame}) {
    return SinglePlayerGame.from(singlePlayerGame);
  }

  /// Returns false if any tile on the gameboard that has a letter is still hidden
  SinglePlayerGame _checkIfWin({required SinglePlayerGame singlePlayerGame}) {
    var singlePlayerGameCopy = SinglePlayerGame.from(singlePlayerGame);
    bool win = true;

    for (var hiddenWord in singlePlayerGameCopy.hiddenWords) {
      //loop through each coordinate in hiddenWords.coords
      for (var i = 0; i < hiddenWord.length; i++) {
        final row = hiddenWord.letterCoords![i]!.row;
        final col = hiddenWord.letterCoords![i]!.col;
        if (singlePlayerGameCopy.gameBoard[row][col].tileStatus == TileStatus.hidden) {
          win = false;
        }
      }
    }
    if (win) {
      return singlePlayerGameCopy.copyWith(gameResult: GameResult.win);
    } else {
      return singlePlayerGameCopy;
    }
  }

  SinglePlayerGame _fillKeyboardLetters(SinglePlayerGame singlePlayerGame, String letter) {
    //set [KeyboardLetterStatus] to [complete] if every instance of current letter is found on gameboard

    var game = SinglePlayerGame.from(singlePlayerGame);
    bool isEachLetterInstanceFound = true;
    bool isLetterInHiddenWord = false;

    //loop through each tile on gameboard, if letter found set [isLetterNotInHiddenWords] to true
    for (var j = 0; j < GAME_BOARD_SIZE; j++) {
      for (var k = 0; k < GAME_BOARD_SIZE; k++) {
        if (game.gameBoard[j][k].letter == letter) {
          isLetterInHiddenWord = true;
        }
      }
    }
    if (game.keyboardLetterMap[letter] != KeyboardLetterStatus.complete) {
      for (var j = 0; j < GAME_BOARD_SIZE; j++) {
        for (var k = 0; k < GAME_BOARD_SIZE; k++) {
          if (game.gameBoard[j][k].letter == letter &&
              game.gameBoard[j][k].tileStatus == TileStatus.hidden) {
            isEachLetterInstanceFound = false;
          }
        }
      }
      game.keyboardLetterMap[letter] = !isLetterInHiddenWord
          ? KeyboardLetterStatus.empty
          : isEachLetterInstanceFound
              ? KeyboardLetterStatus.complete
              : KeyboardLetterStatus.incomplete;
    }
    return game;
  }

  SinglePlayerGame processWordGuess(
      {required SinglePlayerGame singlePlayerGame, required String word}) {
    var singlePlayerGameCopy = SinglePlayerGame.from(singlePlayerGame);
    bool isExactMatch = false;

    //1. check if any letters were entered or if incorrect number of characters (3-5 only)
    if (word.isEmpty || word.length < 3 || word.length > 5) {
      return singlePlayerGameCopy;
    }

    //2. check if word is real -> display invalid word message if so

    //3. fill matching letters on the game board
    for (var i = 0; i < word.length; i++) {
      for (var hiddenWord in singlePlayerGameCopy.hiddenWords) {
        if (i == 0 && hiddenWord.word == word) {
          isExactMatch = true;
        }

        if (i < hiddenWord.word.length && hiddenWord.word[i] == word[i]) {
          //uncover correct tile on gameBoard
          final coords = hiddenWord.letterCoords![i]!;
          singlePlayerGameCopy.gameBoard[coords.row][coords.col] = singlePlayerGameCopy
              .gameBoard[coords.row][coords.col]
              .uncover(TileStatus.letterFound);
        }
      }

      singlePlayerGameCopy = _fillKeyboardLetters(singlePlayerGameCopy, word[i]);
    }

    //4. check if all words are uncovered (win)
    singlePlayerGameCopy = _checkIfWin(singlePlayerGame: singlePlayerGameCopy);

    //5. reduce moves remaining, lose if at zero
    if (!isExactMatch) {
      singlePlayerGameCopy = _reduceMovesRemaining(singlePlayerGame: singlePlayerGameCopy);
    }

    return singlePlayerGameCopy;
  }
}
