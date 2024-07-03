import 'package:formz/formz.dart';

// Define input validation errors
enum FirstNameError { empty }

// Extend FormzInput and provide the input type and error type.
class FirstName extends FormzInput<String, FirstNameError> {


  // Call super.pure to represent an unmodified form input.
  const FirstName.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const FirstName.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == FirstNameError.empty ) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  FirstNameError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return FirstNameError.empty;

    return null;
  }
}