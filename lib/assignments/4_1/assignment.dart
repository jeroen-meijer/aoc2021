import 'package:aoc2021/helpers/helpers.dart';

final assignment4_1 = Assignment<int>(
  id: 'Day 4 Part 1',
  name: 'Giant Squid - Part 1',
  answer: 22680,
  fn: _run,
);

int _run() {
  final data = getAssignmentData('4_1').map((line) => line).toList();

  final drawData = data.first;
  final draws = drawData.split(',').map(int.parse).toList();

  var boardData = data.skip(2).where((line) => line.isNotEmpty);

  final boards = <BingoBoard>[];
  while (boardData.isNotEmpty) {
    final individualBoardData = boardData.take(5).toList();
    boards.add(BingoBoard.parseLines(individualBoardData));
    boardData = boardData.skip(5);
  }

  late final BingoBoard winningBoard;

  late Set<int> lastDraws;

  for (var i = 5; i < draws.length; i++) {
    lastDraws = draws.take(i).toSet();
    print('Drawing numbers: ${lastDraws.join(', ')}');
    final winningBoardIndex =
        boards.indexWhere((board) => board.checkHasMatch(lastDraws));

    if (winningBoardIndex != -1) {
      winningBoard = boards[winningBoardIndex];
      print('Winning board found:\n$winningBoard');
      break;
    }
  }

  final winningDraw = lastDraws.last;

  print('Winning draw: $winningDraw');

  final winningBoardNumbers = winningBoard.flattenData().toSet();
  final unmarkedNumberSum =
      winningBoardNumbers.difference(lastDraws).reduce((acc, cur) => acc + cur);

  print('Unmarked number sum: $unmarkedNumberSum');

  final score = unmarkedNumberSum * winningDraw;

  print('Winning board score: $score');

  return score;
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
