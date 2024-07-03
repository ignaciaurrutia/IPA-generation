import 'package:formz/formz.dart';

// Define input validation errors
enum DueDateError { empty }

// Extend FormzInput and provide the input type and error type.
class DueDate extends FormzInput<String, DueDateError> {


  // Call super.pure to represent an unmodified form input.
  const DueDate.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const DueDate.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == DueDateError.empty ) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DueDateError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return DueDateError.empty;

    return null;
  }
}