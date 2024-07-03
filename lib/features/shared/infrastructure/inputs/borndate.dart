import 'package:formz/formz.dart';

// Define input validation errors
enum BornDateError { empty }

// Extend FormzInput and provide the input type and error type.
class BornDate extends FormzInput<String, BornDateError> {


  // Call super.pure to represent an unmodified form input.
  const BornDate.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const BornDate.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == BornDateError.empty ) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  BornDateError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return BornDateError.empty;

    return null;
  }
}