import 'dart:collection';

import 'package:aoc2021/helpers/helpers.dart';

final assignment10_2 = Assignment<int>(
  id: 'Day 10 Part 2',
  name: 'Syntax Scoring - Part 2',
  answer: 2289754624,
  fn: _run,
);

int _run() {
  final data = getAssignmentData('10_2');
  // final data = [
  //   '[({(<(())[]>[[{[]{<()<>>',
  //   '[(()[<>])]({[<{<<[]>>(',
  //   '{([(<{}[<>[]}>{[]{[(<()>',
  //   '(((({<>}<{<{<>}{[]{[]{}',
  //   '[[<[([]))<([[{}[[()]]]',
  //   '[{[{({}]{}}([{[{{{}}([]',
  //   '{<[[]]>}<{[{[{[]{()[[[]',
  //   '[<(<(<(<{}))><([]([]()',
  //   '<{([([[(<>()){}]>(<<{{',
  //   '<{([{{}}[<[[[<>{}]]]>[]]',
  // ];

  final lines = data.map((l) => ChunkLine.parse(l)).toList();
  print('Chunk lines: ${lines.length}');

  final corruptLines = lines.where((l) => l.isCorrupt);
  print('Corrupt lines: ${corruptLines.length}');

  final errorScore = corruptLines
      .map((l) => l.invalidChar!.score)
      .reduce((acc, cur) => acc + cur);
  print('Error score: $errorScore');

  final incompleteLines = lines.where((l) => l.isIncomplete);
  print('Incomplete lines: ${incompleteLines.length}');

  final completionScores =
      incompleteLines.map((l) => l.completionData!.score).toList()..sort();
  final medianCompletionScore = completionScores[completionScores.length ~/ 2];
  print('Median completion score: $medianCompletionScore');

  return medianCompletionScore;
}

class ChunkLine {
  const ChunkLine._({
    required this.data,
    this.completionData,
    this.invalidChar,
  }) : assert(
          completionData == null || invalidChar == null,
          'A chunk line cannot be both incomplete and corrupted.',
        );

  factory ChunkLine.parse(String data) {
    final chars = data.split('');
    final exitCharStack = Stack<String>();

    for (var i = 0; i < chars.length; i++) {
      final char = chars[i];
      final entryCharIndex = _entryChars.indexOf(char);
      if (entryCharIndex != -1) {
        final exitChar = _exitChars[entryCharIndex];
        exitCharStack.add(exitChar);
      } else {
        if (exitCharStack.isEmpty) {
          return ChunkLine._(
            data: data,
            invalidChar: InvalidChunkChar.unexpectedChar(
              index: i,
              char: char,
            ),
          );
        } else {
          final expectedChar = exitCharStack.pop();
          if (char != expectedChar) {
            return ChunkLine._(
              data: data,
              invalidChar: InvalidChunkChar.incorrectChar(
                index: i,
                char: char,
                expectedChar: expectedChar,
              ),
            );
          }
        }
      }
    }

    final completionData = exitCharStack.isEmpty
        ? null
        : CompletionData(exitCharStack.toList().reversed.toList());

    return ChunkLine._(
      data: data,
      completionData: completionData,
    );
  }

  static const _entryChars = ['(', '[', '{', '<'];
  static const _exitChars = [')', ']', '}', '>'];

  final String data;
  final CompletionData? completionData;
  final InvalidChunkChar? invalidChar;

  bool get isIncomplete => completionData != null;
  bool get isCorrupt => invalidChar != null;

  int get length => data.length;

  @override
  String toString() {
    return '$ChunkLine("$data")';
  }
}

class InvalidChunkChar {
  const InvalidChunkChar.unexpectedChar({
    required this.index,
    required this.char,
  }) : expectedChar = null;

  const InvalidChunkChar.incorrectChar({
    required this.index,
    required this.char,
    required this.expectedChar,
  });

  final int index;
  final String char;
  final String? expectedChar;

  static const _errorScoreMap = {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137,
  };

  int get score => _errorScoreMap[char]!;
}

class CompletionData {
  const CompletionData(this.chars);

  final List<String> chars;

  static const _completionScoreMap = {
    ')': 1,
    ']': 2,
    '}': 3,
    '>': 4,
  };

  int get score {
    var currentScore = 0;
    for (final char in chars) {
      currentScore *= 5;
      currentScore += _completionScoreMap[char]!;
    }
    return currentScore;
  }
}

class Stack<T> extends ListQueue<T> {
  void push(T e) => add(e);
  T pop() => removeLast();
}
