import 'package:aoc2021/helpers/helpers.dart';

final assignment9_1 = Assignment<int>(
  id: 'Day 9 Part 1',
  name: 'Smoke Basin - Part 1',
  answer: 516,
  fn: _run,
);

int _run() {
  final data = getAssignmentData('9_1')
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
  print(heightMap);

  final lowPoints = heightMap.findLowPoints();
  print(
    'Low points: '
    '${lowPoints.map((c) => '(${c.x}, ${c.y} = ${c.value})').join(', ')}',
  );

  final lowPointSum =
      lowPoints.fold<int>(0, (cur, acc) => cur + (acc.value + 1));
  print('Low point sum: $lowPointSum');

  return lowPointSum;
}

class HeightMap {
  const HeightMap(this.values);

  final List<List<int>> values;

  int get width => values.first.length;
  int get height => values.length;

  List<CoordinateValue> findLowPoints() {
    final result = <CoordinateValue>[];

    for (var y = 0; y < values.length; y++) {
      final hasAbove = y != 0;
      final hasBelow = y != values.length - 1;

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
