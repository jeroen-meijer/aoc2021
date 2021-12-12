import 'dart:io';

import 'package:path/path.dart' as path;

/// Returns the working directory for a given assignment.
String getAssignmentDir(String assignmentPath) {
  return path.join(
    Directory.current.path,
    'lib',
    'assignments',
    assignmentPath,
  );
}

/// Returns the data text file for a given assignment as a list of lines of
/// text.
List<String> getAssignmentData(
  String assignmentPath, {
  String fileName = 'data.txt',
}) {
  final file = File(path.join(getAssignmentDir(assignmentPath), fileName));
  final lines = file.readAsLinesSync();
  if (lines.isNotEmpty && lines.last.isEmpty) {
    lines.removeLast();
  }
  return lines.toList();
}
