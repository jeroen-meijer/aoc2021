import 'package:aoc2021/helpers/helpers.dart';

final assignment9_2 = Assignment<int>(
  id: 'Day 9 Part 2',
  name: 'Smoke Basin - Part 2',
  answer: null,
  fn: _run,
);

int _run() {
  final data = getAssignmentData('9_2')
      .map((line) => line.split('').map(int.parse).toList())
      .toList();

  final heightMap = HeightMap(data);

  final lowPointGroups = heightMap.findLowPointGroups();
  print('Low point groups (basins) found: ${lowPointGroups.length}');

  final totalSize = lowPointGroups.fold<int>(1, (acc, cur) => acc * cur.length);

  // return totalSize;
  return noAnswer();
}

class HeightMap {
  const HeightMap(this.values);

  final List<List<int>> values;

  int get width => values.first.length;
  int get height => values.length;

  // List<CoordinateValue> findLowPoints() {
  //   final result = <CoordinateValue>[];

  //   for (var y = 0; y < values.length; y++) {
  //     final hasAbove = y != 0;
  //     final hasBelow = y != values.length - 1;

  //     final row = values[y];
  //     for (var x = 0; x < row.length; x++) {
  //       final hasLeft = x != 0;
  //       final hasRight = x != row.length - 1;

  //       final value = values[y][x];

  //       final isLowerThanLeft = !hasLeft || value < values[y][x - 1];
  //       final isLowerThanRight = !hasRight || value < values[y][x + 1];
  //       final isLowerThanAbove = !hasAbove || value < values[y - 1][x];
  //       final isLowerThanBelow = !hasBelow || value < values[y + 1][x];

  //       if (isLowerThanLeft &&
  //           isLowerThanRight &&
  //           isLowerThanAbove &&
  //           isLowerThanBelow) {
  //         result.add(CoordinateValue(x, y, value));
  //       }
  //     }
  //   }

  //   return result;
  // }

  List<List<CoordinateValue>> findLowPointGroups() {
    return [];
  }

  @override
  String toString() {
    return '$HeightMap(\n'
        '${values.map((row) => '  ${row.join()}').join('\n')}\n'
        ')';
  }
}

class CoordinateValue {
  const CoordinateValue(this.x, this.y, this.value);

  final int x;
  final int y;
  final int value;

  @override
  String toString() {
    return '$CoordinateValue($x, $y: $value)';
  }
}
