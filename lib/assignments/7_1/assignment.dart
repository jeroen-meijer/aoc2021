import 'package:aoc2021/helpers/helpers.dart';

final assignment7_1 = Assignment<int>(
  id: 'Day 7 Part 1',
  name: 'The Treachery of Whales - Part 1',
  answer: 344138,
  fn: _run,
);

int _run() {
  final data =
      getAssignmentData('7_1').first.split(',').map(int.parse).toList();

  final positions = data.map((v) => Position(v)).toList();

  final largestPosition =
      positions.reduce((acc, cur) => cur.value > acc.value ? cur : acc);

  final distanceVectors =
      positions.map((p) => p.getDistanceVector(largestPosition.value)).toList();

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

  List<int> getDistanceVector(int range) {
    return [for (var i = 0; i < range; i++) (value - i).abs()];
  }
}
