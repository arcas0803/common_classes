import 'package:common_classes/common_classes.dart';
import 'package:common_classes/src/failure.dart';

class ExampleFailure extends Failure {
  const ExampleFailure({
    required super.message,
    required super.error,
    required super.stackTrace,
  });
}

void main() {
  // Caso de éxito
  var successResult = Result<int>.success(10);
  if (successResult.isSuccess) {
    print('Success: ${(successResult as Success<int>).value}');
  }

  // Caso de error
  var errorResult = Result<int>.error(
    ExampleFailure(
      message: 'Algo salió mal',
      error: 'Error',
      stackTrace: StackTrace.current,
    ),
  );
  if (errorResult.isError) {
    print('Error: ${(errorResult as Error<int>).exception.message}');
  }

  // Usando guard para manejar excepciones
  var guardedResult = Result.guard<int>(
    () {
      // Intenta dividir por cero para lanzar una excepción
      return 10 ~/ 0;
    },
    onError: (e, s) => ExampleFailure(
      message: e.toString(),
      error: 'DivideByZeroError',
      stackTrace: s,
    ),
  );

  if (guardedResult.isError) {
    print('Guarded Error: ${(guardedResult as Error<int>).exception.message}');
  }

  // Usando asyncGuard para manejar excepciones en operaciones asíncronas
  Result.asyncGuard<int>(() async {
    // Intenta dividir por cero para lanzar una excepción
    return Future.value(10 ~/ 0);
  },
      onError: (e, s) => ExampleFailure(
          message: e.toString(),
          error: 'DivideByZeroError',
          stackTrace: s)).then((result) {
    if (result.isError) {
      print('Async Guarded Error: ${(result as Error<int>).exception.message}');
    }
  });
}
