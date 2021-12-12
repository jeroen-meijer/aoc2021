import 'package:aoc2021/helpers/helpers.dart';

final assignment6_1 = Assignment<int>(
  id: 'Day 6 Part 1',
  name: 'Lanternfish - Part 1',
  answer: null,
  fn: _run,
);

int _run() {
  final data =
      getAssignmentData('6_1').first.split(',').map(int.parse).toList();

  final simulation = GrowthSimulation(data);
  print(simulation);

  for (var _ = 0; _ < 80; _++) {
    simulation.tick();
    print(simulation);
  }

  print('Final length: ${simulation.length}');

  return simulation.length;
}

/// {@template growth_simulation}
/// A class modeling the simulation of a fish system reproducing exponentially.
/// {@endtemplate}
class GrowthSimulation {
  /// {@template growth_simulation}
  GrowthSimulation(this.entities);

  /// The current list of entities.
  ///
  /// Each [int] represents the days until the entity's timer will reset and
  /// spawn a new entity at the end of the list.
  final List<int> entities;

  int _ticks = 0;

  /// The amount of ticks (or 'days' in the simulation) have passed.
  ///
  /// Starts at `0` and is incremented every time [tick] is called.
  int get ticks => _ticks;

  /// The amount of [entities] in the current simulation.
  int get length => entities.length;

  /// Updates the [entities] by advances every entity's timer and generating new
  /// ones.
  void tick() {
    var bornCount = 0;
    for (var i = 0; i < entities.length; i++) {
      if (entities[i] == 0) {
        entities[i] = 6;
        bornCount++;
      } else {
        entities[i]--;
      }
    }
    entities.addAll(List.generate(bornCount, (_) => 8));

    _ticks++;
  }

  @override
  String toString() {
    return '$GrowthSimulation($ticks, $length, [${entities.join(',')}])';
  }
}
