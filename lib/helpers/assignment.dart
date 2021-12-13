import 'dart:async';

/// Returns a value that represents the absence of an answer to an assignment.
///
/// **Only call and return this value while running an assignment.**
/// Calling this multiple times or outside of an assignment execution will
/// result in a [StateError].
T noAnswer<T>() {
  final didAnswer = AssignmentResult._didAnswerCurrentAssignment;
  final isRunningAssignment = didAnswer != null;
  final alreadyAnswered = didAnswer == false;

  if (!isRunningAssignment) {
    throw StateError('noAnswer() called when no assignment was being run.');
  } else if (alreadyAnswered) {
    throw StateError('noAnswer() called more than once.');
  } else {
    AssignmentResult._didAnswerCurrentAssignment = false;
  }

  return _noAnswerValue<T>();
}

T _noAnswerValue<T>() {
  if (T == int || T == num) {
    return -1 as T;
  } else if (T == double) {
    return -1.0 as T;
  } else if (T == String) {
    return '' as T;
  } else {
    throw ArgumentError.value(
      T,
      'T: <$T>',
      'No wildcard found to match against type $T',
    );
  }
}

/// Assignment class that contains the id, name, expected answer and function
/// to run for a given assignment.
class Assignment<T> {
  Assignment({
    required this.id,
    required this.name,
    required this.answer,
    required this.fn,
  }) {
    result = AssignmentResult.run(fn);
  }

  final String id;
  final String name;
  final T? answer;
  final T Function() fn;
  late final AssignmentResult<T> result;

  bool get hasAnswer => answer != null;
  bool get hasResult => result.didAnswer && result.result != null;
  bool get isCorrect => hasAnswer && hasResult && result.result == answer;
}

class AssignmentResult<T> {
  const AssignmentResult.success({
    required this.runtime,
    required this.output,
    required this.result,
  })  : didAnswer = true,
        error = null;

  const AssignmentResult.failure({
    required this.runtime,
    required this.output,
    required this.error,
  })  : didAnswer = true,
        result = null;

  const AssignmentResult.didNotAnswer({
    required this.runtime,
    required this.output,
  })  : didAnswer = false,
        result = null,
        error = null;

  factory AssignmentResult.run(T Function() fn) {
    late final Stopwatch sw;

    final output = <String>[];
    Object? error;

    _didAnswerCurrentAssignment = true;

    final value = runZoned(
      () {
        sw = Stopwatch()..start();
        try {
          final result = fn();
          return result;
        } catch (e) {
          error = e;
        } finally {
          sw.stop();
        }
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          output.add(line);
        },
      ),
    );

    late final AssignmentResult<T> ar;

    if (!_didAnswerCurrentAssignment!) {
      if (value != _noAnswerValue<T>()) {
        throw StateError(
          'Assignment was instructed to give no answer, but returned value '
          'is not the no-answer token. When not giving an answer, be sure to '
          'return the value given by "noAnswer()".',
        );
      }
      ar = AssignmentResult.didNotAnswer(
        runtime: sw.elapsed,
        output: output,
      );
    } else if (error != null) {
      ar = AssignmentResult.failure(
        runtime: sw.elapsed,
        output: output,
        error: error,
      );
    } else {
      ar = AssignmentResult.success(
        runtime: sw.elapsed,
        output: output,
        result: value,
      );
    }

    _didAnswerCurrentAssignment = null;

    return ar;
  }

  static bool? _didAnswerCurrentAssignment;

  final Duration runtime;
  final List<String> output;
  final bool didAnswer;
  final T? result;
  final Object? error;
}
