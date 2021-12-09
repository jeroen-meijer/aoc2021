import 'dart:math' as math;

import 'package:aoc2021/helpers/helpers.dart';

final assignment3_2 = Assignment<int>(
  id: 'Day 3 Part 2',
  name: 'Binary Diagnostic - Part 2',
  answer: 2817661,
  fn: _run,
);

const bitLength = 12;
final mask = ('1' * bitLength).asBinary;

int _run() {
  final data = getAssignmentData('3_2').map((line) => line.asBinary).toList();

  final oxygenRating = getByteByBitCriterium(data, keepMostCommon: true);
  final co2Rating = getByteByBitCriterium(data, keepMostCommon: false);

  print('Oxygen generator rating: $oxygenRating');
  print('CO2 scrubber rating: $co2Rating');

  final lifeSupportRating = oxygenRating * co2Rating;

  print('Life support rating: $lifeSupportRating');

  return lifeSupportRating;
}

int getByteByBitCriterium(
  List<int> data, {
  required bool keepMostCommon,
}) {
  final candidates = [...data];

  for (var i = 0; i < bitLength; i++) {
    // FIXME: Does not conform to variable bit length, but string version
    // performs worse.
    final andMask = (math.pow(2, bitLength - 1) as int) >> i;

    final zerosList = <int>[];
    final onesList = <int>[];

    for (final number in candidates) {
      final currentBit = (number & andMask) >> (bitLength - i - 1);
      if (currentBit == 0) {
        zerosList.add(number);
      } else {
        onesList.add(number);
      }
    }

    candidates.clear();

    final zerosListIsBigger = zerosList.length > onesList.length;

    if (keepMostCommon) {
      candidates.addAll(zerosListIsBigger ? zerosList : onesList);
    } else {
      candidates.addAll(zerosListIsBigger ? onesList : zerosList);
    }

    if (candidates.length == 1) {
      break;
    }
    zerosList.clear();
    onesList.clear();
  }

  return candidates.first;
}

extension on String {
  int get asBinary => int.parse(this, radix: 2);
}
