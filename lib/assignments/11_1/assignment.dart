import 'dart:collection';

import 'package:aoc2021/helpers/helpers.dart';
import 'package:equatable/equatable.dart';

final assignment11_1 = Assignment<int>(
  id: 'Day 11 Part 1',
  name: 'Dumbo Octopus - Part 1',
  answer: -1,
  fn: _run,
);

int _run() {
  // final data = getAssignmentData('11_1')
  //     .map((line) => line.split('').map(int.parse).toList())
  //     .toList();
  final data = [
    [5, 4, 8, 3, 1, 4, 3, 2, 2, 3],
    [2, 7, 4, 5, 8, 5, 4, 7, 1, 1],
    [5, 2, 6, 4, 5, 5, 6, 1, 7, 3],
    [6, 1, 4, 1, 3, 3, 6, 1, 4, 6],
    [6, 3, 5, 7, 3, 8, 5, 4, 7, 8],
    [4, 1, 6, 7, 5, 2, 4, 6, 4, 5],
    [2, 1, 7, 6, 8, 4, 1, 7, 2, 1],
    [6, 8, 8, 2, 8, 8, 1, 1, 3, 4],
    [4, 8, 4, 6, 8, 4, 8, 5, 5, 4],
    [5, 2, 8, 3, 7, 5, 1, 5, 2, 6],
  ];

  final matrix = EnergyMatrix(data);
  print(matrix);
  matrix.tick();
  print(matrix);
  matrix.tick();
  print(matrix);

  return noAnswer();
}

class EnergyMatrix {
  EnergyMatrix(
    this.data, {
    this.ticks = 0,
  }) : assert(
          data.length == 10 && data.every((line) => line.length == 10),
          'Data must contain exactly 10 lines of 10 integers each '
          '(i.e., a 10x10 grid).',
        );

  static const _overflowThreshold = 10;

  final List<List<int>> data;
  int ticks;

  int overflows = 0;

  bool get hasOverflows {
    return data.any((line) => line.any((n) => n == 10));
  }

  void tick() {
    // Increment all
    for (var y = 0; y < data.length; y++) {
      for (var x = 0; x < data[y].length; x++) {
        data[y][x]++;
      }
    }

    // Check for overflows, cascade changes, repeat.
    while (hasOverflows) {
      _processOverflows();
    }

    ticks++;
  }

  // TODO(jeroen-meijer): This is buggy.
  void _processOverflows() {
    // A [Map] containing all the diff between the current state ([data]) and
    // the state after calculating all the overflows.
    final diffMap = HashMap<Offset, int>();

    for (var y = 0; y < data.length; y++) {
      final row = data[y];
      for (var x = 0; x < row.length; x++) {
        final value = row[x];
        final newValue = value % _overflowThreshold;
        final overflows = value ~/ 10;

        data[y][x] = newValue;

        if (overflows != 0) {
          final above = Offset(x, y - 1);
          final hasAbove = above.y != -1;

          final below = Offset(x, y + 1);
          final hasBelow = below.y < data.length;

          final left = Offset(x - 1, y);
          final hasLeft = left.x != -1;

          final right = Offset(x + 1, y);
          final hasRight = right.x < row.length;

          if (hasAbove) {
            diffMap[above] = (diffMap[above] ??= 0) + 1;
          }
          if (hasBelow) {
            diffMap[below] = (diffMap[below] ??= 0) + 1;
          }
          if (hasLeft) {
            diffMap[left] = (diffMap[left] ??= 0) + 1;
          }
          if (hasRight) {
            diffMap[right] = (diffMap[right] ??= 0) + 1;
          }
        }
      }
    }

    print(diffMap);

    for (final entry in diffMap.entries) {
      data[entry.key.y][entry.key.x] += entry.value;
    }

    print(data);
  }

  @override
  String toString() {
    final dataString = data
        .map((line) => '  ${line.map((n) => '$n'.padLeft(2)).join(' ')}')
        .join('\n');

    return '$EnergyMatrix(  ticks: $ticks,\n'
        '$dataString\n'
        ')';
  }
}

class Offset extends Equatable {
  const Offset(this.x, this.y);

  final int x;
  final int y;

  @override
  String toString() {
    return '$Offset($x, $y)';
  }

  @override
  List<Object> get props => [x, y];
}
