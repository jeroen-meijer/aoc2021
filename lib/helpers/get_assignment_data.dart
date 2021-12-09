import 'dart:io';

import 'package:path/path.dart' as path;

/// Returns the data text file for a given assignment as a list of lines of
/// text.
List<String> getAssignmentData(
  String assignmentPath, {
  String fileName = 'data.txt',
}) {
  final dirPath = path.join(
    Directory.current.path,
    'lib',
    'assignments',
    assignmentPath,
  );
  final file = File(path.join(dirPath, fileName));
  return file.readAsLinesSync();
}
