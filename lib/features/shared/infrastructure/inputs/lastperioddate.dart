import 'package:formz/formz.dart';

// Define input validation errors
enum LastPeriodDateError { empty }

// Extend FormzInput and provide the input type and error type.
class LastPeriodDate extends FormzInput<String, LastPeriodDateError> {


  // Call super.pure to represent an unmodified form input.
  const LastPeriodDate.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const LastPeriodDate.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == LastPeriodDateError.empty ) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  LastPeriodDateError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return LastPeriodDateError.empty;

    return null;
  }
}