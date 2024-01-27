import 'package:common_classes/src/failure.dart';

/// Result is a type that represents either success ([Success]) or failure ([Error]).
///
/// It is used as a return type for functions that might fail, instead of throwing an exception.
///
/// ```dart
///
///   Result<int> divide(int a, int b) {
///
///     if (b == 0) {
///       return Result.error(Failure(message:'Division by zero', error: 'DivideByZeroError', stackTrace: StackTrace.current));
///     }
///
///     return Result.success(a ~/ b);
///
///   }
///
///
sealed class Result<T> {
  const Result._();

  /// Returns the value from this [Success].
  factory Result.success(T value) = Success<T>;

  /// Returns the exception from this [Error].
  factory Result.error(Failure exception) = Error<T>;

  /// Is current state [Success] return true, otherwise false.
  bool get isSuccess => this is Success<T>;

  /// Is current state [Error] return true, otherwise false.
  bool get isError => this is Error<T>;

  /// Executes [f] and returns its value in [Success] if [f] does not throw,
  /// otherwise catches the exception and returns it in [Error].
  ///
  /// [onError] is called with the caught exception and its stack trace and the returned
  /// value is used as the exception for the returned [Error].
  ///
  static Result<T> guard<T>(
    T Function() f, {
    required Failure Function(Object, StackTrace) onError,
  }) {
    try {
      return Result.success(f.call());
    } catch (e, s) {
      final error = onError(e, s);

      return Result.error(error);
    }
  }

  /// Executes async [f] and returns its value in [Success] if [f] does not throw,
  /// otherwise catches the exception and returns it in [Error].
  ///
  /// [onError] is called with the caught exception and its stack trace and the returned
  /// value is used as the exception for the returned [Error].
  ///
  static Future<Result<T>> asyncGuard<T>(
    Future<T> Function() f, {
    required Failure Function(Object, StackTrace) onError,
  }) async {
    try {
      return Result.success(await f());
    } catch (e, s) {
      final error = onError(e, s);

      return Result.error(error);
    }
  }

  /// Executes stream [f] and returns its value in [Success] if [f] does not throw,
  /// otherwise catches the exception and returns it in [Error].
  ///
  /// [onError] is called with the caught exception and its stack trace and the returned
  /// value is used as the exception for the returned [Error].
  ///
  static Stream<Result<T>> streamGuard<T>(
    Stream<T> Function() f, {
    required Failure Function(Object, StackTrace) onError,
  }) async* {
    try {
      yield* f().map((value) => Result.success(value));
    } catch (e, s) {
      final error = onError(e, s);

      yield Result.error(error);
    }
  }

  /// When function is used to handle the result of a [Result] instance.
  ///
  /// [onSuccess] is called when the result is [Success].
  ///
  /// [onError] is called when the result is [Error].
  ///
  R when<R>({
    required R Function(Success<T> data) onSuccess,
    required R Function(Error<T> error) onError,
  }) {
    if (this is Success<T>) {
      return onSuccess(this as Success<T>);
    } else {
      return onError(this as Error<T>);
    }
  }

  /// Get the value of [Success] or null if [Error].
  ///
  T? getOrNull() {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    } else {
      return null;
    }
  }

  /// Get the value of [Success] or throw [Exception] if [Error].
  ///
  T getOrThrow() {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    } else {
      throw (this as Error<T>).exception;
    }
  }

  /// Get the error of [Error] or null if [Success].
  ///
  Failure? getErrorOrNull() {
    if (this is Error<T>) {
      return (this as Error<T>).exception;
    } else {
      return null;
    }
  }

  /// Get the error of [Error] or throw [Exception] if [Success].
  ///
  /// If [Error] is null, throw [Exception] with message.
  ///
  Failure getErrorOrThrow({String message = 'Result is not Error'}) {
    if (this is Error<T>) {
      return (this as Error<T>).exception;
    } else {
      throw Exception(message);
    }
  }
}

/// Represents a successful value of type [T].
///
final class Success<T> extends Result<T> {
  const Success(this.value) : super._();

  final T value;
}

/// Represents a failed value of type [T].
///
final class Error<T> extends Result<T> {
  const Error(this.exception) : super._();
  final Failure exception;
}
