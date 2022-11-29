import 'dart:isolate';
import 'dart:math';

import 'package:battle_words/src/common/extensions/primitives.dart';
import 'package:battle_words/src/common/widgets/keyboard/domain/letter.dart';
import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/single_player_game/data/dao/game_manager.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/isolate.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:battle_words/src/helpers/data_types.dart';

abstract class IGameManager {
  void _listen();
  void _initializeGame();
  bool _doesTileHaveAdjacentFilledTiles(GameBoard gameBoard, int tempRow, int tempCol);
  Direction _randomDirection();
  void _startSinglePlayerGame();
  SinglePlayerState flipTile({required int row, required int col});
  void _updateGameByTileTap({required int col, required int row});
  void _updateGameByGuessingWord({required String word});
  SinglePlayerState _fillKeyboardLetters(SinglePlayerState singlePlayerGame, String letter);
  SinglePlayerState _checkIfWin({required SinglePlayerState singlePlayerGame});
  SinglePlayerState _reduceMovesRemaining({required SinglePlayerState singlePlayerGame});
}

class GameManager implements IGameManager {
  GameManager(
      {required this.toRepositoryPort,
      required this.fromRepositoryPort,
      required this.hiddenWordsRepository}) {
    toRepositoryPort
        .send(fromRepositoryPort.sendPort); // send repository its port to send data to GameManager
    _initializeGame();
    _listen();
  }

  IHiddenWordsRepository? hiddenWordsRepository;
  final SendPort toRepositoryPort;
  final ReceivePort fromRepositoryPort;
  late SinglePlayerState state;

  @override
  void _listen() {
    printIsolate("Game Manager started listening");
    fromRepositoryPort.listen(
      (message) {
        switch (message.runtimeType) {
          case GetSinglePlayerGame:
            {
              _startSinglePlayerGame();
              break;
            }
          case UpdateGameByTileTap:
            {
              _updateGameByTileTap(col: message.col, row: message.row);
              break;
            }
          case UpdateGameByGuessingWord:
            {
              _updateGameByGuessingWord(word: message.word);
              break;
            }
          case SetSinglePlayerGame:
            {
              toRepositoryPort.send('set single player game');
              break;
            }
          case GameOver:
            {
              fromRepositoryPort.close();
              hiddenWordsRepository!.closeStore();
            }
        }
      },
    );
  }

