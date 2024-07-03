import 'package:formz/formz.dart';

// Define input validation errors
enum RequiredError { empty }

// Extend FormzInput and provide the input type and error type.
class Required extends FormzInput<String, RequiredError> {


  // Call super.pure to represent an unmodified form input.
  const Required.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Required.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == RequiredError.empty ) return 'El atributo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  RequiredError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return RequiredError.empty;

    return null;
  }
}