import 'dart:async';
import 'dart:isolate';

import 'package:aoc2021/helpers/helpers.dart';

final assignment6_2 = Assignment<int>(
  id: 'Day 6 Part 2',
  name: 'Lanternfish - Part 2',
  answer: null,
  fn: _run,
);

int _run() {
  final data =
      getAssignmentData('6_2').first.split(',').map(int.parse).toList();

  final simulation = AdvancedGrowthSimulation(data);
  print(simulation);

  // 'Too difficult. Current solution exceeds memory or reasonable runtime.',
  return noAnswer();

  // await simulation.run(256);
  // print(simulation);

  // print('Final length: ${simulation.length}');

  // return simulation.length;
}

/// {@template advanced_growth_simulation}
/// A class modeling the simulation of a fish system reproducing exponentially.
/// {@endtemplate}
class AdvancedGrowthSimulation {
  /// {@template advanced_growth_simulation}
  AdvancedGrowthSimulation(this.entities);

  /// How many ticks every entity survives until they respawn and generate a new
  /// entity alongside.
  static const lifespan = 7;

  /// The lifespan of any entity that is spawned while a simulation happens.
  static const newEntityLifespan = 8;

  /// The current list of entities.
  ///
  /// Each [int] represents the days until the entity's timer will reset and
  /// spawn a new entity at the end of the list.
  final List<int> entities;

  int _ticks = 0;

  /// The amount of ticks (or 'days' in the simulation) have passed.
  ///
  /// Starts at `0` and is incremented every time [run] is called with the given
  /// amount of `ticks`.
  int get ticks => _ticks;

  /// The amount of [entities] in the current simulation.
  int get length => entities.length;

  /// Runs the simulation for [ticks] amount of days.
  ///
  /// Updates the [entities] by advances every entity's timer and generating new
  /// ones by the amount of [ticks] provided.
  Future<void> run(int ticks) async {
    // _runOldAlgorithm(ticks);
    await _runNewAlgorithm(ticks);

    _ticks += ticks;
  }

  // void _runOldAlgorithm(int ticks) {
  //   // final initialRollovers = (ticks ~/ lifespan) * length;
  //   // final globalRemainder = ticks % lifespan;

  //   final entityTickers = List.generate(
  //     length,
  //     (i) => EntityTickerPair(entities[i], ticks),
  //   );

  //   const printingInterval = Duration(milliseconds: 500);
  //   var lastPrintTime = DateTime.fromMicrosecondsSinceEpoch(0);

  //   for (var i = 0; i < entityTickers.length; i++) {
  //     final shouldPrint =
  //         lastPrintTime.difference(DateTime.now()).abs() >= printingInterval;
  //     if (shouldPrint) {
  //       lastPrintTime = DateTime.now();
  //       final parsingPercentage = i / entityTickers.length;
  //       print(
  //         'Parsing '
  //         '${(parsingPercentage * 100).toStringAsFixed(2).padLeft(6, '0')}% '
  //         '($i/${entityTickers.length})',
  //       );
  //     }

  //     while (entityTickers[i].ticksRemaining != 0) {
  //       final etp = entityTickers[i];

  //       final tick = etp.ticksRemaining;
  //       final nextTick = tick - 1;

  //       var tickedEntity = etp.entity - 1;

  //       if (tickedEntity == -1) {
  //         tickedEntity = lifespan - 1;
  //         entityTickers.add(EntityTickerPair(newEntityLifespan, nextTick));
  //       }

  //       entityTickers[i] = EntityTickerPair(tickedEntity, nextTick);
  //     }
  //   }

  //   entities
  //     ..clear()
  //     ..addAll(entityTickers.map((e) => e.entity));
  // }

