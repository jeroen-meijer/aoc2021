import 'package:aoc2021/helpers/helpers.dart';
import 'package:equatable/equatable.dart';

final assignment9_2 = Assignment<int>(
  id: 'Day 9 Part 2',
  name: 'Smoke Basin - Part 2',
  answer: 1023660,
  fn: _run,
);

int _run() {
  final data = getAssignmentData('9_2')
      .map((line) => line.split('').map(int.parse).toList())
      .toList();
  // final data = [
  //   [2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
  //   [3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
  //   [9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
  //   [8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
  //   [9, 8, 9, 9, 9, 6, 5, 6, 7, 8],
  // ];

  final heightMap = HeightMap(data);

  final lowPointGroups = heightMap.findLowPointGroups();
  print('Low point groups (basins) found: ${lowPointGroups.length}');

  final groupSizes = lowPointGroups.map((g) => g.length).toList()..sort();
  print(
    'Largest three group sizes: ${groupSizes.sublist(groupSizes.length - 3)}',
  );

  final sizeOfLargest = groupSizes
      .sublist(groupSizes.length - 3)
      .fold<int>(1, (acc, cur) => acc * cur);
  print('Multiplied size of largest three: $sizeOfLargest');

  return sizeOfLargest;
}

class HeightMap {
  const HeightMap(this.values);

  final List<List<int>> values;

  int get width => values.first.length;
  int get height => values.length;

  Set<CoordinateValue> findLowPoints() {
    final result = <CoordinateValue>{};

    for (var y = 0; y < height; y++) {
      final hasAbove = y != 0;
      final hasBelow = y != height - 1;

      final row = values[y];
      for (var x = 0; x < row.length; x++) {
        final hasLeft = x != 0;
        final hasRight = x != row.length - 1;

        final value = values[y][x];

        final isLowerThanLeft = !hasLeft || value < values[y][x - 1];
        final isLowerThanRight = !hasRight || value < values[y][x + 1];
        final isLowerThanAbove = !hasAbove || value < values[y - 1][x];
        final isLowerThanBelow = !hasBelow || value < values[y + 1][x];

        if (isLowerThanLeft &&
            isLowerThanRight &&
            isLowerThanAbove &&
            isLowerThanBelow) {
          result.add(CoordinateValue(x, y, value));
        }
      }
    }

    return result;
  }

  Set<CoordinateValue> getNonLimitAdjacents(CoordinateValue c) {
    CoordinateValue getValue(int x, int y) {
      return CoordinateValue(x, y, values[y][x]);
    }

    final x = c.x;
    final y = c.y;

    final row = values[y];

    final hasAbove = y != 0;
    final hasBelow = y != values.length - 1;
    final hasLeft = x != 0;
    final hasRight = x != row.length - 1;

    return {
      if (hasAbove) getValue(x, y - 1),
      if (hasBelow) getValue(x, y + 1),
      if (hasLeft) getValue(x - 1, y),
      if (hasRight) getValue(x + 1, y),
    }..removeWhere((c) => c.value == 9);
  }

  Set<Set<CoordinateValue>> findLowPointGroups() {
    final lowPoints = findLowPoints();
    final groups = <Set<CoordinateValue>>{{}};

    for (final lowPoint in lowPoints) {
      final groupForLowPoint = <CoordinateValue>{};

      final adjacentsToSearch = {lowPoint};

      while (adjacentsToSearch.isNotEmpty) {
        final adjacentsBuffer = <CoordinateValue>{};
        for (final coordinate in adjacentsToSearch) {
          adjacentsBuffer.addAll(getNonLimitAdjacents(coordinate));
        }
        groupForLowPoint.addAll(adjacentsToSearch);
        final newSearchableAdjacents =
            adjacentsBuffer.difference(groupForLowPoint);
        adjacentsToSearch
          ..clear()
          ..addAll(newSearchableAdjacents);
      }

      groups.add(groupForLowPoint);
    }

    return groups;
  }

  @override
  String toString() {
    return '$HeightMap(\n'
        '${values.map((row) => '  ${row.join()}').join('\n')}\n'
        ')';
  }
}

class CoordinateValue extends Equatable {
  const CoordinateValue(this.x, this.y, this.value);

  final int x;
  final int y;
  final int value;

  @override
  List<Object> get props => [x, y, value];

  @override
  String toString() {
    return '$CoordinateValue($x, $y: $value)';
  }
}
