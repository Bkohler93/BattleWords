import 'package:equatable/equatable.dart';

class TileCoordinates extends Equatable {
  const TileCoordinates({required this.row, required this.col});

  final int row;
  final int col;

  @override
  List<Object?> get props => [row, col];
}
