import 'package:formz/formz.dart';

// Define input validation errors
enum HeightError { empty, outOfRange }

// Extend FormzInput and provide the input type and error type.
class Height extends FormzInput<double, HeightError> {

  // Call super.pure to represent an unmodified form input.
  const Height.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const Height.dirty(double value) : super.dirty(value);

  // Provide error message based on the type of error
  String? get errorMessage {
    if (isValid || isPure) return null;

    switch (displayError) {
      case HeightError.empty:
        return 'El campo es requerido';
      case HeightError.outOfRange:
        return 'Debe ser un número entre 140 y 210';
      default:
        return null; // Return null if there's no error.
    }
  }

  // Override validator to handle validating a given input value.
  @override
  HeightError? validator(double value) {
    // Check if the value is empty
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return HeightError.empty;
    }
    // Check if the value is out of the valid range
    if (value < 140 || value > 210) {
      return HeightError.outOfRange;
    }

    return null; // Return null if there's no error.
  }
}
