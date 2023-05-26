import 'package:equatable/equatable.dart';

class SetupGameBoardTile extends Equatable {
  final String letter;
  final SetupGameBoardTileStatus status;

  SetupGameBoardTile({
    this.letter = "",
    this.status = SetupGameBoardTileStatus.empty,
  });

  @override
  List<Object?> get props => [
        letter,
        status,
      ];

  SetupGameBoardTile copyWith({
    String? letter,
    SetupGameBoardTileStatus? status,
  }) {
    return SetupGameBoardTile(
      letter: letter ?? this.letter,
      status: status ?? this.status,
    );
  }
}

enum SetupGameBoardTileStatus { fits, set, empty, error }

extension SetupGameBoardTileStatusX on SetupGameBoardTileStatus {
  bool get isFits => this == SetupGameBoardTileStatus.fits;
  bool get isSet => this == SetupGameBoardTileStatus.set;
  bool get isEmpty => this == SetupGameBoardTileStatus.empty;
  bool get isError => this == SetupGameBoardTileStatus.error;
}