  //! Placing words on board algorithm is causing freezing
  @override
  void _initializeGame() {
    printIsolate("Initializing game");
    final List<HiddenWord> hiddenWords = hiddenWordsRepository!.fetchHiddenWords();

    //arrange words on board
    GameBoard gameBoard = List.generate(
        GAME_BOARD_SIZE,
        (row) => List.generate(
              GAME_BOARD_SIZE,
              (col) => SinglePlayerGameTile(coordinates: TileCoordinates(col: col, row: row)),
            ));

    for (var hiddenWord in hiddenWords) {
      //place the word length of 5
      if (hiddenWord.length == 5) {
        final direction = _randomDirection();

        if (direction.isHorizontal) {
          hiddenWord.direction = Direction.horizontal;
          final col = Random().nextInt(2);
          final row = Random().nextInt(6);

          for (var i = 0; i < hiddenWord.length; i++) {
            hiddenWord.letterCoords![i] = TileCoordinates(col: col + i, row: row);
            gameBoard[row][col + i] = gameBoard[row][col + i].setLetter(hiddenWord.word[i]);
          }
        } else if (direction.isVertical) {
          hiddenWord.direction = Direction.vertical;
          final col = Random().nextInt(6);
          final row = Random().nextInt(2);

          for (var i = 0; i < hiddenWord.length; i++) {
            hiddenWord.letterCoords![i] = TileCoordinates(col: col, row: row + i);
            hiddenWord.letterCoords![i]!.setColRow(col: col, row: row + i);
            gameBoard[row + i][col] = gameBoard[row + i][col].setLetter(hiddenWord.word[i]);
          }
        } else {
          throw "(game_manager.dart 114): No valid direction generated";
        }

        //place word length of 4
      } else if (hiddenWord.length == 4) {
        if (hiddenWords[0].direction.isHorizontal &&
            hiddenWords[0].letterCoords![0]!.col.isBetweenInclusive(1, 4)) {
          bool isPlaceable = false; //start false to enter while loop
          int startCol = -1;
          int constRow = -1;
          hiddenWord.direction = Direction.horizontal;

          while (!isPlaceable) {
            //assume the word will be placeable
            isPlaceable = true;

            startCol = Random().nextInt(3);
            constRow = Random().nextInt(6);

            //check if surrounding tiles are empty
            for (var i = 0; i < hiddenWord.length; i++) {
              if (gameBoard[constRow][startCol + i].isNotEmpty() ||
                  _doesTileHaveAdjacentFilledTiles(gameBoard, constRow, startCol + i)) {
                isPlaceable = false;
              }
            }
          }
          //fill word
          for (var i = 0; i < hiddenWord.length; i++) {
            hiddenWord.letterCoords![i] = TileCoordinates(col: startCol + i, row: constRow);
            gameBoard[constRow][startCol + i] =
                gameBoard[constRow][startCol + i].setLetter(hiddenWord.word[i]);
          }
        } else if (hiddenWords[0].direction.isVertical &&
            hiddenWords[0].letterCoords![0]!.row.isBetweenInclusive(1, 4)) {
          hiddenWord.direction = Direction.vertical;
          bool isPlaceable = false; //start with false to enter while loop
          int constCol = -1;
          int startRow = -1;
          hiddenWord.direction = Direction.vertical;

          while (!isPlaceable) {
            //assume word is placeable and prove it wrong
            isPlaceable = true;

            constCol = Random().nextInt(6);
            startRow = Random().nextInt(3);

            for (var i = 0; i < hiddenWord.length; i++) {
              if (gameBoard[startRow + i][constCol].isNotEmpty() ||
                  _doesTileHaveAdjacentFilledTiles(gameBoard, startRow, constCol)) {
                isPlaceable = false;
              }
            }
          }

          for (var i = 0; i < hiddenWord.length; i++) {
            hiddenWord.letterCoords![i] = TileCoordinates(col: constCol + 1, row: startRow);
            gameBoard[startRow + i][constCol] =
                gameBoard[startRow + i][constCol].setLetter(hiddenWord.word[i]);
          }
        } else {
          hiddenWord.direction = _randomDirection();
          bool isPlaceable = false;
          int col = -1;
          int row = -1;

          while (!isPlaceable) {
            //asume the word is going to be placeable this iteration
            isPlaceable = true;
            if (hiddenWord.direction.isHorizontal) {
              col = Random().nextInt(3);
              row = Random().nextInt(6);

              for (var i = 0; i < hiddenWord.length; i++) {
                if (gameBoard[row][col + i].isNotEmpty() ||
                    _doesTileHaveAdjacentFilledTiles(gameBoard, row, col)) {
                  isPlaceable = false;
                }
              }
            } else {
              col = Random().nextInt(6);
              row = Random().nextInt(3);
              for (var i = 0; i < hiddenWord.length; i++) {
                if (gameBoard[row + i][col].isNotEmpty() ||
                    _doesTileHaveAdjacentFilledTiles(gameBoard, row, col)) {
                  isPlaceable = false;
                }
              }
            }
          }

          //place word on board horizontally
          if (hiddenWord.direction.isHorizontal) {
            for (var i = 0; i < hiddenWord.length; i++) {
              hiddenWord.letterCoords![i] = TileCoordinates(col: col + i, row: row);
              gameBoard[row][col + i] = gameBoard[row][col + i].setLetter(hiddenWord.word[i]);
            }
          } else {
            //place word on board vertically
            for (var i = 0; i < hiddenWord.length; i++) {
              hiddenWord.letterCoords![i] = TileCoordinates(col: col, row: row + i);
              hiddenWord.letterCoords![i]!.setColRow(col: col, row: row + i);
              gameBoard[row + i][col] = gameBoard[row + i][col].setLetter(hiddenWord.word[i]);
            }
          }
        }
      } else {
        //place word of length 3
        final direction = _randomDirection();
        if (direction.isHorizontal) {
          int consecutiveAvailableTiles = 0;
          int startingIdx = -1;
          int fillRow = -1;

          //search for open spot starting at top
          rowLoop:
          for (var row = 0; row < GAME_BOARD_SIZE; row++) {
            fillRow = row;
            consecutiveAvailableTiles = 0;
            startingIdx = 0;
            for (var col = 0; col < GAME_BOARD_SIZE; col++) {
              if (gameBoard[row][col].isEmpty() &&
                  !_doesTileHaveAdjacentFilledTiles(gameBoard, row, col)) {
                consecutiveAvailableTiles++;
              } else {
                consecutiveAvailableTiles = 0;
              }
              if (consecutiveAvailableTiles == 1) {
                startingIdx = col;
              }

              if (consecutiveAvailableTiles == hiddenWord.length) {
                break rowLoop;
              }
            }
          }
          //fill word on board
          for (var i = startingIdx; i < hiddenWord.length; i++) {
            hiddenWord.letterCoords![i] = TileCoordinates(col: i, row: fillRow);
            gameBoard[fillRow][i - startingIdx] =
                gameBoard[fillRow][i - startingIdx].setLetter(hiddenWord.word[i - startingIdx]);
          }
        }
        if (direction.isVertical) {
          int consecutiveAvailableTiles = 0;
          int startingIdx = -1;
          int fillCol = -1;

          //search for open spot starting at top
          colLoop:
          for (var col = 0; col < GAME_BOARD_SIZE; col++) {
            fillCol = col;
            consecutiveAvailableTiles = 0;
            startingIdx = 0;
            for (var row = 0; row < GAME_BOARD_SIZE; row++) {
              if (gameBoard[row][col].isEmpty() &&
                  !_doesTileHaveAdjacentFilledTiles(gameBoard, row, col)) {
                consecutiveAvailableTiles++;
              } else {
                consecutiveAvailableTiles = 0;
              }
              if (consecutiveAvailableTiles == 1) {
                startingIdx = col;
              }

              if (consecutiveAvailableTiles == hiddenWord.length) {
                break colLoop;
              }
            }
          }
          //fill word on board
          for (var i = startingIdx; i < hiddenWord.length; i++) {
            hiddenWord.letterCoords![i] = TileCoordinates(col: fillCol, row: i - startingIdx);
            gameBoard[i - startingIdx][fillCol] =
                gameBoard[i - startingIdx][fillCol].setLetter(hiddenWord.word[i - startingIdx]);
          }
        }
      }
    }

    printIsolate("Set all words on board");
    // set moves remaining
    int movesRemaining = START_NUM_OF_MOVES;

    // set single player game in database

    // set up keyboardLetterMap
    KeyboardLetterMap keyboardLetterMap = createBlankKeyboardLetterMap();

    // send single player game to controller
    state = SinglePlayerState(
      gameBoard: gameBoard,
      movesRemaining: movesRemaining,
      hiddenWords: hiddenWords,
      keyboardLetterMap: keyboardLetterMap,
      gameStatus: GameStatus.playing,
    );
    printIsolate("Sending initial state");
    //send out initial state
    toRepositoryPort.send(state);
  }

