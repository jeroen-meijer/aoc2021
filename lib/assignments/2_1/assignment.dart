import 'package:aoc2021/helpers/helpers.dart';

final assignment2_1 = Assignment<int>(
  id: 'Day 2 Part 1',
  name: 'Dive! - Part 1',
  answer: 1840243,
  fn: _run,
);

int _run() {
  final instructions = getAssignmentData('2_1')
      .map((line) => MovementInstruction.parse(line))
      .toList();

  var offset = const Offset(0, 0);
  for (final instruction in instructions) {
    final before = offset;
    offset = offset.applyMovement(instruction);
    print(
      'Applying (${instruction.direction.describe()} ${instruction.value}) '
      'to $before => $offset',
    );
  }

  print('Final offset: $offset');
  print('Multiple: ${offset.multiple}');
  return offset.multiple;
}

enum MovementDirection { forward, up, down }

class MovementInstruction {
  const MovementInstruction._(this.direction, this.value);

  factory MovementInstruction.parse(String line) {
    final parts = line.trim().split(' ');

    late final MovementDirection direction;
    switch (parts[0]) {
      case 'forward':
        direction = MovementDirection.forward;
        break;
      case 'up':
        direction = MovementDirection.up;
        break;
      case 'down':
        direction = MovementDirection.down;
        break;
    }

    final value = int.parse(parts[1]);
    return MovementInstruction._(direction, value);
  }

  final MovementDirection direction;
  final int value;

  @override
  String toString() {
    return '$MovementInstruction(${direction.describe()}, $value)';
  }
}

class Offset {
  const Offset(this.x, this.y);

  final int x;
  final int y;

  int get multiple => x * y;

  Offset applyMovement(MovementInstruction instruction) {
    final value = instruction.value;

    switch (instruction.direction) {
      case MovementDirection.forward:
        return Offset(x + value, y);
      case MovementDirection.up:
        return Offset(x, y - value);
      case MovementDirection.down:
        return Offset(x, y + value);
    }
  }

  @override
  String toString() {
    return '$Offset($x, $y)';
  }
}