  Future<void> _runNewAlgorithm(int ticks) async {
    final entityTickers = List.generate(
      length,
      (i) => EntityTickerPair(entities[i], ticks),
    );

    final accumulatedEntities = <EntityTickerPair>[];
    final processQueue = [...entityTickers];
    do {
      print('Processing ${processQueue.length} entities...');
      final allRollovers = await Future.wait([
        for (final etp in processQueue)
          runAsIsolate<EntityTickerPair, EntityRollovers>(
            calculateRolloverAsIsolate,
            etp,
          ),
      ]);

      processQueue.clear();
      for (final rollover in allRollovers) {
        accumulatedEntities.add(EntityTickerPair(rollover.remainder, 0));
        processQueue.addAll([
          for (final tick in rollover.rolloverTicks)
            EntityTickerPair(newEntityLifespan, tick),
        ]);
      }
    } while (processQueue.isNotEmpty);

    // for (var i = 0; i < entityTickers.length; i++) {
    //   final etp = entityTickers[i];
    //   final rollover = await runAsIsolate<EntityTickerPair, EntityRollovers>(
    //     calculateRolloverAsIsolate,
    //     etp,
    //   );

    //   entityTickers.addAll([
    //     for (final tick in rollover.rolloverTicks)
    //       EntityTickerPair(newEntityLifespan, tick),
    //   ]);
    //   entityTickers[i] = EntityTickerPair(rollover.remainder, 0);
    // }

    entities
      ..clear()
      ..addAll(accumulatedEntities.map((e) => e.entity));
  }

  static EntityRollovers calculateRollover(EntityTickerPair etp) {
    final ticksUntilInitialRollover = etp.entity + 1;
    final ticksAfterInitialRollover =
        etp.ticksRemaining - ticksUntilInitialRollover;

    if (ticksAfterInitialRollover < 0) {
      return EntityRollovers(
        rolloverTicks: [],
        remainder: etp.entity - etp.ticksRemaining,
      );
    }

    final amountOfRollovers = 1 + ticksAfterInitialRollover ~/ lifespan;

    final rolloverTicks = [
      for (var i = 0; i < amountOfRollovers; i++)
        ticksAfterInitialRollover - (i * lifespan),
    ];

    return EntityRollovers(
      rolloverTicks: rolloverTicks,
      remainder: lifespan - 1 - rolloverTicks.last,
    );
  }

  static Future<void> calculateRolloverAsIsolate(SendPort port) async {
    final mainToIsolateStream = ReceivePort();
    port.send(mainToIsolateStream.sendPort);

    final etp = await mainToIsolateStream.firstWhere(
      (dynamic data) => data is EntityTickerPair,
    ) as EntityTickerPair;

    port.send(calculateRollover(etp));
  }

  @override
  String toString() {
    return '$AdvancedGrowthSimulation'
        '($ticks, $length, [${entities.join(',')}])';
  }
}

Future<R> runAsIsolate<T, R>(void Function(SendPort) fn, T payload) async {
  final completer = Completer<R>();

  late final Isolate i;

  final isolateToMainStream = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        data.send(payload);
      } else if (data is R) {
        completer.complete(data);
        i.kill();
      } else {
        throw StateError('Unrecognized data received from isolate: $data');
      }
    });

  i = await Isolate.spawn<SendPort>(fn, isolateToMainStream.sendPort);
  return completer.future;
}

/// {@template entity_ticker_pair}
/// A wrapper model containing an [entity] and how many ticks are queued for it.
/// {@endtemplate}
class EntityTickerPair {
  /// {@macro entity_ticker_pair}
  const EntityTickerPair(this.entity, this.ticksRemaining);

  final int entity;
  final int ticksRemaining;

  /// Returns a copy of this with the entity incremented and the ticks remaining
  /// decremented.
  EntityTickerPair copyWithTick() {
    return EntityTickerPair(entity + 1, ticksRemaining - 1);
  }

  @override
  String toString() =>
      'EntityTickerPair(entity: $entity, ticksRemaining: $ticksRemaining)';
}

class EntityRollovers {
  EntityRollovers({
    required this.rolloverTicks,
    required this.remainder,
  });

  final List<int> rolloverTicks;
  final int remainder;

  @override
  String toString() =>
      'EntityRollovers(rolloverTicks: $rolloverTicks, remainder: $remainder)';
}