  @override
  bool _doesTileHaveAdjacentFilledTiles(GameBoard gameBoard, int tempRow, int tempCol) {
    //checks tile above
    return ((tempRow != 0 ? !gameBoard[tempRow - 1][tempCol].isEmpty() : false) ||

        //checks tile below
        (tempRow != GAME_BOARD_SIZE - 1 ? !gameBoard[tempRow + 1][tempCol].isEmpty() : false) ||

        //checks tile to the right
        (tempCol != GAME_BOARD_SIZE - 1 ? !gameBoard[tempRow][tempCol + 1].isEmpty() : false) ||

        //checks tile to the left
        (tempCol != 0 ? !gameBoard[tempRow][tempCol - 1].isEmpty() : false));
  }

  @override
  Direction _randomDirection() {
    return Random().nextInt(2) == 1 ? Direction.horizontal : Direction.horizontal;
  }

  @override
  void _startSinglePlayerGame() {
    toRepositoryPort.send(state);
  }

  @override
  SinglePlayerState flipTile({required int row, required int col}) {
    SinglePlayerState singlePlayerGameCopy = state;
    switch (singlePlayerGameCopy.gameBoard[row][col].letter) {
      case "":
        singlePlayerGameCopy.gameBoard[row][col] =
            singlePlayerGameCopy.gameBoard[row][col].uncover(TileStatus.empty);
        break;
      default:
        singlePlayerGameCopy.gameBoard[row][col] =
            singlePlayerGameCopy.gameBoard[row][col].uncover(TileStatus.letterFound);
    }

    return singlePlayerGameCopy;
  }

