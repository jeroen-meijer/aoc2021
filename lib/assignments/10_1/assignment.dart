import 'dart:collection';

import 'package:aoc2021/helpers/helpers.dart';

final assignment10_1 = Assignment<int>(
  id: 'Day 10 Part 1',
  name: 'Syntax Scoring - Part 1',
  answer: null,
  fn: _run,
);

int _run() {
  final data = getAssignmentData('10_1');
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

  final totalScore = corruptLines
      .map((l) => l.invalidChar!.score)
      .reduce((acc, cur) => acc + cur);
  print('Total score: $totalScore');

  return totalScore;
}

class ChunkLine {
  const ChunkLine._({
    required this.data,
    this.isComplete = true,
    this.invalidChar,
  }) : assert(
          isComplete || invalidChar == null,
          'A chunk line cannot be both incomplete and corrupted.',
        );

  factory ChunkLine.parse(String data) {
    final chars = data.split('');
    final charStack = Stack<String>();

    for (var i = 0; i < chars.length; i++) {
      final char = chars[i];
      final entryCharIndex = _entryChars.indexOf(char);
      if (entryCharIndex != -1) {
        final exitChar = _exitChars[entryCharIndex];
        charStack.add(exitChar);
      } else {
        if (charStack.isEmpty) {
          return ChunkLine._(
            data: data,
            invalidChar: InvalidChunkChar.unexpectedChar(
              index: i,
              char: char,
            ),
          );
        } else {
          final expectedChar = charStack.pop();
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

    return ChunkLine._(
      data: data,
      isComplete: charStack.isEmpty,
    );
  }

  static const _entryChars = ['(', '[', '{', '<'];
  static const _exitChars = [')', ']', '}', '>'];

  final String data;
  final bool isComplete;
  final InvalidChunkChar? invalidChar;

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

class Stack<T> extends ListQueue<T> {
  void push(T e) => add(e);
  T pop() => removeLast();
}
