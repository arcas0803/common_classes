/// Failure class
///
/// This class is used to represent a failure.
///
/// [message] is a human-readable message describing the error.
///
/// [error] is a string representing the error code.
///
/// [stackTrace] is a [StackTrace] object representing the stack trace at the point where the error occurred.
///
abstract class Failure {
  const Failure({
    required this.message,
    required this.error,
    required this.stackTrace,
  });
  final String message;
  final String error;
  final StackTrace stackTrace;

  @override
  String toString() => ''' 
  Failure
  message: $message, 
  Error: $error,
  StackTrace: $stackTrace,
  ''';
}
