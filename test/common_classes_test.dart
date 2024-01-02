import 'package:common_classes/src/failure.dart';
import 'package:common_classes/src/result.dart';
import 'package:test/test.dart';

class InfiniteFailure extends Failure {
  const InfiniteFailure({
    required super.message,
    required super.error,
    required super.stackTrace,
  });
}

class UnknowFailure extends Failure {
  const UnknowFailure({
    required super.message,
    required super.error,
    required super.stackTrace,
  });
}

void main() {
  Result<int> divide(int a, int b) {
    if (b == 0) {
      return Result<int>.error(
        InfiniteFailure(
          message: 'Division by zero',
          error: 'DivideByZeroError',
          stackTrace: StackTrace.current,
        ),
      );
    }

    return Result.success(a ~/ b);
  }

  group('Result class tests', () {
    test('divide success case', () {
      var result = divide(10, 2);
      expect(result.isSuccess, isTrue);
      expect(result.isError, isFalse);
      expect((result as Success).value, equals(5));
    });

    test('divide error case', () {
      var result = divide(10, 0);
      expect(result.isError, isTrue);
      expect(result.isSuccess, isFalse);
      expect((result as Error).exception.message, equals('Division by zero'));
      expect((result as Error).exception.error, equals('DivideByZeroError'));
    });

    test('guard success case', () {
      var result = Result.guard(
        () => 10,
        onError: (e, s) {
          return InfiniteFailure(
            message: e.toString(),
            error: 'Error',
            stackTrace: s,
          );
        },
      );
      expect(result.isSuccess, isTrue);
      expect(result.isError, isFalse);
      expect((result as Success).value, equals(10));
    });

    test('guard error case', () {
      var result = Result.guard(
        () {
          final result = 10 / 0;
          if (result.isInfinite) {
            throw Exception('Division by zero');
          }
        },
        onError: (e, s) {
          return InfiniteFailure(
            message: 'Division by zero',
            error: e.toString(),
            stackTrace: s,
          );
        },
      );
      expect(result.isError, isTrue);
      expect(result.isSuccess, isFalse);
      expect((result as Error).exception.message, equals('Division by zero'));
    });

    test('asyncGuard success case', () async {
      var result = await Result.asyncGuard<int>(
        () async => Future.value(10),
        onError: (e, s) {
          return InfiniteFailure(
            message: e.toString(),
            error: 'Error',
            stackTrace: s,
          );
        },
      );
      expect(result.isSuccess, isTrue);
      expect(result.isError, isFalse);
      expect((result as Success).value, equals(10));
    });

    test('asyncGuard error case', () async {
      var result = await Result.asyncGuard<int>(
        () async => throw Exception('Test exception'),
        onError: (e, s) => InfiniteFailure(
          message: 'Division by zero',
          error: e.toString(),
          stackTrace: s,
        ),
      );
      expect(result.isError, isTrue);
      expect(result.isSuccess, isFalse);
      expect((result as Error).exception.message, equals('Division by zero'));
    });
  });
}
