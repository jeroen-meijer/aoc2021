import 'dart:async';

T noAnswer<T>() {
  AssignmentResult._didAnswerCurrentAssignment = false;

  if (T == int) {
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

    if (!_didAnswerCurrentAssignment) {
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

    return ar;
  }

  static var _didAnswerCurrentAssignment = false;

  final Duration runtime;
  final List<String> output;
  final bool didAnswer;
  final T? result;
  final Object? error;
}
