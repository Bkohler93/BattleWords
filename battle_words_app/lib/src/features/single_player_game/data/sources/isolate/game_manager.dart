import 'dart:isolate';
import 'dart:math';

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
  bool _tileHasAdjacentTiles(
    GameBoard gameBoard,
    int tempRow,
    int tempCol, {
    right = false,
    left = false,
    below = false,
    above = false,
  });
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
      //loop until word is cleared for placement.
      bool placeable = false; //assume word cannot be placed

      while (!placeable) {
        printIsolate("placing word"); //! Gets printed inifinitely on game freeze
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
