import 'package:aoc2021/helpers/helpers.dart';

final assignment1_2 = Assignment<int>(
  id: 'Day 1 Part 2',
  name: 'Sonar Sweep - Part 2',
  answer: 1362,
  fn: _run,
);

const _kWindowSize = 3;

int _run() {
  final data =
      getAssignmentData('1_2').map((line) => int.parse(line.trim())).toList();

  final windows = <int>[];

  for (var i = 0; i < data.length - (_kWindowSize - 1); i++) {
    var currentWindowValue = 0;
    final maxWindowIndex = _kWindowSize + i;
    for (var j = i; j < maxWindowIndex; j++) {
      currentWindowValue += data[j];
    }
    windows.add(currentWindowValue);
  }

  final nodes = nodesFromValues(windows);

  for (final node in nodes) {
    late final String? description;

    if (node.isRoot) {
      description = 'N/A - no previous measurement';
    } else if (node.didStay) {
      description = 'no change';
    } else if (node.didIncrease) {
      description = 'increased';
    } else if (node.didDecrease) {
      description = 'decreased';
    } else {
      throw StateError(
        'Node at index <${nodes.indexOf(node)}> '
        'with value ${node.value} has an invalid state.',
      );
    }

    print('${node.value} ($description)');
  }

  final totalIncreases = nodes.where((node) => node.didIncrease).length;

  print('Total number of increases: $totalIncreases');
  return totalIncreases;
}

class SonarNode {
  const SonarNode({
    required this.value,
    required this.previous,
  });
  final int value;
  final SonarNode? previous;

  bool get isRoot => previous == null;
  bool get didIncrease => !isRoot && value > previous!.value;
  bool get didDecrease => !isRoot && value < previous!.value;
  bool get didStay => !isRoot && value == previous!.value;
}

List<SonarNode> nodesFromValues(List<int> values) {
  final result = <SonarNode>[];

  for (var i = 0; i < values.length; i++) {
    final lastIndex = i - 1;
    final previous = lastIndex < 0 ? null : result[lastIndex];

    result.add(
      SonarNode(
        previous: previous,
        value: values[i],
      ),
    );
  }

  return result;
}
