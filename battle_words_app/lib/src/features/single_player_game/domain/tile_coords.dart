import 'package:equatable/equatable.dart';

class TileCoordinates extends Equatable {
  TileCoordinates({required this.col, required this.row});

  int col;
  int row;

  @override
  List<Object?> get props => [col, row];

  void setColRow({required int col, required int row}) {
    this.col = col;
    this.row = row;
  }
}

enum Direction { vertical, horizontal, unassigned }

extension DirectionX on Direction {
  bool get isVertical => this == Direction.vertical;
  bool get isUnassigned => this == Direction.unassigned;
  bool get isHorizontal => this == Direction.horizontal;
}
