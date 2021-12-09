import 'package:aoc2021/helpers/helpers.dart';

final assignment4_2 = Assignment<int>(
  id: 'Day 4 Part 2',
  name: 'Giant Squid - Part 2',
  answer: 16168,
  fn: _run,
);

int _run() {
  final data = getAssignmentData('4_2').map((line) => line).toList();

  final drawData = data.first;
  final draws = drawData.split(',').map(int.parse).toList();

  var boardData = data.skip(2).where((line) => line.isNotEmpty);

  final boards = <BingoBoard>[];
  while (boardData.isNotEmpty) {
    final individualBoardData = boardData.take(5).toList();
    boards.add(BingoBoard.parseLines(individualBoardData));
    boardData = boardData.skip(5);
  }

  late BingoBoard lastWinningBoard;
  late Set<int> lastWinningDraws;

  for (var i = 5; i < draws.length; i++) {
    final currentDraws = draws.take(i).toSet();
    print('Drawing numbers: ${currentDraws.join(', ')}');

    final currentWinningBoards =
        boards.where((board) => board.checkHasMatch(currentDraws));

    if (currentWinningBoards.isNotEmpty) {
      lastWinningBoard = currentWinningBoards.last;
      lastWinningDraws = currentDraws;
      boards.removeWhere(currentWinningBoards.contains);
    }
  }

  final lastWinningDraw = lastWinningDraws.last;

  print('Last winning draw: $lastWinningDraw');

  final lastWinningBoardNumbers = lastWinningBoard.flattenData().toSet();
  final unmarkedNumberSum = lastWinningBoardNumbers
      .difference(lastWinningDraws)
      .reduce((acc, cur) => acc + cur);

  print('Unmarked number sum: $unmarkedNumberSum');

  final score = unmarkedNumberSum * lastWinningDraw;

  print('Last winning board score: $score');

  return score;
}

/// {@template winning_draw_boards}
/// Contains a drawn number and all the respective boards that match the drawn
/// number sequence as a result of that draw.
/// {@endtemplate}
class WinningDrawBoards {
  /// {@macro winning_draw_boards}
  const WinningDrawBoards({
    required this.draw,
    required this.boards,
  });

  /// The number that prompted the [boards] to match.
  final int draw;

  /// The [BingoBoard]s that have matched as a result of the [draw] number
  /// being drawn.
  final List<BingoBoard> boards;
}

/// {@template bingo_board}
/// A model representing a single bingo board.
/// {@endtemplate}
class BingoBoard {
  /// {@macro bingo_board}
  const BingoBoard._(this.data);

  /// Parses a list of lines of text into a [BingoBoard] instance.
  ///
  /// The list should follow the following format:
  ///
  /// ```
  /// n1  n2  n3  n4  n5
  /// n6  n7  n8  n9  n10
  /// n11 n12 n13 n14 n15
  /// n16 n17 n18 n19 n20
  /// n21 n22 n23 n24 n25
  /// ```
  factory BingoBoard.parseLines(List<String> lines) {
    final data = <List<int>>[];
    for (final line in lines) {
      final lineData = line
          .split(' ')
          .where((char) => char.trim().isNotEmpty)
          .map(int.parse)
          .toList();
      data.add(lineData);
    }
    return BingoBoard._(data);
  }

  /// The two-dimensional list of bingo card values.
  final List<List<int>> data;

  /// Returns the [data] of this board flattened to a one-dimensional list.
  Iterable<int> flattenData() => data.expand((e) => e);

  /// Checks if this board contains a winning row or column based on the [data]
  /// and the given [drawnNumbers].
  bool checkHasMatch(Set<int> drawnNumbers) {
    bool _checkSequence(List<int> sequence) {
      return sequence.every(drawnNumbers.contains);
    }

    for (var i = 0; i < 5; i++) {
      final row = data[i];
      if (_checkSequence(row)) {
        return true;
      }

      final column = [
        for (var j = 0; j < 5; j++) data[j][i],
      ];
      if (_checkSequence(column)) {
        return true;
      }
    }

    return false;
  }

  @override
  String toString() {
    final buffer = StringBuffer()..writeln('$BingoBoard(');

    for (final row in data) {
      final strings = row.map((n) => n.toString().padLeft(2));
      buffer.writeln('  ${strings.join(' ')},');
    }

    buffer.write(')');

    return buffer.toString();
  }
}
