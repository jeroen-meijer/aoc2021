import 'dart:async';

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
  bool get isCorrect => answer == null || result.result == answer;
}

class AssignmentResult<T> {
  const AssignmentResult.success({
    required this.runtime,
    required this.output,
    required this.result,
  }) : error = null;

  const AssignmentResult.failure({
    required this.runtime,
    required this.output,
    required this.error,
  }) : result = null;

  factory AssignmentResult.run(T Function() fn) {
    late final Stopwatch sw;

    final output = <String>[];
    Object? error;

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

    if (error != null) {
      return AssignmentResult.failure(
        runtime: sw.elapsed,
        output: output,
        error: error,
      );
    }

    return AssignmentResult.success(
      runtime: sw.elapsed,
      output: output,
      result: value,
    );
  }

  final Duration runtime;
  final List<String> output;
  final T? result;
  final Object? error;
}