  @override
  void _updateGameByTileTap({required int col, required int row}) {
    final SinglePlayerGameTile gameTile = state.gameBoard[row][col];

    if (!(gameTile.tileStatus.isHidden)) {
      toRepositoryPort.send(state); //tile already uncovered..
      return;
    }

    state = flipTile(col: col, row: row);

    state = _fillKeyboardLetters(state, gameTile.letter);

    state = _checkIfWin(singlePlayerGame: state);

    //only reduce moves and check for loss if game hasn't been won up to this point
    if (state.gameStatus != GameStatus.win) {
      state = _reduceMovesRemaining(singlePlayerGame: state);
    }
    toRepositoryPort.send(state);
  }

  @override
  void _updateGameByGuessingWord({required String word}) {
    bool isExactMatch = false;

    //2. check if word is real -> display invalid word message if so

    //3. fill matching letters on the game board
    for (var i = 0; i < word.length; i++) {
      for (var hiddenWord in state.hiddenWords) {
        if (i == 0 && hiddenWord.word == word) {
          isExactMatch = true;
        }

        if (i < hiddenWord.word.length && hiddenWord.word[i] == word[i]) {
          //uncover correct tile on gameBoard
          final coords = hiddenWord.letterCoords![i]!;
          state.gameBoard[coords.row][coords.col] =
              state.gameBoard[coords.row][coords.col].uncover(TileStatus.letterFound);
        }
      }

      state = _fillKeyboardLetters(state, word[i]);
    }

    //4. check if all words are uncovered (win)
    state = _checkIfWin(singlePlayerGame: state);

    //5. reduce moves remaining, lose if at zero
    if (!isExactMatch && state.gameStatus.isPlaying) {
      state = _reduceMovesRemaining(singlePlayerGame: state);
    }
    toRepositoryPort.send(state);
  }

  @override
  SinglePlayerState _fillKeyboardLetters(SinglePlayerState singlePlayerGame, String letter) {
    //set [KeyboardLetterStatus] to [complete] if every instance of current letter is found on gameboard

    var game = singlePlayerGame;
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

  /// Returns false if any tile on the gameboard that has a letter is still hidden
  @override
  SinglePlayerState _checkIfWin({required SinglePlayerState singlePlayerGame}) {
    var singlePlayerGameCopy = singlePlayerGame;
    bool areAllHiddenWordsFound = true;

    for (var hiddenWord in singlePlayerGameCopy.hiddenWords) {
      bool isHiddenWordUncovered = true;
      //loop through each coordinate in hiddenWords.coords
      for (var i = 0; i < hiddenWord.length; i++) {
        final row = hiddenWord.letterCoords![i]!.row;
        final col = hiddenWord.letterCoords![i]!.col;
        if (singlePlayerGameCopy.gameBoard[row][col].tileStatus == TileStatus.hidden) {
          isHiddenWordUncovered = false;
          areAllHiddenWordsFound = false;
        } else {
          hiddenWord.areLettersFound[i] = true;
        }
      }

      //set current hiddenWord.found to true
      if (isHiddenWordUncovered) {
        hiddenWord.isWordFound = true;
      }
    }
    if (areAllHiddenWordsFound) {
      return singlePlayerGameCopy.copyWith(gameStatus: GameStatus.win);
    } else {
      return singlePlayerGameCopy;
    }
  }

  @override
  SinglePlayerState _reduceMovesRemaining({required SinglePlayerState singlePlayerGame}) {
    //reduce moves remaining
    singlePlayerGame =
        singlePlayerGame.copyWith(movesRemaining: singlePlayerGame.movesRemaining - 1);

    //check if 0, set GameResult to GameResult.win
    if (singlePlayerGame.movesRemaining == 0) {
      singlePlayerGame = singlePlayerGame.copyWith(gameStatus: GameStatus.loss);
    }

    // set in database
    return singlePlayerGame;
  }
}
