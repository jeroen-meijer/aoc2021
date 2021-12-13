import 'package:aoc2021/helpers/helpers.dart';

final assignment7_2 = Assignment<int>(
  id: 'Day 7 Part 2',
  name: 'The Treachery of Whales - Part 2',
  answer: 94862124,
  fn: _run,
);

int _run() {
  final data =
      getAssignmentData('7_2').first.split(',').map(int.parse).toList();

  final positions = data.map((v) => Position(v)).toList();

  final largestPosition =
      positions.reduce((acc, cur) => cur.value > acc.value ? cur : acc);

  // FIXME: doesn't work properly
  final distanceVectors = positions
      .map((p) => p.getExponentialDistanceVector(largestPosition.value));

  final foldedVectors =
      List<List<int>>.generate(largestPosition.value, (_) => []);

  for (final vector in distanceVectors) {
    for (var i = 0; i < vector.length; i++) {
      foldedVectors[i].add(vector[i]);
    }
  }

  MapEntry<int, int>? lowestSummedVector;

  for (var i = 0; i < foldedVectors.length; i++) {
    final vector = foldedVectors[i];
    final sum = vector.reduce((acc, cur) => acc + cur);
    if (lowestSummedVector == null || sum < lowestSummedVector.value) {
      lowestSummedVector = MapEntry(i, sum);
    }
  }

  final lowestDistanceIndex = lowestSummedVector!.key;
  final lowestDistanceValue = lowestSummedVector.value;

  print('Lowest distance index: $lowestDistanceIndex');
  print('Lowest distance value: $lowestDistanceValue');

  return lowestDistanceValue;
}

class Position {
  const Position(this.value);
  final int value;

  /// A map of distances (the `keys`) and their respective exponential distance
  /// (the `value`).
  ///
  /// When populated, will look like:
  /// ```
  /// { 0: 0, 1: 1, 2: 3, 3: 6, 4: 10, 5: 15, 6: 21, 7: 28, 8: 36, ... }
  /// ```
  static final _exponentialDistanceMap = <int, int>{0: 0};

  int _getExponentialDistance(int distance) {
    if (_exponentialDistanceMap[distance] != null) {
      return _exponentialDistanceMap[distance]!;
    }

    final lastKnownKey =
        _exponentialDistanceMap.keys.lastWhere((d) => d < distance);

    final rangeToGenerate = distance - lastKnownKey;

    final generatorOffset = lastKnownKey + 1;

    for (var i = 0; i < rangeToGenerate; i++) {
      final offsetIndex = i + generatorOffset;
      final lastValue = _exponentialDistanceMap[offsetIndex - 1]!;
      _exponentialDistanceMap[offsetIndex] = lastValue + offsetIndex;
    }

    return _exponentialDistanceMap[distance]!;
  }

  List<int> getDistanceVector(int range) {
    return [for (var i = 0; i < range; i++) (value - i).abs()];
  }

  List<int> getExponentialDistanceVector(int range) {
    final linearDistanceVector = getDistanceVector(range);
    return [
      for (final distance in linearDistanceVector)
        _getExponentialDistance(distance),
    ];
  }
}
