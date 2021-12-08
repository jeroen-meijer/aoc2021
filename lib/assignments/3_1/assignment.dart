import 'dart:io';

import 'package:aoc2021/helpers/helpers.dart';
import 'package:path/path.dart' as path;

final assignment3_1 = Assignment<int>(
  id: 'Day 3 Part 1',
  name: 'Binary Diagnostic - Part 1',
  answer: 2035764,
  fn: _run,
);

const bitLength = 12;
final mask = ('1' * bitLength).asBinary;

int _run() {
  final dirPath = path.join(
    Directory.current.path,
    'lib',
    'assignments',
    '3_1',
  );
  final file = File(path.join(dirPath, 'data.txt'));
  final lines = file.readAsLinesSync();
  final data = lines.map((line) => line.asBinary).toList();

  final bitBalance = List.generate(bitLength, (_) => 0);

  for (final number in data) {
    for (var i = 0; i < bitLength; i++) {
      final andMask = 1 << i;
      final currentBit = (number & andMask) >> i;
      bitBalance[bitLength - 1 - i] += currentBit == 1 ? 1 : -1;
    }
  }

  print('Bit balance: $bitBalance');

  final gammaRate =
      bitBalance.fold('', (acc, cur) => '$acc${cur > 0 ? '1' : '0'}').asBinary;
  final epsilonRate = gammaRate ^ mask;

  print('Gamma rate: $gammaRate');
  print('Epsilon rate: $epsilonRate');

  final powerConsumption = gammaRate * epsilonRate;

  print('Power consumption: $powerConsumption');

  return gammaRate * epsilonRate;
}

extension on String {
  int get asBinary => int.parse(this, radix: 2);
}
