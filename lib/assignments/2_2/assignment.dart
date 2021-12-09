import 'package:aoc2021/helpers/helpers.dart';

final assignment2_2 = Assignment<int>(
  id: 'Day 2 Part 2',
  name: 'Dive! - Part 2',
  answer: 1727785422,
  fn: _run,
);

int _run() {
  final instructions = getAssignmentData('2_2')
      .map((line) => MovementInstruction.parse(line))
      .toList();

  var offset = const AimedOffset(
    x: 0,
    y: 0,
    aim: 0,
  );
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

class AimedOffset {
  const AimedOffset({
    required this.x,
    required this.y,
    required this.aim,
  });

  final int x;
  final int y;
  final int aim;

  int get multiple => x * y;

  AimedOffset applyMovement(MovementInstruction instruction) {
    final value = instruction.value;

    switch (instruction.direction) {
      case MovementDirection.up:
        return AimedOffset(
          x: x,
          y: y,
          aim: aim - value,
        );
      case MovementDirection.down:
        return AimedOffset(
          x: x,
          y: y,
          aim: aim + value,
        );
      case MovementDirection.forward:
        return AimedOffset(
          x: x + value,
          y: y + (aim * value),
          aim: aim,
        );
    }
  }

  @override
  String toString() {
    return '$AimedOffset($x, $y, $aim)';
  }
}
