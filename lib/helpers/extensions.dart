extension ObjectExtensions on Object {
  /// Describes this object as an enum.
  String describe() {
    return toString().split('.')[1];
  }
}
