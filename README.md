# Documentación del paquete `common_classes`

Este paquete proporciona clases comunes para manejar resultados y errores en Dart.

## Clase `Result`

La clase `Result` se utiliza para representar el resultado de una operación que puede tener éxito o fallar. Tiene dos subclases, `Success` y `Error`, que representan los casos de éxito y error respectivamente.

### Uso

```dart
// Caso de éxito
var successResult = Result<int>.success(10);

// Caso de error
var errorResult = Result<int>.error(Failure(message: 'Algo salió mal', error: 'Error', stackTrace: StackTrace.current));

// Obtener el valor del resultado

// Caso de éxito

if (successResult.isSuccess) {
  print(successResult.value); // 10
}

// Caso de error

if (errorResult.isError) {
  print(errorResult.failure.message); // Algo salió mal
  print(errorResult.failure.error); // Error
  print(errorResult.failure.stackTrace); // StackTrace
}
```



### Métodos

La clase `Result` proporciona los siguientes métodos:

- `guard`: Este método se utiliza para manejar excepciones. Acepta una función que puede lanzar una excepción y una función de error que se invoca si se lanza una excepción.

```dart
var guardedResult = Result.guard<int>(() {
    // Intenta dividir por cero para lanzar una excepción
    return 10 ~/ 0;
}, onError: (e, s) => Failure(message: e.toString(), error: 'DivideByZeroError', stackTrace: s));

if (guardedResult.isError) {
    print('Guarded Error: ${guardedResult.exception.message}');
}

// Salida: Guarded Error: IntegerDivisionByZeroException
```

- `asyncGuard`: Similar al método `guard`, pero para funciones asíncronas.

```dart

Result.asyncGuard<int>(() async {
    // Intenta dividir por cero para lanzar una excepción
    return Future.value(10 ~/ 0);
}, onError: (e, s) => Failure(message: e.toString(), error: 'DivideByZeroError', stackTrace: s)).then((result) {
    if (result.isError) {
        print('Async Guarded Error: ${result.exception.message}');
    }
});

- `when`: Este método se utiliza para transformar el valor de un resultado. Acepta una función que toma el valor actual del resultado y devuelve un nuevo valor.

```dart

var successResult = Result<int>.success(10);

var transformedResult = successResult.when(
    success: (value) => print(value * 2),
    error: (failure) => print(failure.exception.message)
);

// Salida: 20
```



## Clase `Failure`

La clase `Failure` se utiliza para representar un error. Tiene tres propiedades, `message`, `error` y `stackTrace`, que representan el mensaje de error, el tipo de error y la traza de la pila respectivamente.

### Uso

```dart

class MyException implements Exception {
    final String message;
    final String error;
    final StackTrace stackTrace;

    MyException({super.message, super.error, super.stackTrace});
}

var myFailure = MyException(message: 'Algo salió mal', error: 'Error', stackTrace: StackTrace.current);

print(myFailure.message); // Algo salió mal

print(myFailure.error); // Error


```

