T time<T>(String description, T Function() fn) {
  print('Timing "$description"...');
  final sw = Stopwatch()..start();
  final res = fn();
  sw.stop();
  print('"$description" took ${sw.elapsedMicroseconds / 1000} ms');
  return res;
}
