import 'package:aoc2021/assignments/assignments.dart';
import 'package:aoc2021/helpers/helpers.dart';

void main([List<String>? args]) {
  int? number;
  if (args?.isNotEmpty ?? false) {
    number = int.tryParse(args!.first);
  }

  if (number != null) {
    if (number > assignments.length) {
      throw ArgumentError.value(
        number,
        'number',
        'The provided assignment number must be included in the list of '
            'assignments (1 through ${assignments.length}).',
      );
    }
    runAssignment(assignments[number - 1]);
  } else {
    for (final assignment in assignments) {
      runAssignment(assignment);
    }
  }
}

void runAssignment(Assignment assignment) {
  print('Assignment ${assignment.id}: "${assignment.name}"');

  final result = assignment.result;
  print('Took: ${result.runtime.inMicroseconds / 1000} ms');
  if (result.error != null) {
    print('❌ FAILURE!');
    print(_indent('${result.error}'));
    if (result.output.isNotEmpty) {
      print('Full output:');
      print(_indent(result.output.join('\n'), trim: false));
    }
  } else {
    if (assignment.hasAnswer) {
      if (assignment.isCorrect) {
        print('✅ SUCCESS! Correct answer given.');
        print('Result:');
        print(_indent('${result.result}'));
        if (result.output.isNotEmpty) {
          print('Output:');
          print(_indent(result.output.join('\n')));
        }
      } else {
        print('❌ FAILURE! Wrong answer given.');
        print('Expected:');
        print(_indent('${assignment.answer}', trim: false));
        print('Received:');
        print(_indent('${result.result}', trim: false));
        if (result.output.isNotEmpty) {
          print('Full output:');
          print(_indent(result.output.join('\n'), trim: false));
        }
      }
    } else {
      print('✅ SUCCESS!');
      print('Result:');
      print(_indent('${result.result}'));
      if (result.output.isNotEmpty) {
        print('Output:');
        print(_indent(result.output.join('\n')));
      }
    }
  }
  print('=================================');
}

String _indent(
  Object message, {
  int level = 2,
  bool trim = true,
}) {
  const trimLineCount = 4;

  var lines =
      message.toString().split('\n').map((line) => '${' ' * level}$line');

  if (trim && lines.length > trimLineCount) {
    lines = [...lines.take(trimLineCount), '${' ' * level}...'];
  }

  return lines.join('\n');
}
