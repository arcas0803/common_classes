import 'package:common_classes/common_classes.dart';

/// Base ControllerState class
/// [S] represents the type of the success value.
///
/// [Initial] is the initial state of the controller.
///
/// [Loading] is the state of the controller when it is loading.
///
/// [Loaded] is the state of the controller when it is loaded.
///
/// [Fail] is the state of the controller when it fails.
///
/// [Failure] is the type of the failure.
///
sealed class ControllerState<S> {
  const ControllerState();
}

final class Initial<S> extends ControllerState<S> {
  const Initial();
}

final class Loading<S> extends ControllerState<S> {
  const Loading();
}

final class Loaded<S> extends ControllerState<S> {
  const Loaded(this.value);
  final S value;
}

final class Fail<S> extends ControllerState<S> {
  const Fail(this.exception);
  final Failure exception;
}

/// Extension method to convert [Result] to [ControllerState]
///
extension ResultToControllerState<S> on Result<S> {
  ControllerState<S> toControllerState() {
    switch (this) {
      case Success<S>(value: final value):
        return Loaded(value);
      case Error<S>(exception: final failure):
        return Fail(failure);
    }
  }
}
