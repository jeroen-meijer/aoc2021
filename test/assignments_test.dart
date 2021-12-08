import 'package:aoc2021/assignments/assignments.dart';
import 'package:test/test.dart';

void main() {
  group('Assignments', () {
    for (final assignment in assignments) {
      test('${assignment.id}: "${assignment.name}"', () {
        final result = assignment.result;
        print('Took: ${result.runtime.inMicroseconds / 1000} ms\n');
        print('Output:\n${result.output.join('\n')}');

        expect(result.error, isNull);

        if (assignment.hasAnswer) {
          if (!assignment.isCorrect) {
            throw TestFailure(
              'Incorrect answer.\n'
              'Expected: ${assignment.answer}\n'
              'Received: ${assignment.result.result}',
            );
          }
        }
      });
    }
  });
}
