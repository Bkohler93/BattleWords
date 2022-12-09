import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tile_coords.g.dart';

@immutable
@JsonSerializable()
class TileCoordinates extends Equatable {
  const TileCoordinates({required this.col, required this.row});

  final int col;
  final int row;

  @override
  List<Object?> get props => [col, row];

  TileCoordinates setColRow({required int col, required int row}) {
    return TileCoordinates(col: col, row: row);
  }

  factory TileCoordinates.fromJson(Map<String, dynamic> json) => _$TileCoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$TileCoordinatesToJson(this);
}
