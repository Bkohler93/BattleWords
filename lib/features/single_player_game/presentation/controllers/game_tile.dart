import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/domain/tile_coords.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final singlePlayerGameTileControllerProvider =
//     Provider.family<SinglePlayerGameTileController, TileCoordinates>((ref, coords) {
//   //use coords to access correct game tile from single player game service
//   // final gameTile = ref.read(singlePlayerGameService).getGameBoardTile(coords);
//   //return gameTileController with game tile
//   // return SinglePlayerGameTileController(gameTile);
//   return SinglePlayerGameTileController();
// });

// class SinglePlayerGameTileController extends StateNotifier<SinglePlayerGameTile> {
//   SinglePlayerGameTileController() : super()
// }
