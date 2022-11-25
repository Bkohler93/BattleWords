import 'package:equatable/equatable.dart';

class TileCoordinates extends Equatable {
  const TileCoordinates({required this.col, required this.row});

  final int col;
  final int row;

  @override
  List<Object?> get props => [col, row];
}
