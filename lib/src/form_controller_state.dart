/// Form state is a sealed class that represents the state of a form
///
/// [S] represents the model of the form
///
/// [FormControllerStateValid] represents a valid form
///
/// [FormControllerStateInvalid] represents an invalid form
///
sealed class FormControllerState<S> {
  const FormControllerState();
}

final class FormControllerStateValid<S> extends FormControllerState<S> {
  const FormControllerStateValid({required this.value});
  final S value;
}

final class FormControllerStateInvalid<S> extends FormControllerState<S> {
  const FormControllerStateInvalid();
}
