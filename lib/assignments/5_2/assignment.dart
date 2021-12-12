import 'dart:io';
import 'dart:math';

import 'package:aoc2021/helpers/helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as path;

final assignment5_2 = Assignment<int>(
  id: 'Day 5 Part 2',
  name: 'Hydrothermal Venture - Part 2',
  answer: 21038,
  fn: _run,
);

int _run() {
  final data =
      getAssignmentData('5_2').map((line) => OffsetTween.parse(line)).toSet();

  final interpolatedTweens = data.map((t) => t.interpolate()).toSet();
  final interpolatedOffsets = interpolatedTweens.expand((o) => o).toList();

  /// A map of how many times a particular offset was found in the
  /// [interpolatedOffsets] list.
  final offsetCount = <Offset, int>{};

  /// A set of offsets that were found in the [interpolatedOffsets] more than
  /// once.
  final overlappingOffsets = <Offset>{};

  for (final offset in interpolatedOffsets) {
    final newCount = (offsetCount[offset] ?? 0) + 1;
    offsetCount[offset] = newCount;

    if (newCount > 1) {
      overlappingOffsets.add(offset);
    }
  }

  final totalOverlaps = overlappingOffsets.length;

  time('Export line diagram (txt)', () {
    final diagram = createDiagram(interpolatedOffsets);
    final stringDiagram = diagram
        .map((r) => r.map((char) => char == 0 ? '.' : '$char').join())
        .join('\n');

    File(
      path.join(
        getAssignmentDir('5_2'),
        'generated_diagram.txt',
      ),
    ).writeAsStringSync(stringDiagram);
  });

  time('Export line diagram (csv)', () {
    final diagram = createDiagram(interpolatedOffsets);
    final stringDiagram = [
      List.generate(diagram.first.length, (i) => i).join(','),
      ...diagram
          .map((r) => r.map((char) => char == 0 ? '.' : '$char').join(','))
    ].join('\n');

    File(
      path.join(
        getAssignmentDir('5_2'),
        'generated_diagram.csv',
      ),
    ).writeAsStringSync(stringDiagram);
  });

  return totalOverlaps;
}

class Offset extends Equatable {
  const Offset(this.x, this.y);

  factory Offset.parse(String data) {
    final parts = data.split(',').map(int.parse).toList();
    return Offset(parts[0], parts[1]);
  }

  final int x;
  final int y;

  @override
  String toString() {
    return '$Offset($x, $y)';
  }

  @override
  List<Object> get props => [x, y];
}

class OffsetTween extends Equatable {
  const OffsetTween({
    required this.begin,
    required this.end,
  });

  factory OffsetTween.parse(String data) {
    final parts = data.split('->').map((s) => s.trim()).toList();
    return OffsetTween(
      begin: Offset.parse(parts[0]),
      end: Offset.parse(parts[1]),
    );
  }

  final Offset begin;
  final Offset end;

  bool get isDiagonal {
    return begin.x != end.x && begin.y != end.y;
  }

  List<Offset> toList() => [begin, end];

  /// Interpolates this tween from the [begin] offset to the [end].
  ///
  /// Returns a [Set] of offsets representing each point in between [begin] and
  /// [end], creating a line between the two points.
  ///
  /// The two points must form a horizontal, vertical or 45 degree diagonal
  /// line. Tweens forming a line of any other angle are unsupported, and
  /// interpolating these will result in a [StateError].
  ///
  /// ```dart
  /// OffsetTween(
  ///   begin: Offset(2, 5),
  ///   end: Offset(2, 10),
  /// ).interpolate();
  /// // Returns {(2, 5), (2, 6), (2, 7), (2, 8), (2, 9), (2, 10)}
  ///
  /// OffsetTween(
  ///   begin: Offset(0, 3),
  ///   end: Offset(3, 3),
  /// ).interpolate();
  /// // Returns {(0, 3), (1, 3), (2, 3), (3, 3)}
  ///
  /// OffsetTween(
  ///   begin: Offset(0, 0),
  ///   end: Offset(3, 3),
  /// ).interpolate();
  /// // Returns {(0, 0), (1, 1), (2, 2), (3, 3)}
  /// ```
  Set<Offset> interpolate() {
    if (begin == end) {
      return {begin};
    }

    final dx = end.x - begin.x;
    final xStep = dx == 0 ? 0 : dx ~/ dx.abs();

    final dy = end.y - begin.y;
    final yStep = dy == 0 ? 0 : dy ~/ dy.abs();

    if (dx != 0 && dy != 0 && dx.abs() != dy.abs()) {
      throw StateError(
        'Only tweens that form a horizontal, vertical or 45 degree diagonal '
        'line can be interpolated.',
      );
    }

    final dMax = max(dx.abs(), dy.abs());
    final steps = dMax + 1;

    return {
      for (var i = 0; i < steps; i++)
        Offset(
          begin.x + (i * xStep),
          begin.y + (i * yStep),
        ),
    };
  }

  @override
  String toString() {
    final beginXy = '${begin.x},${begin.y}';
    final endXy = '${end.x},${end.y}';
    return '$OffsetTween($beginXy -> $endXy)';
  }

  @override
  List<Object> get props => [begin, end];
}

List<List<int>> createDiagram(List<Offset> offsets) {
  /// An offset of the largest X and Y values of all offsets.
  /// This describes the furthest offset and of the [offsets] can reach, and is
  /// directly related to the size of the diagram.
  final maxOffset = offsets.fold<Offset>(
    const Offset(0, 0),
    (acc, cur) => Offset(
      max(acc.x, cur.x),
      max(acc.y, cur.y),
    ),
  );

  /// Creates the framework for the diagram.
  ///
  /// Since any of the [offsets] can be placed at coordinate 0 on the x and y
  /// planes, the diagram will have width `x + 1` and height `y + 1`.
  final diagram = List<List<int>>.generate(
    maxOffset.y + 1,
    (i) => List<int>.generate(maxOffset.x + 1, (j) => 0),
  );

  for (final offset in offsets) {
    diagram[offset.y][offset.x] += 1;
  }

  return diagram;
}
